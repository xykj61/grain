import XCTest

@testable import SkateCore

@available(macOS 26.0, *)
final class FrameGridTests: XCTestCase {
  func testBrushstrokeFrameLowersDeterministically() throws {
    var frame = try BrushstrokeFrame(
      atNib: Array("brushstroke-seed".utf8),
      maxLines: SkateCoreBounds.rows
    )
    try frame.append(line: Array("brushstroke seed".utf8))
    try frame.append(line: Array("frame drawn from values".utf8))
    try frame.append(line: Array("(seed version string)".utf8))

    let first = try frame.lowered()
    let second = try frame.lowered()

    XCTAssertEqual(frame.atNibByte(at: 0), 0x62)
    XCTAssertEqual(first.cell(row: 0, column: 0), 0x62)
    XCTAssertEqual(first.cell(row: 1, column: 0), 0x66)
    XCTAssertEqual(first.cell(row: 2, column: 0), 0x28)
    XCTAssertEqual(first.cell(row: 3, column: 0), 0x20)
    XCTAssertEqual(first.cell(row: 0, column: 39), 0x20)

    for row in 0..<SkateCoreBounds.rows {
      for column in 0..<SkateCoreBounds.columns {
        XCTAssertEqual(first.cell(row: row, column: column), second.cell(row: row, column: column))
        XCTAssertEqual(first.paletteIndex(row: row, column: column), 0)
      }
    }
  }

