import XCTest

@testable import SkateCore

@available(macOS 26.0, *)
final class AccessibilitySnapshotTests: XCTestCase {
  func testAccessibilitySnapshotRegeneratesRootAndEightLinesAtExactBounds() throws {
    let nib = (0..<SkateCoreBounds.nibBytes).map { UInt8($0) }
    var frame = try BrushstrokeFrame(atNib: nib, maxLines: SkateCoreBounds.rows)

    var row = 0
    while row < SkateCoreBounds.rows {
      let line = (0..<SkateCoreBounds.columns).map { column in
        UInt8((row + column) % 95 + 0x20)
      }
      try frame.append(line: line)
      row += 1
    }

    var snapshot = AccessibilitySnapshot()
    let rootRect = try fullRowRect()
    try snapshot.regenerate(from: frame, rootRect: rootRect)

    XCTAssertEqual(snapshot.count, SkateCoreBounds.accessibilityNodeCapacity)
    let root = try XCTUnwrap(snapshot.node(at: 0))
    XCTAssertEqual(root.role, .frame)
    XCTAssertEqual(root.labelByteCount, SkateCoreBounds.nibBytes)
    XCTAssertEqual(root.labelByte(at: 0), 0)
    XCTAssertEqual(root.labelByte(at: SkateCoreBounds.nibBytes - 1), 127)
    XCTAssertNil(root.labelByte(at: SkateCoreBounds.nibBytes))
    XCTAssertEqual(root.rect.row, 0)
    XCTAssertEqual(root.rect.columnStart, 0)
    XCTAssertEqual(root.rect.cellCount, UInt8(SkateCoreBounds.columns))

    row = 0
    while row < SkateCoreBounds.rows {
      let node = try XCTUnwrap(snapshot.node(at: row + 1))
      XCTAssertEqual(node.role, .textLine)
      XCTAssertEqual(node.labelByteCount, SkateCoreBounds.columns)
      XCTAssertEqual(node.labelByte(at: 0), UInt8(row % 95 + 0x20))
      XCTAssertEqual(
        node.labelByte(at: SkateCoreBounds.columns - 1),
        UInt8((row + SkateCoreBounds.columns - 1) % 95 + 0x20)
      )
      XCTAssertEqual(node.rect.row, UInt8(row))
      XCTAssertEqual(node.rect.columnStart, 0)
      XCTAssertEqual(node.rect.cellCount, UInt8(SkateCoreBounds.columns))
      row += 1
    }

    let surf: SurfAccessibilitySnapshot = snapshot
    let skate: SkateAccessibilitySnapshot = surf
    let returned: SurfAccessibilitySnapshot = skate
    XCTAssertEqual(returned, snapshot)
  }

  func testAccessibilityTooLargeRefusesWithLastWholeSnapshotUnchanged() throws {
    var frame = try BrushstrokeFrame(atNib: [0x6e], maxLines: 1)
    try frame.append(line: Array("kept".utf8))

    var snapshot = AccessibilitySnapshot()
    try snapshot.regenerate(from: frame, rootRect: fullRowRect())
    let before = snapshot
    let oversized = try (0...SkateCoreBounds.accessibilityNodeCapacity).map { index in
      try node(seed: UInt8(index), row: index % SkateCoreBounds.rows)
    }

    XCTAssertThrowsError(try snapshot.regenerate(from: oversized)) { error in
      XCTAssertEqual(
        error as? AccessibilitySnapshotError,
        .accessibilityTooLarge(limit: SkateCoreBounds.accessibilityNodeCapacity)
      )
    }
    XCTAssertEqual(snapshot, before)
    XCTAssertTrue(snapshot.hasSameStoredState(as: before))
  }

  func testAccessibilityRegenerationIsDeterministic() throws {
    var frame = try BrushstrokeFrame(
      atNib: Array("stable-frame".utf8),
      maxLines: SkateCoreBounds.rows
    )
    try frame.append(line: Array("first line".utf8))
    try frame.append(line: Array("second line".utf8))

    var first = AccessibilitySnapshot()
    var second = AccessibilitySnapshot()
    let rootRect = try fullRowRect()
    try first.regenerate(from: frame, rootRect: rootRect)
    try second.regenerate(from: frame, rootRect: rootRect)
    XCTAssertEqual(first, second)

    try first.regenerate(from: frame, rootRect: rootRect)
    XCTAssertEqual(first, second)
  }

