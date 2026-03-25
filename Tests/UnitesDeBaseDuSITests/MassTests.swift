import Testing

@testable import UnitesDeBaseDuSI

struct MassTests {
    @Test
    func luggageMassCanBeCombinedForShipping() throws {
        let suitcase = try Quantity<Double, Kilogram, Linear>(18.5)
        let carryOn = try Quantity<Double, Kilogram, Linear>(7.0)
        let total = try suitcase + carryOn

        #expect(total.value == 25.5)
        #expect(total.baseValue == 25.5)
        #expect(total > suitcase)
    }

    @Test
    func zeroMassBehavesAsAdditiveIdentity() throws {
        let parcel = try Quantity<Double, Kilogram, Linear>(12.5)
        let zero = try Quantity<Double, Kilogram, Linear>(0)

        #expect((try parcel + zero).value == parcel.value)
        #expect((try parcel + zero).baseValue == parcel.baseValue)
    }

    @Test
    func equalMassesCompareAsEqual() throws {
        let checkedBag = try Quantity<Double, Kilogram, Linear>(20)
        let measuredBag = try Quantity<Double, Kilogram, Linear>(20)

        #expect(checkedBag == measuredBag)
        #expect(checkedBag >= measuredBag)
        #expect(checkedBag <= measuredBag)
    }

    @Test
    func subtractingMassFromItselfProducesZero() throws {
        let crate = try Quantity<Double, Kilogram, Linear>(32)
        let difference = try crate - crate

        #expect(difference.value == 0)
        #expect(difference.baseValue == 0)
    }

    @Test
    func negativeMassIsRepresentableUnderCurrentSemantics() throws {
        let adjustment = try Quantity<Double, Kilogram, Linear>(-1.5)
        let zero = try Quantity<Double, Kilogram, Linear>(0)

        #expect(adjustment.value == -1.5)
        #expect(adjustment.baseValue == -1.5)
        #expect(adjustment < zero)
    }
}
