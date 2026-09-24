/// The fixed product surface for the first readable Linengrow receipt.
///
/// Input strings belong to the caller. The admitted card owns one 72-by-18
/// ASCII plane, and its semantic reader walks those same bytes in row order.
@available(macOS 26.0, *)
public struct ReceiptCard: Equatable, Sendable {
  public static let columns = 72
  public static let rows = 18
  public static let cellCapacity = columns * rows
  public static let identifierByteLimit = 96
  public static let purposeByteLimit = 80
  public static let valueBasisByteLimit = 120

  public enum CardError: Error, Equatable, Sendable {
    case emptyField(String)
    case nonASCII(String)
    case fieldTooWide(field: String, limit: Int)
    case amountOutOfBounds(limit: UInt64)
    case cardLineTooWide(row: Int, limit: Int)
  }

  private var cells: InlineArray<1296, UInt8> = .init(repeating: 0x20)
  public private(set) var lineCount = 0

  public init(
    receiptID: String,
    productID: String,
    purpose: String,
    recipientID: String,
    offeredValue: UInt64,
    valueUnit: String,
    valueBasis: String,
    promisedReturn: String,
    issuedAt: String,
    expiresAt: String,
    status: String
  ) throws {
    let fields = [
      ("receipt_id", receiptID, Self.identifierByteLimit),
      ("product_id", productID, Self.identifierByteLimit),
      ("purpose", purpose, Self.purposeByteLimit),
      ("recipient_id", recipientID, Self.identifierByteLimit),
      ("value_unit", valueUnit, Self.identifierByteLimit),
      ("value_basis", valueBasis, Self.valueBasisByteLimit),
      ("promised_return", promisedReturn, Self.identifierByteLimit),
      ("issued_at", issuedAt, Self.identifierByteLimit),
      ("expires_at", expiresAt, Self.identifierByteLimit),
      ("status", status, Self.identifierByteLimit),
    ]
    for (name, value, limit) in fields {
      try Self.validate(field: name, value: value, limit: limit)
    }
    guard offeredValue <= 9_000_000_000 else {
      throw CardError.amountOutOfBounds(limit: 9_000_000_000)
    }

    let lines = [
      "+-- RECEIPT CARD ------------------------------------------------------+",
      "receipt  \(receiptID)",
      "product  \(productID)",
      "purpose  \(purpose)",
      "party    \(recipientID)",
      "value    \(offeredValue) \(valueUnit)",
      "basis    \(valueBasis)",
      "return   \(promisedReturn)",
      "issued   \(issuedAt)",
      "expires  \(expiresAt)",
      "status   \(status)",
      "+----------------------------------------------------------------------+",
    ]

    var next: InlineArray<1296, UInt8> = .init(repeating: 0x20)
    var row = 0
    while row < lines.count {
      let bytes = Array(lines[row].utf8)
      guard bytes.count <= Self.columns else {
        throw CardError.cardLineTooWide(row: row, limit: Self.columns)
      }
      var column = 0
      while column < bytes.count {
        precondition(row < Self.rows)
        precondition(column < Self.columns)
        next[row * Self.columns + column] = bytes[column]
        column += 1
      }
      row += 1
    }
    precondition(row <= Self.rows)
    cells = next
    lineCount = row
  }

  public func byte(row: Int, column: Int) -> UInt8? {
    guard row >= 0, row < lineCount else { return nil }
    guard column >= 0, column < Self.columns else { return nil }
    return cells[row * Self.columns + column]
  }

  /// Read one semantic line from the rendered plane itself.
  public func accessibilityLine(row: Int) -> [UInt8]? {
    guard row >= 0, row < lineCount else { return nil }
    var end = Self.columns
    while end > 0, cells[row * Self.columns + end - 1] == 0x20 { end -= 1 }
    var line: [UInt8] = []
    line.reserveCapacity(end)
    var column = 0
    while column < end {
      line.append(cells[row * Self.columns + column])
      column += 1
    }
    return line
  }

  /// Return the complete Still frame in the same row order used by accessibility.
  public func stillFrame() -> [[UInt8]] {
    var lines: [[UInt8]] = []
    lines.reserveCapacity(lineCount)
    var row = 0
    while row < lineCount {
      lines.append(accessibilityLine(row: row) ?? [])
      row += 1
    }
    return lines
  }

  private static func validate(field: String, value: String, limit: Int) throws {
    guard !value.isEmpty else { throw CardError.emptyField(field) }
    let bytes = Array(value.utf8)
    guard bytes.allSatisfy({ $0 < 0x80 }) else { throw CardError.nonASCII(field) }
    guard bytes.count <= limit else {
      throw CardError.fieldTooWide(field: field, limit: limit)
    }
  }
}
