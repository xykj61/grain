import XCTest

@testable import SkateCore

@available(macOS 26.0, *)
final class ConsentRailTests: XCTestCase {
  func testEveryAnimatedStateSettlesToStillInsideDeclaredDuration() throws {
    let rail = try fixture()
    for disclosure in [ConsentRail.Disclosure.folded, .expanded] {
      XCTAssertNil(
        try rail.settle(
          to: disclosure,
          elapsedMilliseconds: ConsentRail.settleDurationMilliseconds - 1,
          reducedMotion: false
        )
      )
      XCTAssertEqual(
        try rail.settle(
          to: disclosure,
          elapsedMilliseconds: ConsentRail.settleDurationMilliseconds,
          reducedMotion: false
        ),
        rail.still(disclosure: disclosure)
      )
      XCTAssertEqual(
        try rail.settle(to: disclosure, elapsedMilliseconds: 0, reducedMotion: true),
        rail.still(disclosure: disclosure)
      )
    }
  }

  func testAccessibilityReadsTheRenderedBytesInOrder() throws {
    let rail = try fixture()
    let frame = rail.still(disclosure: .expanded)
    XCTAssertEqual(frame.lineCount, 4)
    XCTAssertEqual(
      String(decoding: try XCTUnwrap(frame.accessibilityLine(row: 0)), as: UTF8.self),
      "consent  offered"
    )
    XCTAssertEqual(
      String(decoding: try XCTUnwrap(frame.accessibilityLine(row: 1)), as: UTF8.self),
      "purpose  habitat-planning"
    )
    XCTAssertEqual(
      String(decoding: try XCTUnwrap(frame.accessibilityLine(row: 2)), as: UTF8.self),
      "party    org:sample-steward"
    )
    XCTAssertEqual(
      String(decoding: try XCTUnwrap(frame.accessibilityLine(row: 3)), as: UTF8.self),
      "expires  20261012.120000-0400"
    )
  }

  func testRendererLossAndHiddenDocumentReturnCompleteStillFrame() throws {
    let rail = try fixture()
    for disclosure in [ConsentRail.Disclosure.folded, .expanded] {
      let still = rail.still(disclosure: disclosure)
      XCTAssertEqual(
        try rail.present(disclosure: disclosure, elapsedMilliseconds: 0, condition: .rendererLost),
        still
      )
      XCTAssertEqual(
        try rail.present(
          disclosure: disclosure,
          elapsedMilliseconds: ConsentRail.rendererBootDeadlineMilliseconds - 1,
          condition: .rendererLost
        ),
        still
      )
      XCTAssertEqual(
        try rail.present(
          disclosure: disclosure,
          elapsedMilliseconds: 0,
          condition: .documentHidden
        ),
        still
      )
    }
  }

  func testEveryPresentationConditionKeepsAccessibilityParity() throws {
    let rail = try fixture()
    let expected = rail.still(disclosure: .expanded)
    let conditions: [ConsentRail.PresentationCondition] = [
      .visible, .reducedMotion, .rendererLost, .documentHidden,
    ]
    for condition in conditions {
      let elapsed = condition == .visible ? ConsentRail.settleDurationMilliseconds : 0
      let frame = try XCTUnwrap(
        rail.present(disclosure: .expanded, elapsedMilliseconds: elapsed, condition: condition)
      )
      XCTAssertEqual(frame, expected)
      for row in 0..<frame.lineCount {
        XCTAssertEqual(frame.accessibilityLine(row: row), expected.accessibilityLine(row: row))
      }
    }
  }

  func testResponsePulseHasFixedLifeAndChangesNoFrame() throws {
    let rail = try fixture()
    let before = rail.still(disclosure: .expanded)
    XCTAssertTrue(try rail.responds(elapsedMilliseconds: 0))
    XCTAssertTrue(
      try rail.responds(elapsedMilliseconds: ConsentRail.pulseLifetimeMilliseconds - 1)
    )
    XCTAssertFalse(
      try rail.responds(elapsedMilliseconds: ConsentRail.pulseLifetimeMilliseconds)
    )
    XCTAssertEqual(rail.still(disclosure: .expanded), before)
  }

  func testInputAndComposedWidthRefuseBeforePublishingAValue() throws {
    XCTAssertThrowsError(try fixture(purpose: "")) { error in
      XCTAssertEqual(error as? ConsentRail.RailError, .emptyField("purpose"))
    }
    XCTAssertThrowsError(try fixture(purpose: "habitat-🐝")) { error in
      XCTAssertEqual(error as? ConsentRail.RailError, .nonASCII("purpose"))
    }
    XCTAssertThrowsError(try fixture(purpose: String(repeating: "p", count: 80))) { error in
      XCTAssertEqual(
        error as? ConsentRail.RailError,
        .fieldTooWide(field: "rendered_row_1", limit: ConsentRail.columns)
      )
    }
  }

  private func fixture(purpose: String = "habitat-planning") throws -> ConsentRail {
    try ConsentRail(
      purpose: purpose,
      recipientID: "org:sample-steward",
      expiresAt: "20261012.120000-0400",
      consentStatus: "offered"
    )
  }
}