  func testEmptyFrameRefuses() throws {
    let frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows)
    XCTAssertThrowsError(try frame.lowered()) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .emptyFrame)
    }
  }

  func testMissingAtNibRefuses() {
    XCTAssertThrowsError(
      try BrushstrokeFrame(atNib: [UInt8](), maxLines: SkateCoreBounds.rows)
    ) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .missingAtNib)
    }
  }

  func testHundredTwentyNinthNibByteRefuses() {
    XCTAssertThrowsError(
      try BrushstrokeFrame(
        atNib: Array(repeating: 0x6e, count: SkateCoreBounds.nibBytes + 1),
        maxLines: SkateCoreBounds.rows
      )
    ) { error in
      XCTAssertEqual(
        error as? BrushstrokeFrameError, .atNibTooWide(limit: SkateCoreBounds.nibBytes))
    }
  }

  func testExactNibAndLineBoundsAreAccepted() throws {
    var frame = try BrushstrokeFrame(
      atNib: Array(repeating: 0x6e, count: SkateCoreBounds.nibBytes),
      maxLines: SkateCoreBounds.rows
    )
    try frame.append(line: Array(repeating: 0x6c, count: SkateCoreBounds.columns))

    let grid = try frame.lowered()
    XCTAssertEqual(frame.atNibCount, SkateCoreBounds.nibBytes)
    XCTAssertEqual(frame.atNibByte(at: SkateCoreBounds.nibBytes - 1), 0x6e)
    XCTAssertEqual(grid.cell(row: 0, column: SkateCoreBounds.columns - 1), 0x6c)
  }

  func testEmptyLineRefusesWithoutChangingFrame() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows)
    XCTAssertThrowsError(try frame.append(line: [UInt8]())) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .emptyLine)
    }
    XCTAssertEqual(frame.lineCount, 0)
  }

  func testNinthLineRefusesWithoutChangingFrame() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows)
    for index in 0..<SkateCoreBounds.rows {
      try frame.append(line: [UInt8(index + 1)])
    }

    let lastByte = frame.byte(row: SkateCoreBounds.rows - 1, column: 0)
    XCTAssertThrowsError(try frame.append(line: [0xff])) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .tooManyLines(limit: SkateCoreBounds.rows))
    }
    XCTAssertEqual(frame.lineCount, SkateCoreBounds.rows)
    XCTAssertEqual(frame.byte(row: SkateCoreBounds.rows - 1, column: 0), lastByte)
  }

  func testFortyFirstByteRefusesWithoutChangingFrame() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows)
    try frame.append(line: [0x41])

    XCTAssertThrowsError(
      try frame.append(line: Array(repeating: 0x42, count: SkateCoreBounds.columns + 1))
    ) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .lineTooWide(limit: SkateCoreBounds.columns))
    }
    XCTAssertEqual(frame.lineCount, 1)
    XCTAssertEqual(frame.byte(row: 0, column: 0), 0x41)
    XCTAssertNil(frame.byte(row: 1, column: 0))
  }

  func testBrushstrokeFrameRefusalsPreserveAllStoredState() throws {
    let fullNib = (0..<SkateCoreBounds.nibBytes).map { UInt8($0) }
    let fullLine = Array(repeating: UInt8(0x41), count: SkateCoreBounds.columns)
    var frame = try BrushstrokeFrame(atNib: fullNib, maxLines: 2)
    try frame.append(line: fullLine)
    let before = frame

    XCTAssertThrowsError(try frame.append(line: [UInt8]())) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .emptyLine)
    }
    XCTAssertTrue(frame.hasSameStoredState(as: before))

    XCTAssertThrowsError(
      try frame.append(
        line: Array(repeating: UInt8(0x42), count: SkateCoreBounds.columns + 1)
      )
    ) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .lineTooWide(limit: SkateCoreBounds.columns))
    }
    XCTAssertTrue(frame.hasSameStoredState(as: before))

    var oneLineFrame = try BrushstrokeFrame(atNib: fullNib, maxLines: 1)
    try oneLineFrame.append(line: fullLine)
    let oneLineBefore = oneLineFrame
    XCTAssertThrowsError(try oneLineFrame.append(line: [0x43])) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .tooManyLines(limit: 1))
    }
    XCTAssertTrue(oneLineFrame.hasSameStoredState(as: oneLineBefore))
  }

  func testPaletteRunPaintsInsideItsBound() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows)
    try frame.append(line: Array("paint".utf8))
    var grid = try frame.lowered()
    let terra = SkateColor(red: 0x8f, green: 0x72, blue: 0x4f)

    try grid.setPalette(slot: 1, color: terra)
    try grid.setPalette(slot: 7, color: terra)
    try grid.paint(row: 0, columns: 0..<5, paletteSlot: 1)

    XCTAssertEqual(grid.color(at: 1), terra)
    XCTAssertEqual(grid.color(at: 7), terra)
    for column in 0..<5 {
      XCTAssertEqual(grid.paletteIndex(row: 0, column: column), 1)
    }
    XCTAssertEqual(grid.paletteIndex(row: 0, column: 5), 0)
  }

  func testInvalidPaletteRunsRefuseAtomically() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows)
    try frame.append(line: Array("still".utf8))
    var grid = try frame.lowered()
    let before = grid.paletteIndex(row: 0, column: 0)

    XCTAssertThrowsError(try grid.paint(row: 0, columns: 0..<1, paletteSlot: 0)) { error in
      XCTAssertEqual(error as? FrameGridError, .reservedPaletteSlot)
    }
    XCTAssertThrowsError(try grid.setPalette(slot: 8, color: .init(red: 0, green: 0, blue: 0))) {
      error in
      XCTAssertEqual(error as? FrameGridError, .paletteSlotOutOfBounds)
    }
    XCTAssertThrowsError(
      try grid.paint(row: 0, columns: 0..<(SkateCoreBounds.columns + 1), paletteSlot: 1)
    ) { error in
      XCTAssertEqual(error as? FrameGridError, .columnRangeOutOfBounds)
    }
    XCTAssertThrowsError(try grid.paint(row: SkateCoreBounds.rows, columns: 0..<1, paletteSlot: 1))
    { error in
      XCTAssertEqual(error as? FrameGridError, .rowOutOfBounds)
    }
    XCTAssertEqual(grid.paletteIndex(row: 0, column: 0), before)
    XCTAssertNil(grid.color(at: 8))
  }

  func testFrameGridRefusalsPreserveWholeState() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows)
    try frame.append(line: Array("state".utf8))
    var grid = try frame.lowered()
    let terra = SkateColor(red: 0x8f, green: 0x72, blue: 0x4f)
    let water = SkateColor(red: 0x24, green: 0x58, blue: 0x91)

    try grid.setPalette(slot: 1, color: terra)
    try grid.setPalette(slot: 7, color: water)
    try grid.paint(row: 0, columns: 0..<5, paletteSlot: 1)
    try grid.paint(row: 7, columns: 38..<40, paletteSlot: 7)
    let before = grid

    XCTAssertThrowsError(try grid.setPalette(slot: 0, color: water)) { error in
      XCTAssertEqual(error as? FrameGridError, .reservedPaletteSlot)
    }
    assertSameFrameState(grid, before)

    XCTAssertThrowsError(try grid.setPalette(slot: 8, color: water)) { error in
      XCTAssertEqual(error as? FrameGridError, .paletteSlotOutOfBounds)
    }
    assertSameFrameState(grid, before)

    XCTAssertThrowsError(try grid.paint(row: -1, columns: 0..<1, paletteSlot: 1)) { error in
      XCTAssertEqual(error as? FrameGridError, .rowOutOfBounds)
    }
    assertSameFrameState(grid, before)

    XCTAssertThrowsError(try grid.paint(row: 0, columns: 0..<0, paletteSlot: 1)) { error in
      XCTAssertEqual(error as? FrameGridError, .columnRangeOutOfBounds)
    }
    assertSameFrameState(grid, before)

    XCTAssertThrowsError(try grid.paint(row: 0, columns: 0..<1, paletteSlot: 0)) { error in
      XCTAssertEqual(error as? FrameGridError, .reservedPaletteSlot)
    }
    assertSameFrameState(grid, before)

    XCTAssertThrowsError(try grid.paint(row: 7, columns: 38..<40, paletteSlot: 8)) { error in
      XCTAssertEqual(error as? FrameGridError, .paletteSlotOutOfBounds)
    }
    assertSameFrameState(grid, before)
  }

  func testSurfAndSkateAliasesShareOneFrameIdentityAndRefusalContract() throws {
    var surf = SurfFrameGrid()
    let surfAsSkate: SkateFrameGrid = surf
    var skate: SkateFrameGrid = surfAsSkate
    let skateAsSurf: SurfFrameGrid = skate
    let terra = SkateColor(red: 0x8f, green: 0x72, blue: 0x4f)

    try surf.setPalette(slot: 1, color: terra)
    skate = surf
    XCTAssertEqual(skate.color(at: 1), terra)
    XCTAssertEqual(skateAsSurf.cell(row: 0, column: 0), surfAsSkate.cell(row: 0, column: 0))

    XCTAssertThrowsError(try surf.paint(row: 0, columns: 0..<1, paletteSlot: 0)) { error in
      XCTAssertEqual(error as? FrameGridError, .reservedPaletteSlot)
    }
    XCTAssertThrowsError(try skate.paint(row: 0, columns: 0..<1, paletteSlot: 0)) { error in
      XCTAssertEqual(error as? FrameGridError, .reservedPaletteSlot)
    }
    XCTAssertEqual(surf.paletteIndex(row: 0, column: 0), 0)
    XCTAssertEqual(skate.paletteIndex(row: 0, column: 0), 0)
  }

  func testDeclaredOneLineCeilingRefusesSecondLineWithoutChangingFrame() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: 1)
    try frame.append(line: [0x41])

    XCTAssertThrowsError(try frame.append(line: [0x42])) { error in
      XCTAssertEqual(error as? BrushstrokeFrameError, .tooManyLines(limit: 1))
    }
    XCTAssertEqual(frame.maxLines, 1)
    XCTAssertEqual(frame.lineCount, 1)
    XCTAssertEqual(frame.byte(row: 0, column: 0), 0x41)
    XCTAssertNil(frame.byte(row: 1, column: 0))
  }

  func testDeclaredLineCeilingOutsideOneThroughEightRefuses() {
    XCTAssertThrowsError(try BrushstrokeFrame(atNib: [0x6e], maxLines: 0)) { error in
      XCTAssertEqual(
        error as? BrushstrokeFrameError,
        .maxLinesOutOfBounds(limit: SkateCoreBounds.rows)
      )
    }
    XCTAssertThrowsError(
      try BrushstrokeFrame(atNib: [0x6e], maxLines: SkateCoreBounds.rows + 1)
    ) { error in
      XCTAssertEqual(
        error as? BrushstrokeFrameError,
        .maxLinesOutOfBounds(limit: SkateCoreBounds.rows)
      )
    }
  }

  func testImageLotusAndDigestValuesJoinOneBoundedMediaReceipt() throws {
    let cells = Array(repeating: SkateCoreBounds.imageBlockCell, count: SkateCoreBounds.cellCount)
    var indices = Array(repeating: UInt8(1), count: SkateCoreBounds.cellCount)
    indices[1] = 2
    indices[2] = 3
    indices[SkateCoreBounds.cellCount - 1] = 7

    let plane = try ImageSkatePlane(cells: cells, paletteIndices: indices)
    let meter = try LotusMeterReading(sampleCount: 48_000, peak: 12_000, rms: 8_000)
    let digest = try Sha3DigestClaim(
      Array(0..<UInt8(SkateCoreBounds.sha3DigestBytes)))
    let surf = SurfMediaReceipt(
      imageSkatePlane: plane,
      lotusMeter: meter,
      sha3DigestClaim: digest
    )
    let skate: SkateMediaReceipt = surf

    XCTAssertEqual(skate.frame.cell(row: 0, column: 0), SkateCoreBounds.imageBlockCell)
    XCTAssertEqual(skate.frame.paletteIndex(row: 0, column: 0), 1)
    XCTAssertEqual(skate.frame.paletteIndex(row: 0, column: 1), 2)
    XCTAssertEqual(skate.frame.paletteIndex(row: 0, column: 2), 3)
    XCTAssertEqual(skate.frame.paletteIndex(row: 7, column: 39), 7)
    XCTAssertEqual(skate.frame.color(at: 3), .init(red: 255, green: 0, blue: 0))
    XCTAssertEqual(skate.frame.color(at: 7), .init(red: 0, green: 255, blue: 255))
    XCTAssertEqual(skate.meter, meter)
    XCTAssertEqual(skate.digestClaim.byte(at: 31), 31)
    XCTAssertNil(skate.digestClaim.byte(at: 32))
  }

  func testMediaReceiptImportIsDeterministic() throws {
    let cells = Array(repeating: SkateCoreBounds.imageBlockCell, count: SkateCoreBounds.cellCount)
    let indices = (0..<SkateCoreBounds.cellCount).map { UInt8(($0 % 7) + 1) }
    let plane = try ImageSkatePlane(cells: cells, paletteIndices: indices)

    let first = FrameGrid(imageSkatePlane: plane)
    let second = FrameGrid(imageSkatePlane: plane)
    for row in 0..<SkateCoreBounds.rows {
      for column in 0..<SkateCoreBounds.columns {
        XCTAssertEqual(first.cell(row: row, column: column), second.cell(row: row, column: column))
        XCTAssertEqual(
          first.paletteIndex(row: row, column: column),
          second.paletteIndex(row: row, column: column)
        )
      }
    }
  }

  func testImageSkatePlaneRefusesMalformedPlanesBeforeAdmission() {
    let wholeCells = Array(
      repeating: SkateCoreBounds.imageBlockCell,
      count: SkateCoreBounds.cellCount
    )
    let wholeIndices = Array(repeating: UInt8(1), count: SkateCoreBounds.cellCount)

    XCTAssertThrowsError(
      try ImageSkatePlane(cells: Array(wholeCells.dropLast()), paletteIndices: wholeIndices)
    ) { error in
      XCTAssertEqual(
        error as? MediaReceiptError,
        .imageCellCountMismatch(expected: SkateCoreBounds.cellCount)
      )
    }
    XCTAssertThrowsError(
      try ImageSkatePlane(cells: wholeCells, paletteIndices: Array(wholeIndices.dropLast()))
    ) { error in
      XCTAssertEqual(
        error as? MediaReceiptError,
        .imagePaletteIndexCountMismatch(expected: SkateCoreBounds.cellCount)
      )
    }

    var badCell = wholeCells
    badCell[SkateCoreBounds.cellCount - 1] = 0x20
    XCTAssertThrowsError(try ImageSkatePlane(cells: badCell, paletteIndices: wholeIndices)) {
      error in
      XCTAssertEqual(error as? MediaReceiptError, .imageCellNotFullBlock)
    }

    for badSlot in [UInt8(0), UInt8(8)] {
      var badIndices = wholeIndices
      badIndices[SkateCoreBounds.cellCount - 1] = badSlot
      XCTAssertThrowsError(try ImageSkatePlane(cells: wholeCells, paletteIndices: badIndices)) {
        error in
        XCTAssertEqual(error as? MediaReceiptError, .imagePaletteIndexOutOfBounds)
      }
    }
  }

  func testLotusMeterAndDigestClaimsKeepTheirExactBounds() throws {
    let silence = try LotusMeterReading(sampleCount: 0, peak: 0, rms: 0)
    XCTAssertEqual(silence.sampleCount, 0)
    XCTAssertEqual(silence.peak, 0)
    XCTAssertEqual(silence.rms, 0)
    XCTAssertEqual(
      try LotusMeterReading(
        sampleCount: SkateCoreBounds.lotusMeterSamples,
        peak: SkateCoreBounds.lotusSamplePeak,
        rms: SkateCoreBounds.lotusSamplePeak
      ).peak,
      SkateCoreBounds.lotusSamplePeak
    )

    XCTAssertThrowsError(try LotusMeterReading(sampleCount: -1, peak: 0, rms: 0)) { error in
      XCTAssertEqual(
        error as? MediaReceiptError,
        .meterSampleCountOutOfBounds(limit: SkateCoreBounds.lotusMeterSamples)
      )
    }
    XCTAssertThrowsError(
      try LotusMeterReading(
        sampleCount: SkateCoreBounds.lotusMeterSamples + 1,
        peak: 0,
        rms: 0
      )
    ) { error in
      XCTAssertEqual(
        error as? MediaReceiptError,
        .meterSampleCountOutOfBounds(limit: SkateCoreBounds.lotusMeterSamples)
      )
    }
    XCTAssertThrowsError(
      try LotusMeterReading(
        sampleCount: 1,
        peak: SkateCoreBounds.lotusSamplePeak + 1,
        rms: 0
      )
    ) { error in
      XCTAssertEqual(
        error as? MediaReceiptError,
        .meterPeakOutOfBounds(limit: SkateCoreBounds.lotusSamplePeak)
      )
    }
    XCTAssertThrowsError(try LotusMeterReading(sampleCount: 1, peak: 10, rms: 11)) { error in
      XCTAssertEqual(error as? MediaReceiptError, .meterRmsAbovePeak)
    }
    XCTAssertThrowsError(try LotusMeterReading(sampleCount: 0, peak: 1, rms: 1)) { error in
      XCTAssertEqual(error as? MediaReceiptError, .emptyMeterCarriesLevel)
    }

    XCTAssertNoThrow(try Sha3DigestClaim(Array(repeating: UInt8(0), count: 32)))
    for width in [31, 33] {
      XCTAssertThrowsError(try Sha3DigestClaim(Array(repeating: UInt8(0), count: width))) {
        error in
        XCTAssertEqual(
          error as? MediaReceiptError,
          .digestWidthMismatch(expected: SkateCoreBounds.sha3DigestBytes)
        )
      }
    }
  }

  private func assertSameFrameState(
    _ actual: FrameGrid,
    _ expected: FrameGrid,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    for row in 0..<SkateCoreBounds.rows {
      for column in 0..<SkateCoreBounds.columns {
        XCTAssertEqual(
          actual.cell(row: row, column: column),
          expected.cell(row: row, column: column),
          file: file,
          line: line
        )
        XCTAssertEqual(
          actual.paletteIndex(row: row, column: column),
          expected.paletteIndex(row: row, column: column),
          file: file,
          line: line
        )
      }
    }
    for slot in 0..<SkateCoreBounds.paletteEntries {
      XCTAssertEqual(
        actual.color(at: UInt8(slot)),
        expected.color(at: UInt8(slot)),
        file: file,
        line: line
      )
    }
  }
}