  func testAccessibilityRegenerationClearsEveryRetiredPhysicalSeat() throws {
    var fullFrame = try BrushstrokeFrame(atNib: [0x66], maxLines: SkateCoreBounds.rows)
    var row = 0
    while row < SkateCoreBounds.rows {
      try fullFrame.append(line: [UInt8(row + 1)])
      row += 1
    }

    var snapshot = AccessibilitySnapshot()
    try snapshot.regenerate(from: fullFrame, rootRect: fullRowRect())
    XCTAssertEqual(snapshot.count, SkateCoreBounds.accessibilityNodeCapacity)

    var shortFrame = try BrushstrokeFrame(atNib: [0x73], maxLines: 1)
    try shortFrame.append(line: [0x41])
    try snapshot.regenerate(from: shortFrame, rootRect: fullRowRect())

    XCTAssertEqual(snapshot.count, 2)
    XCTAssertEqual(snapshot.storedNode(at: 0)?.role, .frame)
    XCTAssertEqual(snapshot.storedNode(at: 1)?.role, .textLine)
    var physicalSeat = 2
    while physicalSeat < SkateCoreBounds.accessibilityNodeCapacity {
      XCTAssertNil(snapshot.storedNode(at: physicalSeat))
      physicalSeat += 1
    }
  }

  func testAccessibilityNodeBoundsRefuseBeforeAValueExists() throws {
    XCTAssertNoThrow(
      try AccessibilityNode(
        role: .frame,
        label: [UInt8](repeating: 0x41, count: SkateCoreBounds.nibBytes),
        row: SkateCoreBounds.rows - 1,
        columnStart: SkateCoreBounds.columns - 1,
        cellCount: 1
      )
    )
    XCTAssertNoThrow(
      try AccessibilityNode(
        role: .textLine,
        label: [UInt8](repeating: 0x41, count: SkateCoreBounds.columns),
        row: SkateCoreBounds.rows - 1,
        columnStart: SkateCoreBounds.columns - 1,
        cellCount: 1
      )
    )

    XCTAssertThrowsError(
      try AccessibilityNode(
        role: .textLine,
        label: [UInt8](),
        row: 0,
        columnStart: 0,
        cellCount: 1
      )
    ) { error in
      XCTAssertEqual(error as? AccessibilityNodeError, .emptyLabel)
    }
    XCTAssertThrowsError(
      try AccessibilityNode(
        role: .frame,
        label: [UInt8](repeating: 0x41, count: SkateCoreBounds.nibBytes + 1),
        row: 0,
        columnStart: 0,
        cellCount: 1
      )
    ) { error in
      XCTAssertEqual(
        error as? AccessibilityNodeError,
        .labelTooWide(limit: SkateCoreBounds.nibBytes)
      )
    }
    XCTAssertThrowsError(
      try AccessibilityNode(
        role: .textLine,
        label: [UInt8](repeating: 0x41, count: SkateCoreBounds.columns + 1),
        row: 0,
        columnStart: 0,
        cellCount: 1
      )
    ) { error in
      XCTAssertEqual(
        error as? AccessibilityNodeError,
        .labelTooWide(limit: SkateCoreBounds.columns)
      )
    }

    for badRow in [-1, SkateCoreBounds.rows] {
      XCTAssertThrowsError(
        try AccessibilityNode(
          role: .textLine,
          label: [0x41],
          row: badRow,
          columnStart: 0,
          cellCount: 1
        )
      ) { error in
        XCTAssertEqual(
          error as? AccessibilityNodeError,
          .rowOutOfBounds(limit: SkateCoreBounds.rows)
        )
      }
    }
    for badColumn in [-1, SkateCoreBounds.columns] {
      XCTAssertThrowsError(
        try AccessibilityNode(
          role: .textLine,
          label: [0x41],
          row: 0,
          columnStart: badColumn,
          cellCount: 1
        )
      ) { error in
        XCTAssertEqual(
          error as? AccessibilityNodeError,
          .columnStartOutOfBounds(limit: SkateCoreBounds.columns)
        )
      }
    }
    for badCount in [0, SkateCoreBounds.columns + 1] {
      XCTAssertThrowsError(
        try AccessibilityNode(
          role: .textLine,
          label: [0x41],
          row: 0,
          columnStart: 0,
          cellCount: badCount
        )
      ) { error in
        XCTAssertEqual(
          error as? AccessibilityNodeError,
          .cellCountOutOfBounds(limit: SkateCoreBounds.columns)
        )
      }
    }
    XCTAssertThrowsError(
      try AccessibilityNode(
        role: .textLine,
        label: [0x41],
        row: 0,
        columnStart: SkateCoreBounds.columns - 1,
        cellCount: 2
      )
    ) { error in
      XCTAssertEqual(
        error as? AccessibilityNodeError,
        .cellRangeOutOfBounds(limit: SkateCoreBounds.columns)
      )
    }
  }

  private func node(seed: UInt8, row: Int) throws -> AccessibilityNode {
    try AccessibilityNode(
      role: .textLine,
      label: [seed],
      row: row,
      columnStart: 0,
      cellCount: 1
    )
  }

  private func fullRowRect(row: Int = 0) throws -> AccessibilityCellRect {
    try AccessibilityCellRect(
      row: row,
      columnStart: 0,
      cellCount: SkateCoreBounds.columns
    )
  }
}
