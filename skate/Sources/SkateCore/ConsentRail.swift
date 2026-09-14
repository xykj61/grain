/// A bounded presentation rail for the consent carried by a readable receipt.
///
/// Motion changes disclosure only. The purpose, recipient, expiration, and
/// consent status remain identical in Still, Settle, and reduced-motion views.
@available(macOS 26.0, *)
public struct ConsentRail: Equatable, Sendable {
  public static let columns = 72
  public static let rows = 5
  public static let cellCapacity = columns * rows
  public static let settleDurationMilliseconds = 1_000
  public static let pulseLifetimeMilliseconds = 400

  public enum RailError: Error, Equatable, Sendable {
    case emptyField(String)
    case nonASCII(String)
    case fieldTooWide(field: String, limit: Int)
    case invalidElapsedMilliseconds
  }

  public enum Disclosure: Equatable, Sendable {
    case folded
    case expanded
  }

  public struct Frame: Equatable, Sendable {
    private var cells: InlineArray<360, UInt8> = .init(repeating: 0x20)
    public private(set) var lineCount = 0

    fileprivate init(lines: [String]) throws {
      var next: InlineArray<360, UInt8> = .init(repeating: 0x20)
      for (row, line) in lines.enumerated() {
        let bytes = Array(line.utf8)
        guard bytes.count <= ConsentRail.columns else {
          throw RailError.fieldTooWide(field: "rendered_row_\(row)", limit: ConsentRail.columns)
        }
        for (column, byte) in bytes.enumerated() {
          next[row * ConsentRail.columns + column] = byte
        }
      }
      cells = next
      lineCount = lines.count
    }

    public func accessibilityLine(row: Int) -> [UInt8]? {
      guard row >= 0, row < lineCount else { return nil }
      var end = ConsentRail.columns
      while end > 0, cells[row * ConsentRail.columns + end - 1] == 0x20 { end -= 1 }
      var line: [UInt8] = []
      line.reserveCapacity(end)
      for column in 0..<end { line.append(cells[row * ConsentRail.columns + column]) }
      return line
    }
  }

  private let foldedFrame: Frame
  private let expandedFrame: Frame

  public init(
    purpose: String,
    recipientID: String,
    expiresAt: String,
    consentStatus: String
  ) throws {
    let fields = [
      ("purpose", purpose, 80),
      ("recipient_id", recipientID, 96),
      ("expires_at", expiresAt, 96),
      ("consent_status", consentStatus, 24),
    ]
    for (name, value, limit) in fields {
      try Self.validate(field: name, value: value, limit: limit)
    }
    foldedFrame = try Frame(lines: [
      "consent  \(consentStatus)",
      "purpose  \(purpose)",
    ])
    expandedFrame = try Frame(lines: [
      "consent  \(consentStatus)",
      "purpose  \(purpose)",
      "party    \(recipientID)",
      "expires  \(expiresAt)",
    ])
  }

  /// Render the complete Still frame for one disclosure state.
  public func still(disclosure: Disclosure) -> Frame {
    disclosure == .folded ? foldedFrame : expandedFrame
  }

  /// Return the settled frame once the bounded transition has elapsed.
  public func settle(
    to disclosure: Disclosure,
    elapsedMilliseconds: Int,
    reducedMotion: Bool
  ) throws -> Frame? {
    guard elapsedMilliseconds >= 0 else { throw RailError.invalidElapsedMilliseconds }
    let duration = reducedMotion ? 0 : Self.settleDurationMilliseconds
    guard elapsedMilliseconds >= duration else { return nil }
    return still(disclosure: disclosure)
  }

  /// Report whether a local response pulse is visible at this instant.
  public func responds(elapsedMilliseconds: Int) throws -> Bool {
    guard elapsedMilliseconds >= 0 else { throw RailError.invalidElapsedMilliseconds }
    return elapsedMilliseconds < Self.pulseLifetimeMilliseconds
  }

  /// Accessibility reads the same row bytes used by the visual frame.
  private static func validate(field: String, value: String, limit: Int) throws {
    guard !value.isEmpty else { throw RailError.emptyField(field) }
    let bytes = Array(value.utf8)
    guard bytes.allSatisfy({ $0 < 0x80 }) else { throw RailError.nonASCII(field) }
    guard bytes.count <= limit else {
      throw RailError.fieldTooWide(field: field, limit: limit)
    }
  }
}
