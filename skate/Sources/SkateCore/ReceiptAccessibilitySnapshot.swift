/// The semantic receipt view derived from the card's Still bytes.
@available(macOS 26.0, *)
public struct ReceiptAccessibilitySnapshot: Equatable, Sendable {
  public struct Entry: Equatable, Sendable {
    public let name: String
    public let value: String

    public init(name: String, value: String) {
      self.name = name
      self.value = value
    }
  }

  public static let decidingFieldCount = 11
  public let lines: [[UInt8]]
  public let entries: [Entry]

  /// Read the complete Still frame, so visual and semantic order share one source.
  public init(card: ReceiptCard) {
    lines = card.stillFrame()
    entries = Self.entries(from: lines)
  }

  private static func entries(from lines: [[UInt8]]) -> [Entry] {
    let labels = [
      ("receipt_id", "receipt  "),
      ("product_id", "product  "),
      ("purpose", "purpose  "),
      ("recipient_id", "party    "),
      ("offered_value", "value    "),
      ("value_unit", "value    "),
      ("value_basis", "basis    "),
      ("promised_return", "return   "),
      ("issued_at", "issued   "),
      ("expires_at", "expires  "),
      ("status", "status   "),
    ]
    var result: [Entry] = []
    result.reserveCapacity(labels.count)
    for (index, label) in labels.enumerated() {
      let row = index < 4 ? index + 1 : index < 6 ? 5 : index
      guard row < lines.count else { continue }
      let text = String(decoding: lines[row], as: UTF8.self)
      let value = String(text.dropFirst(label.1.count))
      if index == 4 {
        let amount = value.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        result.append(Entry(name: label.0, value: amount.first.map(String.init) ?? ""))
      } else if index == 5 {
        let unit = value.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        result.append(Entry(name: label.0, value: unit.dropFirst().first.map(String.init) ?? ""))
      } else {
        result.append(Entry(name: label.0, value: value))
      }
    }
    return result
  }
}
