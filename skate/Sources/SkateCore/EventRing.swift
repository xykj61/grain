/// A refusal from Surf and Skate's fixed event admission boundary.
public enum EventRingError: Error, Equatable, Sendable {
  case full(limit: Int)
  case counterExhausted
}

/// One neutral, fixed-capacity event queue for the headless Surf and Skate core.
///
/// AppKit may translate its callbacks into a domain event later. This type does
/// not choose that event vocabulary. It owns 128 optional seats inline, keeps
/// admitted and removed totals as monotonic UInt64 counters, and uses modulo
/// only to select a physical seat. A full queue refuses before mutation; it
/// never drops an older event to make room.
///
/// This type bounds queue structure, not an arbitrary generic payload's nested
/// storage. A shell must seat and prove its fixed domain event type separately
/// before offering untrusted platform input here.
@available(macOS 26.0, *)
public struct EventRing<Event: Sendable>: Sendable {
  private var events: InlineArray<128, Event?> = .init(repeating: nil)

  public private(set) var head: UInt64 = 0
  public private(set) var tail: UInt64 = 0

  public init() {}

  /// Begin a logically empty ring at a supplied monotonic counter origin.
  ///
  /// This package-internal proof seam reaches the unsigned ceiling without
  /// spending UInt64.max queue operations. Equal counters preserve the same
  /// empty state as the public zero-origin initializer.
  init(counterOrigin: UInt64) {
    head = counterOrigin
    tail = counterOrigin
    precondition(head == tail)
    precondition(count == 0)
  }

  public var count: Int {
    precondition(tail >= head)
    let distance = tail - head
    precondition(distance <= UInt64(SkateCoreBounds.eventCapacity))
    return Int(distance)
  }

  public var isEmpty: Bool { head == tail }

  public func first() -> Event? {
    guard head < tail else { return nil }
    guard case .some(let event) = storedEvent(at: head) else {
      preconditionFailure("an admitted event must occupy its physical seat")
    }
    return event
  }

  /// Read one physical seat through its linear counter for package proofs.
  func storedEvent(at counter: UInt64) -> Event? {
    events[physicalSlot(for: counter)]
  }

  public mutating func append(_ event: Event) throws {
    guard count < SkateCoreBounds.eventCapacity else {
      throw EventRingError.full(limit: SkateCoreBounds.eventCapacity)
    }

    let nextTail = try Self.advanced(tail)
    let slot = physicalSlot(for: tail)
    guard case .none = events[slot] else {
      preconditionFailure("an available event seat must be empty")
    }

    events[slot] = event
    tail = nextTail
    precondition(count <= SkateCoreBounds.eventCapacity)
  }

  public mutating func removeFirst() -> Event? {
    guard head < tail else { return nil }

    let slot = physicalSlot(for: head)
    guard case .some(let event) = events[slot] else {
      preconditionFailure("an admitted event must occupy its physical seat")
    }

    events[slot] = nil
    head += 1
    precondition(tail >= head)
    return event
  }

  private func physicalSlot(for counter: UInt64) -> Int {
    Int(counter % UInt64(SkateCoreBounds.eventCapacity))
  }

  static func advanced(_ counter: UInt64) throws -> UInt64 {
    guard counter < UInt64.max else { throw EventRingError.counterExhausted }
    return counter + 1
  }
}

/// Alias-sameness: both spoken names use the one neutral event queue type.
@available(macOS 26.0, *)
public typealias SurfEventRing<Event: Sendable> = EventRing<Event>

@available(macOS 26.0, *)
public typealias SkateEventRing<Event: Sendable> = EventRing<Event>
