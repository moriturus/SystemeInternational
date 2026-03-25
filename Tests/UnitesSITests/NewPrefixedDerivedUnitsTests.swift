import Testing

@testable import UnitesSI

struct NewPrefixedDerivedUnitsTests {
    // MARK: - Hertz

    @Test
    func hertzPrefixedUnitsExposeExpectedScaleAndSymbol() throws {
        #expect(Kilohertz.symbol == "kHz")
        #expect(Megahertz.symbol == "MHz")
        #expect(Gigahertz.symbol == "GHz")
    }

    @Test
    func prefixedHertzRoundTripConversion() throws {
        let freq = try Quantity<Double, Kilohertz, Linear>(2.4)
        let inHz = freq.converted(to: Hertz.self)
        let backToKHz = inHz.converted(to: Kilohertz.self)

        #expect(abs(inHz.value - 2_400) < 0.000_000_1)
        #expect(abs(backToKHz.value - 2.4) < 0.000_000_1)
    }

    @Test
    func prefixedHertzCoversMegaAndGigaConversions() throws {
        let mhz = try Quantity<Double, Megahertz, Linear>(104.3)
        let ghz = try Quantity<Double, Gigahertz, Linear>(2.4)

        #expect(abs(mhz.converted(to: Hertz.self).value - 104_300_000) < 0.000_1)
        #expect(abs(ghz.converted(to: Hertz.self).value - 2_400_000_000) < 0.000_1)
        #expect(abs(ghz.converted(to: Megahertz.self).value - 2_400) < 0.000_000_1)
    }

    // MARK: - Becquerel

    @Test
    func prefixedBecquerelScalesAreCorrect() throws {
        #expect(Kilobecquerel.symbol == "kBq")
        #expect(Megabecquerel.symbol == "MBq")
        #expect(Gigabecquerel.symbol == "GBq")

        let activity = try Quantity<Double, Kilobecquerel, Linear>(5.0)
        let inBq = activity.converted(to: Becquerel.self)
        #expect(abs(inBq.value - 5_000) < 0.000_000_1)

        let megaAct = try Quantity<Double, Megabecquerel, Linear>(1.2)
        #expect(abs(megaAct.converted(to: Becquerel.self).value - 1_200_000) < 0.000_1)

        let gigaAct = try Quantity<Double, Gigabecquerel, Linear>(0.3)
        #expect(abs(gigaAct.converted(to: Becquerel.self).value - 300_000_000) < 0.000_1)
    }

    // MARK: - Gray

    @Test
    func prefixedGrayScalesAreCorrect() throws {
        #expect(Milligray.symbol == "mGy")
        #expect(Microgray.symbol == "μGy")

        let dose = try Quantity<Double, Milligray, Linear>(250)
        let inGy = dose.converted(to: Gray.self)
        #expect(abs(inGy.value - 0.25) < 0.000_000_1)

        let microDose = try Quantity<Double, Microgray, Linear>(500)
        #expect(abs(microDose.converted(to: Gray.self).value - 0.000_5) < 0.000_000_000_1)
    }

    // MARK: - Sievert

    @Test
    func prefixedSievertScalesAreCorrect() throws {
        #expect(Millisievert.symbol == "mSv")
        #expect(Microsievert.symbol == "μSv")

        let equivalent = try Quantity<Double, Millisievert, Linear>(20)
        let inSv = equivalent.converted(to: Sievert.self)
        #expect(abs(inSv.value - 0.02) < 0.000_000_1)

        let microEq = try Quantity<Double, Microsievert, Linear>(100)
        #expect(abs(microEq.converted(to: Sievert.self).value - 0.000_1) < 0.000_000_000_1)
    }

    // MARK: - Previously untested derived unit prefix round-trips

    @Test
    func derivedUnitPrefixedScaleRoundTrips() throws {
        // Newton
        let force = try Quantity<Double, Kilonewton, Linear>(1.5)
        let inN = force.converted(to: Newton.self)
        #expect(abs(inN.value - 1_500) < 0.000_000_1)

        // Watt
        let power = try Quantity<Double, Kilowatt, Linear>(3.0)
        #expect(abs(power.converted(to: Watt.self).value - 3_000) < 0.000_000_1)

        let megaPower = try Quantity<Double, Megawatt, Linear>(1.2)
        #expect(abs(megaPower.converted(to: Watt.self).value - 1_200_000) < 0.000_1)

        // Coulomb
        let charge = try Quantity<Double, Kilocoulomb, Linear>(0.5)
        #expect(abs(charge.converted(to: Coulomb.self).value - 500) < 0.000_000_1)

        // Volt
        let voltage = try Quantity<Double, Millivolt, Linear>(750)
        #expect(abs(voltage.converted(to: Volt.self).value - 0.75) < 0.000_000_1)

        let kilovolt = try Quantity<Double, Kilovolt, Linear>(1.1)
        #expect(abs(kilovolt.converted(to: Volt.self).value - 1_100) < 0.000_000_1)

        // Ohm
        let resistance = try Quantity<Double, Kiloohm, Linear>(4.7)
        #expect(abs(resistance.converted(to: Ohm.self).value - 4_700) < 0.000_000_1)

        // Siemens
        let conductance = try Quantity<Double, Millisiemens, Linear>(250)
        #expect(abs(conductance.converted(to: Siemens.self).value - 0.25) < 0.000_000_1)

        // Tesla
        let flux = try Quantity<Double, Millitesla, Linear>(500)
        #expect(abs(flux.converted(to: Tesla.self).value - 0.5) < 0.000_000_1)

        // Henry
        let inductance = try Quantity<Double, Millihenry, Linear>(22)
        #expect(abs(inductance.converted(to: Henry.self).value - 0.022) < 0.000_000_1)

        // Katal
        let catalytic = try Quantity<Double, Microkatal, Linear>(10)
        #expect(abs(catalytic.converted(to: Katal.self).value - 0.000_01) < 0.000_000_000_1)
    }
}
