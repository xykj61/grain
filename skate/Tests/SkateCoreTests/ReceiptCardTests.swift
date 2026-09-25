import XCTest

@testable import SkateCore

@available(macOS 26.0, *)
final class ReceiptCardTests: XCTestCase {
  func testFixtureRendersDeterministicallyAndAccessibilityReadsSameBytes() throws {
    let first = try fixture()
    let second = try fixture()

    XCTAssertEqual(first, second)
    XCTAssertEqual(first.lineCount, 12)
    XCTAssertLessThanOrEqual(first.lineCount, ReceiptCard.rows)

    var row = 0
    while row < first.lineCount {
      let semantic = try XCTUnwrap(first.accessibilityLine(row: row))
      var column = 0
      while column < semantic.count {
        XCTAssertEqual(first.byte(row: row, column: column), semantic[column])
        column += 1
      }
      XCTAssertLessThanOrEqual(semantic.count, ReceiptCard.columns)
      row += 1
    }

    XCTAssertEqual(
      String(decoding: try XCTUnwrap(first.accessibilityLine(row: 5)), as: UTF8.self),
      "value    1200 USD-cent-simulated"
    )
    XCTAssertEqual(
      String(decoding: try XCTUnwrap(first.accessibilityLine(row: 10)), as: UTF8.self),
      "status   offered"
    )
  }

  func testEveryFieldRefusalNamesItsBoundary() throws {
    XCTAssertThrowsError(try fixture(purpose: "")) { error in
      XCTAssertEqual(error as? ReceiptCard.CardError, .emptyField("purpose"))
    }
    XCTAssertThrowsError(try fixture(purpose: "pollinator 🐝")) { error in
      XCTAssertEqual(error as? ReceiptCard.CardError, .nonASCII("purpose"))
    }
    XCTAssertThrowsError(
      try fixture(purpose: String(repeating: "p", count: ReceiptCard.purposeByteLimit + 1))
    ) { error in
      XCTAssertEqual(
        error as? ReceiptCard.CardError,
        .fieldTooWide(field: "purpose", limit: ReceiptCard.purposeByteLimit)
      )
    }
    XCTAssertThrowsError(try fixture(offeredValue: 9_000_000_001)) { error in
      XCTAssertEqual(
        error as? ReceiptCard.CardError,
        .amountOutOfBounds(limit: 9_000_000_000)
      )
    }
  }

  func testControlBytesRefuseBeforeTheCardIsPublished() throws {
    for control in ["\n", "\u{001B}", "\u{007F}"] {
      XCTAssertThrowsError(try fixture(purpose: "habitat\(control)planning")) { error in
        XCTAssertEqual(error as? ReceiptCard.CardError, .nonPrintableASCII("purpose"))
      }
    }
  }

  func testComposedLineRefusesBeforePublishingAPartialCard() throws {
    XCTAssertThrowsError(
      try fixture(receiptID: String(repeating: "r", count: ReceiptCard.identifierByteLimit))
    ) { error in
      XCTAssertEqual(
        error as? ReceiptCard.CardError,
        .cardLineTooWide(row: 1, limit: ReceiptCard.columns)
      )
    }
  }

  private func fixture(
    receiptID: String = "receipt:sample-pollinator-counts:20260912",
    purpose: String = "habitat-planning",
    offeredValue: UInt64 = 1200
  ) throws -> ReceiptCard {
    try ReceiptCard(
      receiptID: receiptID,
      productID: "data:weekly-pollinator-counts",
      purpose: purpose,
      recipientID: "org:sample-steward",
      offeredValue: offeredValue,
      valueUnit: "USD-cent-simulated",
      valueBasis: "one-purpose license offer",
      promisedReturn: "service-credit",
      issuedAt: "20260912.120000-0400",
      expiresAt: "20261012.120000-0400",
      status: "offered"
    )
  }
}
