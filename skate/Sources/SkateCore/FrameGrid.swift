/// The first native Brushstroke-to-Surf-and-Skate contract.
///
/// Surf and Skate are peer names for one surface. `SkateCore` stays the stable
/// module name while both public frame names resolve to one implementation.
///
/// These are Grain-owned capacities. AppKit, the Swift runtime, and callers may
/// allocate outside this target; this target keeps its own frame state inline.
public enum SkateCoreBounds {
  public static let columns = 40
  public static let rows = 8
  public static let cellCount = columns * rows
  public static let paletteEntries = 8
  public static let eventCapacity = 128
  public static let nibBytes = 128
  public static let imageBlockCell: UInt8 = 128
  public static let sha3DigestBytes = 32
  public static let lotusMeterSamples = 1 << 26
  public static let lotusSamplePeak: UInt32 = 32_768
}

public enum BrushstrokeFrameError: Error, Equatable, Sendable {
  case missingAtNib
  case atNibTooWide(limit: Int)
  case maxLinesOutOfBounds(limit: Int)
  case emptyFrame
  case emptyLine
  case tooManyLines(limit: Int)
  case lineTooWide(limit: Int)
}

public enum FrameGridError: Error, Equatable, Sendable {
  case rowOutOfBounds
  case columnRangeOutOfBounds
  case reservedPaletteSlot
  case paletteSlotOutOfBounds
}

/// Refusals at the bounded Rye-to-Swift media value seam.
public enum MediaReceiptError: Error, Equatable, Sendable {
  case imageCellCountMismatch(expected: Int)
  case imagePaletteIndexCountMismatch(expected: Int)
  case imageCellNotFullBlock
  case imagePaletteIndexOutOfBounds
  case digestWidthMismatch(expected: Int)
  case meterSampleCountOutOfBounds(limit: Int)
  case meterPeakOutOfBounds(limit: UInt32)
  case meterRmsAbovePeak
  case emptyMeterCarriesLevel
}

public struct SkateColor: Equatable, Sendable {
  public let red: UInt8
  public let green: UInt8
  public let blue: UInt8

  public init(red: UInt8, green: UInt8, blue: UInt8) {
    self.red = red
    self.green = green
    self.blue = blue
  }

  static let clear = SkateColor(red: 0, green: 0, blue: 0)
}

/// The fixed public level reading produced by Lotus's bounded meter.
///
/// This value does not read audio. It admits the three public integers after
/// applying the same ceiling and `rms <= peak` law as `lotus/meter.rye`.
public struct LotusMeterReading: Equatable, Sendable {
  public let sampleCount: Int
  public let peak: UInt32
  public let rms: UInt32

  public init(sampleCount: Int, peak: UInt32, rms: UInt32) throws {
    guard sampleCount >= 0, sampleCount <= SkateCoreBounds.lotusMeterSamples else {
      throw MediaReceiptError.meterSampleCountOutOfBounds(
        limit: SkateCoreBounds.lotusMeterSamples)
    }
    guard peak <= SkateCoreBounds.lotusSamplePeak else {
      throw MediaReceiptError.meterPeakOutOfBounds(limit: SkateCoreBounds.lotusSamplePeak)
    }
    guard rms <= peak else { throw MediaReceiptError.meterRmsAbovePeak }
    guard sampleCount != 0 || (peak == 0 && rms == 0) else {
      throw MediaReceiptError.emptyMeterCarriesLevel
    }

    self.sampleCount = sampleCount
    self.peak = peak
    self.rms = rms
  }
}

/// Thirty-two caller-supplied bytes in SHA3-256's public digest shape.
///
/// The name says `Claim` because this pure value checks width only. It does not
/// hash content or assert that Rye's `crypto/sha3.rye` produced the bytes.
@available(macOS 26.0, *)
public struct Sha3DigestClaim: Equatable, Sendable {
  private var bytes: InlineArray<32, UInt8> = .init(repeating: 0)

  public init<Bytes>(_ input: borrowing Bytes) throws
  where Bytes: RandomAccessCollection, Bytes.Element == UInt8 {
    guard input.count == SkateCoreBounds.sha3DigestBytes else {
      throw MediaReceiptError.digestWidthMismatch(expected: SkateCoreBounds.sha3DigestBytes)
    }

    var offset = 0
    var position = input.startIndex
    while position != input.endIndex {
      precondition(offset < SkateCoreBounds.sha3DigestBytes)
      bytes[offset] = input[position]
      offset += 1
      position = input.index(after: position)
    }
    precondition(offset == SkateCoreBounds.sha3DigestBytes)
  }

