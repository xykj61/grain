import XCTest
@testable import SkateCore

@available(macOS 26.0, *)
final class ImageEditHistoryTests: XCTestCase {
  private func record(seed: UInt8, byteCount: Int = 49) throws -> ImageEditRecordClaim {
    let bytes = (0..<byteCount).map { offset in
      UInt8((Int(seed) + offset) % 256)
    }
    return try ImageEditRecordClaim(bytes)
  }

  func testImageEditHistoryAdmitsExactBoundsAndKeepsOrder() throws {
    let maximumCrop = Array(
      "crop 4294967295 4294967295 4294967295 4294967295\n".utf8)
    XCTAssertEqual(maximumCrop.count, 49)

    var history = ImageEditHistory()
    try history.append(ImageEditRecordClaim(maximumCrop))
    var index = 1
    while index < SkateCoreBounds.imageEditCapacity {
      try history.append(record(seed: UInt8(index)))
      index += 1
    }

    XCTAssertEqual(history.count, 64)
    XCTAssertEqual(history.payloadByteCount, 3_136)
    XCTAssertEqual(history.record(at: 0)?.byteCount, 49)
    XCTAssertEqual(history.record(at: 0)?.byte(at: 0), 0x63)
    XCTAssertEqual(history.record(at: 0)?.byte(at: 48), 0x0A)

    index = 1
    while index < SkateCoreBounds.imageEditCapacity {
      let held = try XCTUnwrap(history.record(at: index))
      XCTAssertEqual(held.byteCount, 49)
      XCTAssertEqual(held.byte(at: 0), UInt8(index))
      XCTAssertEqual(held.byte(at: 48), UInt8(index + 48))
      index += 1
    }
  }

  func testImageEditRecordRefusesEmptyAndFiftiethByte() {
    XCTAssertThrowsError(try ImageEditRecordClaim([UInt8]())) { error in
      XCTAssertEqual(error as? ImageEditHistoryError, .emptyRecord)
    }

    let tooWide = [UInt8](repeating: 0x41, count: 50)
    XCTAssertThrowsError(try ImageEditRecordClaim(tooWide)) { error in
      XCTAssertEqual(
        error as? ImageEditHistoryError,
        .recordTooWide(limit: SkateCoreBounds.imageEditRecordBytes)
      )
    }
  }

  func testImageEditHistoryFullRefusalPreservesAllStoredBytes() throws {
    var history = ImageEditHistory()
    var index = 0
    while index < SkateCoreBounds.imageEditCapacity {
      try history.append(record(seed: UInt8(index)))
      index += 1
    }
    let before = history

    XCTAssertThrowsError(try history.append(record(seed: 0xA5))) { error in
      XCTAssertEqual(
        error as? ImageEditHistoryError,
        .historyFull(limit: SkateCoreBounds.imageEditCapacity)
      )
    }

    XCTAssertEqual(history, before)
    XCTAssertEqual(history.count, 64)
    XCTAssertEqual(history.payloadByteCount, 3_136)

    index = 0
    while index < SkateCoreBounds.imageEditCapacity {
      let afterRecord = try XCTUnwrap(history.record(at: index))
      let beforeRecord = try XCTUnwrap(before.record(at: index))
      var byte = 0
      while byte < SkateCoreBounds.imageEditRecordBytes {
        XCTAssertEqual(afterRecord.byte(at: byte), beforeRecord.byte(at: byte))
        byte += 1
      }
      index += 1
    }
  }

  func testSurfAndSkateImageEditHistoryAliasesShareOneIdentity() throws {
    var surf: SurfImageEditHistory = ImageEditHistory()
    try surf.append(record(seed: 7, byteCount: 12))
    let skate: SkateImageEditHistory = surf
    let returned: SurfImageEditHistory = skate

    XCTAssertEqual(returned, surf)
    XCTAssertEqual(returned.count, 1)
    XCTAssertEqual(returned.record(at: 0)?.byte(at: 0), 7)
    XCTAssertNil(returned.record(at: 1))
  }
}
