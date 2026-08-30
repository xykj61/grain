/// Refusals from the narrow native receipt for Image's bounded edit history.
///
/// Image owns the photo-edit grammar, parsing, and replay. This package admits
/// only caller-supplied rendered line claims and keeps them in Image's seated
/// order and capacities.
public enum ImageEditHistoryError: Error, Equatable, Sendable {
  case emptyRecord
  case recordTooWide(limit: Int)
  case historyFull(limit: Int)
}

extension SkateCoreBounds {
  public static let imageEditCapacity = 64
  public static let imageEditRecordBytes = 49
  public static let imageEditPayloadBytes = imageEditCapacity * imageEditRecordBytes
}

/// One caller-supplied edit line in Image's public travel shape.
///
/// The `Claim` suffix is deliberate: this value proves the forty-nine-byte
/// storage bound only. Image remains the authority that parses the line as a
/// photo edit and replays it over an image.
@available(macOS 26.0, *)
public struct ImageEditRecordClaim: Equatable, Sendable {
  private var bytes: InlineArray<49, UInt8> = .init(repeating: 0)
  public private(set) var byteCount = 0

  public init<Bytes>(_ input: borrowing Bytes) throws
  where Bytes: RandomAccessCollection, Bytes.Element == UInt8 {
    let inputCount = input.count
    guard inputCount > 0 else { throw ImageEditHistoryError.emptyRecord }
    guard inputCount <= SkateCoreBounds.imageEditRecordBytes else {
      throw ImageEditHistoryError.recordTooWide(
        limit: SkateCoreBounds.imageEditRecordBytes)
    }

    var nextBytes: InlineArray<49, UInt8> = .init(repeating: 0)
    var offset = 0
    var position = input.startIndex
    while position != input.endIndex {
      precondition(offset < SkateCoreBounds.imageEditRecordBytes)
      nextBytes[offset] = input[position]
      offset += 1
      position = input.index(after: position)
    }
    precondition(offset == inputCount)

    bytes = nextBytes
    byteCount = inputCount
  }

  public func byte(at offset: Int) -> UInt8? {
    guard offset >= 0, offset < byteCount else { return nil }
    return bytes[offset]
  }

  public static func == (
    left: ImageEditRecordClaim,
    right: ImageEditRecordClaim
  ) -> Bool {
    if left.byteCount != right.byteCount { return false }
    var offset = 0
    while offset < SkateCoreBounds.imageEditRecordBytes {
      if left.bytes[offset] != right.bytes[offset] { return false }
      offset += 1
    }
    return true
  }
}

/// Image's ordered edit-record claims carried in fixed native storage.
///
/// The history owns sixty-four record seats and a 3,136-byte payload budget.
/// A full append refuses before mutation, so no admitted record is evicted.
@available(macOS 26.0, *)
public struct ImageEditHistory: Equatable, Sendable {
  private var records: InlineArray<64, ImageEditRecordClaim?> = .init(repeating: nil)
  public private(set) var count = 0

  public init() {}

  public var payloadByteCount: Int {
    var total = 0
    var index = 0
    while index < count {
      if let record = records[index] {
        total += record.byteCount
      } else {
        preconditionFailure("an admitted edit seat must contain its record")
      }
      index += 1
    }
    precondition(total <= SkateCoreBounds.imageEditPayloadBytes)
    return total
  }

  public mutating func append(_ record: ImageEditRecordClaim) throws {
    guard count < SkateCoreBounds.imageEditCapacity else {
      throw ImageEditHistoryError.historyFull(
        limit: SkateCoreBounds.imageEditCapacity)
    }
    precondition(records[count] == nil)
    records[count] = record
    count += 1
    precondition(count <= SkateCoreBounds.imageEditCapacity)
  }

  public func record(at index: Int) -> ImageEditRecordClaim? {
    guard index >= 0, index < count else { return nil }
    return records[index]
  }

  public static func == (left: ImageEditHistory, right: ImageEditHistory) -> Bool {
    if left.count != right.count { return false }
    var index = 0
    while index < SkateCoreBounds.imageEditCapacity {
      if left.records[index] != right.records[index] { return false }
      index += 1
    }
    return true
  }
}

/// Alias-sameness: Surf and Skate carry one native history identity.
@available(macOS 26.0, *)
public typealias SurfImageEditHistory = ImageEditHistory

@available(macOS 26.0, *)
public typealias SkateImageEditHistory = ImageEditHistory
