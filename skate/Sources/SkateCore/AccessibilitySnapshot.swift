/// Refusals while forming one bounded semantic node.
public enum AccessibilityNodeError: Error, Equatable, Sendable {
  case emptyLabel
  case labelTooWide(limit: Int)
  case rowOutOfBounds(limit: Int)
  case columnStartOutOfBounds(limit: Int)
  case cellCountOutOfBounds(limit: Int)
  case cellRangeOutOfBounds(limit: Int)
}

/// A whole semantic snapshot refused before replacing its last complete value.
public enum AccessibilitySnapshotError: Error, Equatable, Sendable {
  case accessibilityTooLarge(limit: Int)
}

extension SkateCoreBounds {
  /// One frame root plus the eight presentable Brushstroke lines.
  public static let accessibilityNodeCapacity = 1 + rows
}

/// The closed roles present in the phase-two headless surface.
public enum AccessibilityRole: UInt8, Equatable, Sendable {
  case frame = 0
  case textLine = 1
}

/// One row-local rectangle in the forty-by-eight proof grid.
///
/// A caller supplies the frame root's rect, so this headless core keeps the
/// later AppKit translation and visual-form choice outside phase two.
public struct AccessibilityCellRect: Equatable, Sendable {
  public let row: UInt8
  public let columnStart: UInt8
  public let cellCount: UInt8

  public init(row: Int, columnStart: Int, cellCount: Int) throws {
    guard row >= 0, row < SkateCoreBounds.rows else {
      throw AccessibilityNodeError.rowOutOfBounds(limit: SkateCoreBounds.rows)
    }
    guard columnStart >= 0, columnStart < SkateCoreBounds.columns else {
      throw AccessibilityNodeError.columnStartOutOfBounds(limit: SkateCoreBounds.columns)
    }
    guard cellCount > 0, cellCount <= SkateCoreBounds.columns else {
      throw AccessibilityNodeError.cellCountOutOfBounds(limit: SkateCoreBounds.columns)
    }
    guard columnStart + cellCount <= SkateCoreBounds.columns else {
      throw AccessibilityNodeError.cellRangeOutOfBounds(limit: SkateCoreBounds.columns)
    }

    self.row = UInt8(row)
    self.columnStart = UInt8(columnStart)
    self.cellCount = UInt8(cellCount)
  }
}

/// One presentable unit with a closed role, inline label, and grid rect.
///
/// A root label carries the frame's at-nib identity. A text-line label carries
/// the already-rendered line bytes. The caller may lend a collection, while
/// the admitted value owns no dynamic collection of its own.
@available(macOS 26.0, *)
public struct AccessibilityNode: Equatable, Sendable {
  public let role: AccessibilityRole
  private var labelBytes: InlineArray<128, UInt8> = .init(repeating: 0)
  public private(set) var labelByteCount = 0
  public let rect: AccessibilityCellRect

  public init<Bytes>(
    role: AccessibilityRole,
    label input: borrowing Bytes,
    row: Int,
    columnStart: Int,
    cellCount: Int
  ) throws where Bytes: RandomAccessCollection, Bytes.Element == UInt8 {
    let inputCount = input.count
    guard inputCount > 0 else { throw AccessibilityNodeError.emptyLabel }
    let labelLimit: Int
    switch role {
    case .frame: labelLimit = SkateCoreBounds.nibBytes
    case .textLine: labelLimit = SkateCoreBounds.columns
    }
    guard inputCount <= labelLimit else {
      throw AccessibilityNodeError.labelTooWide(limit: labelLimit)
    }
    let nextRect = try AccessibilityCellRect(
      row: row,
      columnStart: columnStart,
      cellCount: cellCount
    )

    var nextBytes: InlineArray<128, UInt8> = .init(repeating: 0)
    var offset = 0
    var position = input.startIndex
    while position != input.endIndex {
      // invariant: the admitted count keeps every label write inside its inline seat.
      precondition(offset < SkateCoreBounds.nibBytes)
      nextBytes[offset] = input[position]
      offset += 1
      position = input.index(after: position)
    }
    // invariant: a stable random-access input supplies exactly its checked count.
    precondition(offset == inputCount)

    self.init(
      role: role,
      labelBytes: nextBytes,
      labelByteCount: inputCount,
      rect: nextRect
    )
  }

  public func labelByte(at offset: Int) -> UInt8? {
    guard offset >= 0, offset < labelByteCount else { return nil }
    return labelBytes[offset]
  }

  public static func == (left: AccessibilityNode, right: AccessibilityNode) -> Bool {
    if left.role != right.role { return false }
    if left.labelByteCount != right.labelByteCount { return false }
    if left.rect != right.rect { return false }

    var offset = 0
    while offset < SkateCoreBounds.nibBytes {
      if left.labelBytes[offset] != right.labelBytes[offset] { return false }
      offset += 1
    }
    return true
  }

  private init(
    role: AccessibilityRole,
    labelBytes: InlineArray<128, UInt8>,
    labelByteCount: Int,
    rect: AccessibilityCellRect
  ) {
    self.role = role
    self.labelBytes = labelBytes
    self.labelByteCount = labelByteCount
    self.rect = rect
  }

  fileprivate static func frameRoot(
    from frame: borrowing BrushstrokeFrame,
    rect: AccessibilityCellRect
  ) -> Self {
    let atNibCount = frame.atNibCount
    // invariant: BrushstrokeFrame admits one through 128 at-nib bytes at construction.
    precondition(atNibCount > 0 && atNibCount <= SkateCoreBounds.nibBytes)
    var bytes: InlineArray<128, UInt8> = .init(repeating: 0)
    var offset = 0
    while offset < atNibCount {
      guard let byte = frame.atNibByte(at: offset) else {
        preconditionFailure("an admitted at-nib byte must remain readable")
      }
      bytes[offset] = byte
      offset += 1
    }

    return Self(
      role: .frame,
      labelBytes: bytes,
      labelByteCount: atNibCount,
      rect: rect
    )
  }