  public func byte(at offset: Int) -> UInt8? {
    guard offset >= 0, offset < SkateCoreBounds.sha3DigestBytes else { return nil }
    return bytes[offset]
  }

  public static func == (left: Sha3DigestClaim, right: Sha3DigestClaim) -> Bool {
    var offset = 0
    while offset < SkateCoreBounds.sha3DigestBytes {
      if left.bytes[offset] != right.bytes[offset] { return false }
      offset += 1
    }
    return true
  }
}

/// The exact 40-by-8 output shape of `brushstroke/image_skate.rye`.
///
/// HUNK2 fills every cell with glyph 128 and every palette index with one of
/// the seven fixed anchor slots. The adapter validates into temporary inline
/// values, then publishes both planes together as the admitted state.
@available(macOS 26.0, *)
public struct ImageSkatePlane: Sendable {
  private var cells: InlineArray<320, UInt8> = .init(repeating: 0)
  private var paletteIndices: InlineArray<320, UInt8> = .init(repeating: 0)

  public init<Cells, Indices>(
    cells inputCells: borrowing Cells,
    paletteIndices inputIndices: borrowing Indices
  ) throws
  where
    Cells: RandomAccessCollection, Cells.Element == UInt8,
    Indices: RandomAccessCollection, Indices.Element == UInt8
  {
    guard inputCells.count == SkateCoreBounds.cellCount else {
      throw MediaReceiptError.imageCellCountMismatch(expected: SkateCoreBounds.cellCount)
    }
    guard inputIndices.count == SkateCoreBounds.cellCount else {
      throw MediaReceiptError.imagePaletteIndexCountMismatch(expected: SkateCoreBounds.cellCount)
    }

    var nextCells: InlineArray<320, UInt8> = .init(repeating: 0)
    var nextIndices: InlineArray<320, UInt8> = .init(repeating: 0)

    var offset = 0
    var cellPosition = inputCells.startIndex
    while cellPosition != inputCells.endIndex {
      let cell = inputCells[cellPosition]
      guard cell == SkateCoreBounds.imageBlockCell else {
        throw MediaReceiptError.imageCellNotFullBlock
      }
      precondition(offset < SkateCoreBounds.cellCount)
      nextCells[offset] = cell
      offset += 1
      cellPosition = inputCells.index(after: cellPosition)
    }
    precondition(offset == SkateCoreBounds.cellCount)

    offset = 0
    var indexPosition = inputIndices.startIndex
    while indexPosition != inputIndices.endIndex {
      let slot = inputIndices[indexPosition]
      guard slot > 0, Int(slot) < SkateCoreBounds.paletteEntries else {
        throw MediaReceiptError.imagePaletteIndexOutOfBounds
      }
      precondition(offset < SkateCoreBounds.cellCount)
      nextIndices[offset] = slot
      offset += 1
      indexPosition = inputIndices.index(after: indexPosition)
    }
    precondition(offset == SkateCoreBounds.cellCount)

    cells = nextCells
    paletteIndices = nextIndices
  }

  fileprivate func cell(at offset: Int) -> UInt8 {
    precondition(offset >= 0 && offset < SkateCoreBounds.cellCount)
    return cells[offset]
  }

  fileprivate func paletteIndex(at offset: Int) -> UInt8 {
    precondition(offset >= 0 && offset < SkateCoreBounds.cellCount)
    return paletteIndices[offset]
  }
}

@available(macOS 26.0, *)
private struct BrushstrokeLine: Sendable {
  var bytes: InlineArray<40, UInt8> = .init(repeating: 0x20)
  var count: Int = 0
}

/// Brushstroke's present thin Frame: at most eight nonempty rows, each at most
/// forty bytes. Input is borrowed from the caller and copied only after every
/// bound is known to fit.
@available(macOS 26.0, *)
public struct BrushstrokeFrame: Sendable {
  private var atNib: InlineArray<128, UInt8> = .init(repeating: 0)
  public private(set) var atNibCount = 0
  public let maxLines: Int
  private var lines: InlineArray<8, BrushstrokeLine> = .init(repeating: .init())
  public private(set) var lineCount = 0

