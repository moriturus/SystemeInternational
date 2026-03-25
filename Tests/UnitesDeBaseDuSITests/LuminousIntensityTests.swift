import Testing

@testable import UnitesDeBaseDuSI

struct LuminousIntensityTests {
    @Test
    func lampBrightnessSpecificationsCanBeComparedInCandela() throws {
        let hallwayLamp = try Quantity<Int, Candela, Linear>(exactly: 450)
        let deskLamp = try Quantity<Int, Candela, Linear>(exactly: 300)
        let combinedOutput = try hallwayLamp + deskLamp

        #expect(hallwayLamp > deskLamp)
        #expect(combinedOutput.exactValue == 750)
        #expect(combinedOutput.baseValue == 750)
    }

    @Test
    func zeroCandelaBehavesAsAdditiveIdentity() throws {
        let fixture = try Quantity<Int, Candela, Linear>(exactly: 120)
        let darkness = try Quantity<Int, Candela, Linear>(exactly: 0)

        #expect(try (fixture + darkness).exactValue == 120)
        #expect(try (fixture - fixture).exactValue == 0)
    }

    @Test
    func equalBrightnessValuesCompareAsEqual() throws {
        let fixtureA = try Quantity<Int, Candela, Linear>(exactly: 300)
        let fixtureB = try Quantity<Int, Candela, Linear>(exactly: 300)

        #expect(fixtureA == fixtureB)
        #expect(fixtureA >= fixtureB)
        #expect(fixtureA <= fixtureB)
    }

    @Test
    func negativeBrightnessValuesRemainRepresentable() throws {
        let correction = try Quantity<Int, Candela, Linear>(exactly: -20)
        let noLight = try Quantity<Int, Candela, Linear>(exactly: 0)

        #expect(correction.exactValue == -20)
        #expect(correction < noLight)
    }
}