  fileprivate static func textLine(
    from frame: borrowing BrushstrokeFrame,
    row: Int
  ) throws -> Self {
    let lineCount = frame.lineCount
    // invariant: the caller walks only the frame's admitted line count.
    precondition(row >= 0 && row < lineCount)
    var bytes: InlineArray<128, UInt8> = .init(repeating: 0)
    var byteCount = 0
    while byteCount < SkateCoreBounds.columns {
      guard let byte = frame.byte(row: row, column: byteCount) else { break }
      bytes[byteCount] = byte
      byteCount += 1
    }
    // invariant: BrushstrokeFrame refuses an empty line before admission.
    precondition(byteCount > 0 && byteCount <= SkateCoreBounds.columns)

    let rect = try AccessibilityCellRect(
      row: row,
      columnStart: 0,
      cellCount: byteCount
    )
    return Self(
      role: .textLine,
      labelBytes: bytes,
      labelByteCount: byteCount,
      rect: rect
    )
  }
}

/// A fixed semantic snapshot regenerated whole into reusable inline scratch.
///
/// Every regeneration builds the next nine-seat value separately and publishes
/// it only after all input fits. An oversized source therefore leaves the last
/// whole snapshot, including every physical seat, unchanged.
@available(macOS 26.0, *)
public struct AccessibilitySnapshot: Equatable, Sendable {
  private var nodes: InlineArray<9, AccessibilityNode?> = .init(repeating: nil)
  public private(set) var count = 0

  public init() {}

  public func node(at index: Int) -> AccessibilityNode? {
    guard index >= 0, index < count else { return nil }
    return nodes[index]
  }

  /// Regenerate the present frame root and each admitted text line together.
  public mutating func regenerate(
    from frame: borrowing BrushstrokeFrame,
    rootRect: AccessibilityCellRect
  ) throws {
    let nextCount = 1 + frame.lineCount
    guard nextCount <= SkateCoreBounds.accessibilityNodeCapacity else {
      throw AccessibilitySnapshotError.accessibilityTooLarge(
        limit: SkateCoreBounds.accessibilityNodeCapacity)
    }

    var nextNodes: InlineArray<9, AccessibilityNode?> = .init(repeating: nil)
    nextNodes[0] = AccessibilityNode.frameRoot(from: frame, rect: rootRect)
    var row = 0
    while row < frame.lineCount {
      let seat = row + 1
      // invariant: the preflighted root-plus-lines count fits all nine seats.
      precondition(seat < SkateCoreBounds.accessibilityNodeCapacity)
      nextNodes[seat] = try AccessibilityNode.textLine(from: frame, row: row)
      row += 1
    }
    // invariant: one root plus every walked line equals the checked next count.
    precondition(row + 1 == nextCount)

    nodes = nextNodes
    count = nextCount
  }

  /// Regenerate from a caller-owned semantic collection for package proofs.
  ///
  /// This package-internal path keeps the full refusal reachable without
  /// choosing AppKit roles, actions, or storage. Every node is already a
  /// validated bounded value.
  mutating func regenerate<Nodes>(from input: borrowing Nodes) throws
  where Nodes: RandomAccessCollection, Nodes.Element == AccessibilityNode {
    let inputCount = input.count
    guard inputCount <= SkateCoreBounds.accessibilityNodeCapacity else {
      throw AccessibilitySnapshotError.accessibilityTooLarge(
        limit: SkateCoreBounds.accessibilityNodeCapacity)
    }

    var nextNodes: InlineArray<9, AccessibilityNode?> = .init(repeating: nil)
    var seat = 0
    var position = input.startIndex
    while position != input.endIndex {
      // invariant: the checked collection count keeps each copy inside scratch.
      precondition(seat < SkateCoreBounds.accessibilityNodeCapacity)
      nextNodes[seat] = input[position]
      seat += 1
      position = input.index(after: position)
    }
    // invariant: a stable random-access input supplies exactly its checked count.
    precondition(seat == inputCount)

    nodes = nextNodes
    count = inputCount
  }

  public static func == (
    left: AccessibilitySnapshot,
    right: AccessibilitySnapshot
  ) -> Bool {
    left.hasSameStoredState(as: right)
  }

  /// Compare the public count and all nine physical seats for refusal proofs.
  func hasSameStoredState(as other: borrowing AccessibilitySnapshot) -> Bool {
    if count != other.count { return false }
    var physicalSeat = 0
    while physicalSeat < SkateCoreBounds.accessibilityNodeCapacity {
      if nodes[physicalSeat] != other.nodes[physicalSeat] { return false }
      physicalSeat += 1
    }
    return true
  }

  /// Read physical scratch, including retired seats, for package controls.
  func storedNode(at physicalSeat: Int) -> AccessibilityNode? {
    guard physicalSeat >= 0,
      physicalSeat < SkateCoreBounds.accessibilityNodeCapacity
    else { return nil }
    return nodes[physicalSeat]
  }
}

/// Alias-sameness: Surf and Skate carry one semantic snapshot identity.
@available(macOS 26.0, *)
public typealias SurfAccessibilitySnapshot = AccessibilitySnapshot

@available(macOS 26.0, *)
public typealias SkateAccessibilitySnapshot = AccessibilitySnapshot
