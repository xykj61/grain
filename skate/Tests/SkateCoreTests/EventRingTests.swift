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

  func testSurfAndSkateEventRingAliasesShareOneIdentity() throws {
    var surf = SurfEventRing<UInt8>()
    try surf.append(7)
    let skate: SkateEventRing<UInt8> = surf
    let surfAgain: SurfEventRing<UInt8> = skate

    XCTAssertEqual(skate.first(), 7)
    XCTAssertEqual(surfAgain.head, surf.head)
    XCTAssertEqual(surfAgain.tail, surf.tail)
  }
}
