import XCTest

@testable import SkateCore

@available(macOS 26.0, *)
final class EventRingTests: XCTestCase {
  func testEventRingFillsThenRefusesWithoutEviction() throws {
    var ring = EventRing<Int>()
    for event in 0..<SkateCoreBounds.eventCapacity {
      try ring.append(event)
    }

    let headBefore = ring.head
    let tailBefore = ring.tail
    let firstBefore = ring.first()
    XCTAssertThrowsError(try ring.append(SkateCoreBounds.eventCapacity)) { error in
      XCTAssertEqual(
        error as? EventRingError,
        .full(limit: SkateCoreBounds.eventCapacity)
      )
    }
    XCTAssertEqual(ring.head, headBefore)
    XCTAssertEqual(ring.tail, tailBefore)
    XCTAssertEqual(ring.count, SkateCoreBounds.eventCapacity)
    XCTAssertEqual(ring.first(), firstBefore)

    for event in 0..<SkateCoreBounds.eventCapacity {
      XCTAssertEqual(ring.removeFirst(), event)
    }
    XCTAssertNil(ring.removeFirst())
    XCTAssertTrue(ring.isEmpty)
  }

  func testEventRingPhysicalWrapKeepsLinearFIFOOrder() throws {
    var ring = EventRing<Int>()
    for event in 0..<SkateCoreBounds.eventCapacity {
      try ring.append(event)
    }

    let moved = 96
    for event in 0..<moved {
      XCTAssertEqual(ring.removeFirst(), event)
    }
    for event in SkateCoreBounds.eventCapacity..<(SkateCoreBounds.eventCapacity + moved) {
      try ring.append(event)
    }

    XCTAssertEqual(ring.count, SkateCoreBounds.eventCapacity)
    XCTAssertEqual(ring.head, UInt64(moved))
    XCTAssertEqual(ring.tail, UInt64(SkateCoreBounds.eventCapacity + moved))
    for event in moved..<(SkateCoreBounds.eventCapacity + moved) {
      XCTAssertEqual(ring.removeFirst(), event)
    }
    XCTAssertTrue(ring.isEmpty)
  }

  func testEventCounterRefusesBeforeUnsignedWrap() {
    XCTAssertThrowsError(try EventRing<Int>.advanced(UInt64.max)) { error in
      XCTAssertEqual(error as? EventRingError, .counterExhausted)
    }
  }

  func testEventRingCounterExhaustionRefusesWithoutMutation() throws {
    var ring = EventRing<Int>(counterOrigin: UInt64.max - 1)
    try ring.append(7)

    let headBefore = ring.head
    let tailBefore = ring.tail
    let firstBefore = ring.first()
    XCTAssertNil(ring.storedEvent(at: UInt64.max))

    XCTAssertThrowsError(try ring.append(8)) { error in
      XCTAssertEqual(error as? EventRingError, .counterExhausted)
    }
    XCTAssertEqual(ring.head, headBefore)
    XCTAssertEqual(ring.tail, tailBefore)
    XCTAssertEqual(ring.count, 1)
    XCTAssertEqual(ring.first(), firstBefore)
    XCTAssertNil(ring.storedEvent(at: UInt64.max))
    XCTAssertFalse(ring.isEmpty)
    XCTAssertEqual(ring.removeFirst(), 7)
    XCTAssertTrue(ring.isEmpty)
  }

  func testEventRingRefusalsPreserveEveryStoredSeat() throws {
    var fullRing = EventRing<Int>()
    for event in 0..<SkateCoreBounds.eventCapacity {
      try fullRing.append(event)
    }
    let fullBefore = fullRing

    XCTAssertThrowsError(try fullRing.append(SkateCoreBounds.eventCapacity))
    assertSameStoredState(fullRing, fullBefore)

    var ceilingRing = EventRing<Int>(counterOrigin: UInt64.max - 1)
    try ceilingRing.append(7)
    let ceilingBefore = ceilingRing

    XCTAssertThrowsError(try ceilingRing.append(8))
    assertSameStoredState(ceilingRing, ceilingBefore)
  }

  func testSurfAndSkateEventRingAliasesShareOneIdentity() throws {
    var surf = SurfEventRing<UInt8>()
    try surf.append(7)
    let skate: SkateEventRing<UInt8> = surf
    let surfAgain: SurfEventRing<UInt8> = skate

    XCTAssertEqual(skate.first(), 7)
    XCTAssertEqual(surfAgain.head, surf.head)
    XCTAssertEqual(surfAgain.tail, surf.tail)
  }

  private func assertSameStoredState<Event: Equatable & Sendable>(
    _ actual: EventRing<Event>,
    _ expected: EventRing<Event>,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    XCTAssertEqual(actual.head, expected.head, file: file, line: line)
    XCTAssertEqual(actual.tail, expected.tail, file: file, line: line)

    var physicalSeat = 0
    while physicalSeat < SkateCoreBounds.eventCapacity {
      XCTAssertEqual(
        actual.storedEvent(at: UInt64(physicalSeat)),
        expected.storedEvent(at: UInt64(physicalSeat)),
        "physical event seat \(physicalSeat)",
        file: file,
        line: line
      )
      physicalSeat += 1
    }
  }
}
