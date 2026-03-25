import Testing

@testable import SIAccessories

struct PrefixedShorthandTests {
    @Test
    func prefixAccessorsReturnTheExpectedPrefixedScalarTypes() {
        let _: PrefixedScalar<Double, Quetta> = 1.0.quetta
        let _: PrefixedScalar<Double, Ronna> = 1.0.ronna
        let _: PrefixedScalar<Double, Yotta> = 1.0.yotta
        let _: PrefixedScalar<Double, Zetta> = 1.0.zetta
        let _: PrefixedScalar<Double, Exa> = 1.0.exa
        let _: PrefixedScalar<Double, Peta> = 1.0.peta
        let _: PrefixedScalar<Double, Tera> = 1.0.tera
        let _: PrefixedScalar<Double, Giga> = 1.0.giga
        let _: PrefixedScalar<Double, Mega> = 1.0.mega
        let _: PrefixedScalar<Double, Kilo> = 1.0.kilo
        let _: PrefixedScalar<Double, Hecto> = 1.0.hecto
        let _: PrefixedScalar<Double, Deca> = 1.0.deca
        let _: PrefixedScalar<Double, Deci> = 1.0.deci
        let _: PrefixedScalar<Double, Centi> = 1.0.centi
        let _: PrefixedScalar<Double, Milli> = 1.0.milli
        let _: PrefixedScalar<Double, Micro> = 1.0.micro
        let _: PrefixedScalar<Double, Nano> = 1.0.nano
        let _: PrefixedScalar<Double, Pico> = 1.0.pico
        let _: PrefixedScalar<Double, Femto> = 1.0.femto
        let _: PrefixedScalar<Double, Atto> = 1.0.atto
        let _: PrefixedScalar<Double, Zepto> = 1.0.zepto
        let _: PrefixedScalar<Double, Yocto> = 1.0.yocto
        let _: PrefixedScalar<Double, Ronto> = 1.0.ronto
        let _: PrefixedScalar<Double, Quecto> = 1.0.quecto

        let floatScalar: PrefixedScalar<Float, Milli> = Float(2.0).milli
        #expect(floatScalar.value == 2.0)

        let integerScalar: PrefixedScalar<Double, Kilo> = 2.kilo
        #expect(integerScalar.value == 2.0)
    }

    @Test
    func representativePrefixedQuantitiesConvertToExpectedBaseValues() throws {
        let distance = try 10.0.kilo.meter
        let mass = try 20.0.milli.gram
        let volume = try 1.5.milli.liter
        let power = try 3.0.mega.watt
        let integerDistance = try 1.kilo.meter

        #expect(distance.converted(to: Meter.self).value == 10_000.0)
        #expect(abs(mass.converted(to: Gram.self).value - 0.02) < 0.000_000_000_1)
        #expect(abs(volume.converted(to: Liter.self).value - 0.0015) < 0.000_000_000_1)
        #expect(power.converted(to: Watt.self).value == 3_000_000.0)
        #expect(integerDistance.converted(to: Meter.self).value == 1_000.0)
    }

    @Test
    func kilogramChainUsesPrefixedGramTypeAndMatchesExplicitKilogramConstruction() throws {
        let shorthand = try 1.0.kilo.gram
        let explicit = try Quantity<Double, Kilogram, Linear>(1.0)
        let directGram = try 20.0.milli.gram

        let _: Quantity<Double, SIPrefixedUnit<Gram, Kilo>, Linear> = shorthand

        #expect(shorthand.converted(to: Kilogram.self).value == explicit.value)
        #expect(abs(directGram.converted(to: Gram.self).value - 0.02) < 0.000_000_000_1)
    }
}