  public init<Nib>(atNib input: borrowing Nib, maxLines: Int) throws
  where Nib: RandomAccessCollection, Nib.Element == UInt8 {
    let inputCount = input.count
    guard inputCount > 0 else { throw BrushstrokeFrameError.missingAtNib }
    guard inputCount <= SkateCoreBounds.nibBytes else {
      throw BrushstrokeFrameError.atNibTooWide(limit: SkateCoreBounds.nibBytes)
    }
    guard maxLines > 0, maxLines <= SkateCoreBounds.rows else {
      throw BrushstrokeFrameError.maxLinesOutOfBounds(limit: SkateCoreBounds.rows)
    }
    self.maxLines = maxLines

    var offset = 0
    var position = input.startIndex
    while position != input.endIndex {
      precondition(offset < SkateCoreBounds.nibBytes)
      atNib[offset] = input[position]
      offset += 1
      position = input.index(after: position)
    }
    precondition(offset == inputCount)
    atNibCount = inputCount
  }

  public mutating func append<Bytes>(line input: borrowing Bytes) throws
  where Bytes: RandomAccessCollection, Bytes.Element == UInt8 {
    let inputCount = input.count
    guard lineCount < maxLines else {
      throw BrushstrokeFrameError.tooManyLines(limit: maxLines)
    }
    guard inputCount > 0 else {
      throw BrushstrokeFrameError.emptyLine
    }
    guard inputCount <= SkateCoreBounds.columns else {
      throw BrushstrokeFrameError.lineTooWide(limit: SkateCoreBounds.columns)
    }

    var next = BrushstrokeLine()
    var column = 0
    var position = input.startIndex
    while position != input.endIndex {
      precondition(column < SkateCoreBounds.columns)
      next.bytes[column] = input[position]
      column += 1
      position = input.index(after: position)
    }
    precondition(column == inputCount)
    next.count = inputCount

    lines[lineCount] = next
    lineCount += 1
    precondition(lineCount <= maxLines)
  }

  public func byte(row: Int, column: Int) -> UInt8? {
    guard row >= 0, row < lineCount else { return nil }
    guard column >= 0, column < lines[row].count else { return nil }
    return lines[row].bytes[column]
  }

  public func atNibByte(at offset: Int) -> UInt8? {
    guard offset >= 0, offset < atNibCount else { return nil }
    return atNib[offset]
  }

  /// Compare all 459 stored values for refusal proofs. This package-internal
  /// seam includes unused line seats, which the public admitted-value readers
  /// intentionally keep hidden.
  func hasSameStoredState(as other: borrowing BrushstrokeFrame) -> Bool {
    if atNibCount != other.atNibCount { return false }
    if maxLines != other.maxLines { return false }
    if lineCount != other.lineCount { return false }

    var nibOffset = 0
    while nibOffset < SkateCoreBounds.nibBytes {
      if atNib[nibOffset] != other.atNib[nibOffset] { return false }
      nibOffset += 1
    }

    var row = 0
    while row < SkateCoreBounds.rows {
      if lines[row].count != other.lines[row].count { return false }
      var column = 0
      while column < SkateCoreBounds.columns {
        if lines[row].bytes[column] != other.lines[row].bytes[column] { return false }
        column += 1
      }
      row += 1
    }
    return true
  }

  public func lowered() throws -> FrameGrid {
    guard lineCount > 0 else { throw BrushstrokeFrameError.emptyFrame }
    precondition(lineCount <= maxLines)

    var grid = FrameGrid()
    var row = 0
    while row < lineCount {
      precondition(row < SkateCoreBounds.rows)
      grid.write(lines[row], at: row)
      row += 1
    }
    return grid
  }
}

/// Surf and Skate's fixed 40-by-8 cell target. Slot zero in the
/// palette-index plane is the existing foreground sentinel; real styled runs
/// use slots one through seven, matching `brushstroke/skate_grid.rye`.
@available(macOS 26.0, *)
public struct FrameGrid: Sendable {
  private var cells: InlineArray<320, UInt8> = .init(repeating: 0x20)
  private var paletteIndices: InlineArray<320, UInt8> = .init(repeating: 0)
  private var palette: InlineArray<8, SkateColor> = .init(repeating: .clear)

  public init() {}

