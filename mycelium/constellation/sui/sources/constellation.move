// Grain Constellation — v1: an n-of-12 seat registry, and nothing more.
//
// This module holds seats; it mints nothing and moves no value. WOV genesis
// is design-only until securities counsel sits with the family. UNAUDITED —
// publish devnet/testnet first; mainnet, gas, and keys are Keaton's hand
// alone. Spec: mycelium/constellation/SPEC.md. Invariants asserted below.
module grain_constellation::constellation {
    use std::string::String;
    use sui::event;

    /// Invariant: the wheel holds at most twelve seats, signs 0..11.
    const MAX_SEATS: u64 = 12;

    const E_WHEEL_FULL: u64 = 0;
    const E_BAD_SIGN: u64 = 1;
    const E_SIGN_TAKEN: u64 = 2;

    /// The admin hand — held by the family at genesis; seating requires it.
    public struct AdminCap has key, store { id: UID }

    /// One seat: sign index, fund name, .fund DNS anchor, Kumara public key.
    public struct Seat has store, copy, drop {
        sign: u8,
        fund: String,
        dns_anchor: String,
        kumara_key: vector<u8>,
    }

    /// The shared wheel. Invariant: seats.length() <= MAX_SEATS; signs unique.
    public struct Constellation has key {
        id: UID,
        seats: vector<Seat>,
    }

    /// Emitted on every seating, so the world can index the wheel.
    public struct SeatSeated has copy, drop { sign: u8, fund: String }

    /// Genesis: share the empty wheel; the admin hand goes to the publisher.
    fun init(ctx: &mut TxContext) {
        transfer::share_object(Constellation { id: object::new(ctx), seats: vector[] });
        transfer::public_transfer(AdminCap { id: object::new(ctx) }, ctx.sender());
    }

    /// Seat one fund. Precondition: admin hand present; sign lawful and free.
    public entry fun add_seat(
        _admin: &AdminCap,
        wheel: &mut Constellation,
        sign: u8,
        fund: String,
        dns_anchor: String,
        kumara_key: vector<u8>,
    ) {
        assert!(wheel.seats.length() < MAX_SEATS, E_WHEEL_FULL);
        assert!((sign as u64) < MAX_SEATS, E_BAD_SIGN);
        let mut i = 0;
        while (i < wheel.seats.length()) {
            assert!(wheel.seats[i].sign != sign, E_SIGN_TAKEN);
            i = i + 1;
        };
        wheel.seats.push_back(Seat { sign, fund, dns_anchor, kumara_key });
        event::emit(SeatSeated { sign, fund });
    }

    /// Read the wheel's count — a convenience for indexers and witnesses.
    public fun seat_count(wheel: &Constellation): u64 { wheel.seats.length() }
}
