import XCTest

@testable import SkateCore

@available(macOS 26.0, *)
final class ReceiptAccessibilitySnapshotTests: XCTestCase {
  func testStillAndAccessibilitySnapshotKeepAllDecidingFieldsInOneOrder() throws {
    let card = try ReceiptCard(
      receiptID: "receipt:unique-id",
      productID: "product:unique-product",
      purpose: "purpose:unique-purpose",
      recipientID: "recipient:unique-recipient",
      offeredValue: 1200,
      valueUnit: "USD-cent-simulated",
      valueBasis: "basis:unique-basis",
      promisedReturn: "return:unique-return",
      issuedAt: "issued:unique-issued",
      expiresAt: "expires:unique-expires",
      status: "offered"
    )
    let snapshot = ReceiptAccessibilitySnapshot(card: card)

    XCTAssertEqual(snapshot.lines, card.stillFrame())
    XCTAssertEqual(snapshot.entries.count, ReceiptAccessibilitySnapshot.decidingFieldCount)
    XCTAssertEqual(snapshot.entries.map(\.name), [
      "receipt_id", "product_id", "purpose", "recipient_id", "offered_value",
      "value_unit", "value_basis", "promised_return", "issued_at", "expires_at", "status",
    ])
    XCTAssertEqual(snapshot.entries.map(\.value), [
      "receipt:unique-id", "product:unique-product", "purpose:unique-purpose",
      "recipient:unique-recipient", "1200", "USD-cent-simulated", "basis:unique-basis",
      "return:unique-return", "issued:unique-issued", "expires:unique-expires", "offered",
    ])
  }
}