  /// Admit the already-down-mapped HUNK2 image plane without decoding or
  /// allocating. The seven colors are the fixed anchors owned by that Rye
  /// contract; this native seam neither quantizes nor invents another palette.
  public init(imageSkatePlane plane: borrowing ImageSkatePlane) {
    let anchors: InlineArray<7, SkateColor> = [
      .init(red: 0, green: 0, blue: 0),
      .init(red: 255, green: 255, blue: 255),
      .init(red: 255, green: 0, blue: 0),
      .init(red: 0, green: 255, blue: 0),
      .init(red: 0, green: 0, blue: 255),
      .init(red: 255, green: 255, blue: 0),
      .init(red: 0, green: 255, blue: 255),
    ]

    var anchor = 0
    while anchor < anchors.count {
      let slot = anchor + 1
      precondition(slot < SkateCoreBounds.paletteEntries)
      palette[slot] = anchors[anchor]
      anchor += 1
    }

    var offset = 0
    while offset < SkateCoreBounds.cellCount {
      cells[offset] = plane.cell(at: offset)
      paletteIndices[offset] = plane.paletteIndex(at: offset)
      offset += 1
    }
  }

  public func cell(row: Int, column: Int) -> UInt8? {
    guard let index = index(row: row, column: column) else { return nil }
    return cells[index]
  }

  public func paletteIndex(row: Int, column: Int) -> UInt8? {
    guard let index = index(row: row, column: column) else { return nil }
    return paletteIndices[index]
  }

  public func color(at slot: UInt8) -> SkateColor? {
    guard Int(slot) < SkateCoreBounds.paletteEntries else { return nil }
    return palette[Int(slot)]
  }

  public mutating func setPalette(slot: UInt8, color: SkateColor) throws {
    guard slot != 0 else { throw FrameGridError.reservedPaletteSlot }
    guard Int(slot) < SkateCoreBounds.paletteEntries else {
      throw FrameGridError.paletteSlotOutOfBounds
    }
    palette[Int(slot)] = color
  }

  public mutating func paint(
    row: Int,
    columns: Range<Int>,
    paletteSlot: UInt8
  ) throws {
    guard row >= 0, row < SkateCoreBounds.rows else {
      throw FrameGridError.rowOutOfBounds
    }
    guard columns.lowerBound >= 0,
      columns.lowerBound < columns.upperBound,
      columns.upperBound <= SkateCoreBounds.columns
    else {
      throw FrameGridError.columnRangeOutOfBounds
    }
    guard paletteSlot != 0 else { throw FrameGridError.reservedPaletteSlot }
    guard Int(paletteSlot) < SkateCoreBounds.paletteEntries else {
      throw FrameGridError.paletteSlotOutOfBounds
    }

    var column = columns.lowerBound
    while column < columns.upperBound {
      let offset = row * SkateCoreBounds.columns + column
      precondition(offset >= 0 && offset < SkateCoreBounds.cellCount)
      paletteIndices[offset] = paletteSlot
      column += 1
    }
  }

  private func index(row: Int, column: Int) -> Int? {
    guard row >= 0, row < SkateCoreBounds.rows else { return nil }
    guard column >= 0, column < SkateCoreBounds.columns else { return nil }
    return row * SkateCoreBounds.columns + column
  }

  fileprivate mutating func write(_ line: BrushstrokeLine, at row: Int) {
    precondition(row >= 0 && row < SkateCoreBounds.rows)
    precondition(line.count > 0 && line.count <= SkateCoreBounds.columns)

    let base = row * SkateCoreBounds.columns
    var column = 0
    while column < line.count {
      let offset = base + column
      precondition(offset >= 0 && offset < SkateCoreBounds.cellCount)
      cells[offset] = line.bytes[column]
      column += 1
    }
  }
}

/// Alias-sameness: two peer names, one compile-time frame identity.
@available(macOS 26.0, *)
public typealias SurfFrameGrid = FrameGrid

@available(macOS 26.0, *)
public typealias SkateFrameGrid = FrameGrid

/// One fixed native receipt joining three already-computed public values:
/// HUNK2's image plane, Lotus's meter reading, and a SHA3-width digest claim.
/// The Swift core validates and carries them; it performs none of their Rye
/// computations and makes no authenticity claim about the digest bytes.
@available(macOS 26.0, *)
public struct MediaReceipt: Sendable {
  public let frame: FrameGrid
  public let meter: LotusMeterReading
  public let digestClaim: Sha3DigestClaim

  public init(
    imageSkatePlane: borrowing ImageSkatePlane,
    lotusMeter: LotusMeterReading,
    sha3DigestClaim: Sha3DigestClaim
  ) {
    frame = FrameGrid(imageSkatePlane: imageSkatePlane)
    meter = lotusMeter
    digestClaim = sha3DigestClaim
  }
}

/// Alias-sameness applies to the joined media receipt as it does to the frame.
@available(macOS 26.0, *)
public typealias SurfMediaReceipt = MediaReceipt

@available(macOS 26.0, *)
public typealias SkateMediaReceipt = MediaReceipt
