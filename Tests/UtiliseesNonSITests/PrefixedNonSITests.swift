import Testing

@testable import UtiliseesNonSI

private func requireSameDimension<Left: UnitProtocol, Right: UnitProtocol>(
    _: Left.Type,
    _: Right.Type
) where Left.Dimension == Right.Dimension {}

private func requirePrefixable<Unit: SIPrefixableUnitProtocol>(_: Unit.Type) {}
private func requireDirectlyInitializable<Unit: DirectlyInitializableUnitProtocol>(_: Unit.Type) {}

struct PrefixedLiterTests {
    @Test
    func representativePrefixedLitersExposeCorrectSymbols() {
        #expect(Kiloliter.symbol == "kL")
        #expect(Hectoliter.symbol == "hL")
        #expect(Decaliter.symbol == "daL")
        #expect(Deciliter.symbol == "dL")
        #expect(Centiliter.symbol == "cL")
        #expect(Milliliter.symbol == "mL")
        #expect(Microliter.symbol == "μL")
        #expect(Nanoliter.symbol == "nL")
        #expect(Picoliter.symbol == "pL")
        #expect(Megaliter.symbol == "ML")
        #expect(Gigaliter.symbol == "GL")
    }

    @Test
    func prefixedLitersExposeExpectedScaleMetadata() throws {
        // Liter base scale is decimalExponent: -3
        // Kilo adds decimalExponent: 3 → combined: 0 (= 1 m³)
        // Milli adds decimalExponent: -3 → combined: -6
        // Micro adds decimalExponent: -6 → combined: -9
        let kilo = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 0)
        let milli = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -6)
        let micro = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -9)
        let centi = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -5)
        let deci = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -4)

        #expect(Kiloliter.scale == kilo)
        #expect(Milliliter.scale == milli)
        #expect(Microliter.scale == micro)
        #expect(Centiliter.scale == centi)
        #expect(Deciliter.scale == deci)
    }

    @Test
    func prefixedLitersShareDimensionWithBaseLiter() {
        requireSameDimension(Liter.self, Milliliter.self)
        requireSameDimension(Liter.self, Kiloliter.self)
        requireSameDimension(Liter.self, Microliter.self)
        requireSameDimension(Liter.self, Centiliter.self)
        requireSameDimension(Liter.self, Deciliter.self)
    }

    @Test
    func prefixedLitersRoundTripAgainstBaseLiter() throws {
        let volume = try Quantity<Double, Kiloliter, Linear>(2.5)
        let inLiters = volume.converted(to: Liter.self)
        let backToKiloliters = inLiters.converted(to: Kiloliter.self)

        let small = try Quantity<Double, Milliliter, Linear>(500)
        let inLitersFromML = small.converted(to: Liter.self)

        let tiny = try Quantity<Double, Microliter, Linear>(250)
        let inMilliliters = tiny.converted(to: Milliliter.self)

        #expect(inLiters.value == 2_500)
        #expect(abs(backToKiloliters.value - 2.5) < 0.000_000_1)
        #expect(abs(inLitersFromML.value - 0.5) < 0.000_000_1)
        #expect(abs(inMilliliters.value - 0.25) < 0.000_000_1)
    }

    @Test
    func integerPrefixedLiterConversionsPreserveExactness() throws {
        let oneKiloliter = try Quantity<Int, Kiloliter, Linear>(exactly: 1)
        let inLiters = try oneKiloliter.convertedIfExactly(to: Liter.self)
        let inMilliliters = try oneKiloliter.convertedIfExactly(to: Milliliter.self)

        #expect(inLiters.exactValue == 1_000)
        #expect(inMilliliters.exactValue == 1_000_000)
    }

    @Test
    func integerPrefixedLiterConversionsRejectFractionalResults() throws {
        let oneKiloliter = try Quantity<Int, Kiloliter, Linear>(exactly: 1)

        #expect(throws: QuantityError.nonIntegralConversion) {
            try oneKiloliter.convertedIfExactly(to: Megaliter.self)
        }

        #expect(Quantity<Int, Megaliter, Linear>(baseValue: 1).exactValue == nil)
    }

    @Test
    func literIsPrefixableAndDirectlyInitializable() {
        requirePrefixable(Liter.self)
        requireDirectlyInitializable(Liter.self)
    }
}

// MARK: - Prefixed Tonne

struct PrefixedTonneTests {
    @Test
    func representativePrefixedTonnesExposeCorrectSymbols() {
        #expect(Kilotonne.symbol == "kt")
        #expect(Megatonne.symbol == "Mt")
        #expect(Gigatonne.symbol == "Gt")
        #expect(Millitonne.symbol == "mt")
        #expect(Microtonne.symbol == "μt")
        #expect(Decitonne.symbol == "dt")
        #expect(Centitonne.symbol == "ct")
    }

    @Test
    func prefixedTonnesExposeExpectedScaleMetadata() throws {
        // Tonne base scale is decimalExponent: 3
        // Kilo adds decimalExponent: 3 → combined: 6
        // Milli adds decimalExponent: -3 → combined: 0
        // Mega adds decimalExponent: 6 → combined: 9
        let kilo = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 6)
        let milli = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 0)
        let mega = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 9)
        let micro = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -3)

        #expect(Kilotonne.scale == kilo)
        #expect(Millitonne.scale == milli)
        #expect(Megatonne.scale == mega)
        #expect(Microtonne.scale == micro)
    }

    @Test
    func prefixedTonnesShareDimensionWithBaseTonne() {
        requireSameDimension(Tonne.self, Kilotonne.self)
        requireSameDimension(Tonne.self, Megatonne.self)
        requireSameDimension(Tonne.self, Millitonne.self)
        requireSameDimension(Tonne.self, Microtonne.self)
    }

    @Test
    func prefixedTonnesRoundTripAgainstBaseTonne() throws {
        let mass = try Quantity<Double, Kilotonne, Linear>(2.5)
        let inTonnes = mass.converted(to: Tonne.self)
        let backToKilotonnes = inTonnes.converted(to: Kilotonne.self)

        let small = try Quantity<Double, Millitonne, Linear>(500)
        let inTonnesFromMt = small.converted(to: Tonne.self)

        let tiny = try Quantity<Double, Microtonne, Linear>(250)
        let inMillitonnes = tiny.converted(to: Millitonne.self)

        #expect(inTonnes.value == 2_500)
        #expect(abs(backToKilotonnes.value - 2.5) < 0.000_000_1)
        #expect(abs(inTonnesFromMt.value - 0.5) < 0.000_000_1)
        #expect(abs(inMillitonnes.value - 0.25) < 0.000_000_1)
    }

    @Test
    func integerPrefixedTonneConversionsPreserveExactness() throws {
        // Millitonne has combined decimalExponent 0 (identity scale) → integer construction succeeds
        let oneMillitonne = try Quantity<Int, Millitonne, Linear>(exactly: 1)
        let inKilograms = try oneMillitonne.convertedIfExactly(to: Kilogram.self)
        #expect(inKilograms.exactValue == 1)

        let oneKilotonne = try Quantity<Int, Kilotonne, Linear>(exactly: 1)
        let inTonnes = try oneKilotonne.convertedIfExactly(to: Tonne.self)
        #expect(inTonnes.exactValue == 1_000)
    }

    @Test
    func integerPrefixedTonneConversionsRejectFractionalResults() throws {
        let oneMillitonne = try Quantity<Int, Millitonne, Linear>(exactly: 1)

        #expect(throws: QuantityError.nonIntegralConversion) {
            try oneMillitonne.convertedIfExactly(to: Tonne.self)
        }
    }

    @Test
    func tonneIsPrefixableAndDirectlyInitializable() {
        requirePrefixable(Tonne.self)
        requireDirectlyInitializable(Tonne.self)
    }
}

// MARK: - Prefixed ElectronVolt

struct PrefixedElectronVoltTests {
    @Test
    func representativePrefixedElectronVoltsExposeCorrectSymbols() {
        #expect(Kiloelectronvolt.symbol == "keV")
        #expect(Megaelectronvolt.symbol == "MeV")
        #expect(Gigaelectronvolt.symbol == "GeV")
        #expect(Teraelectronvolt.symbol == "TeV")
        #expect(Millielectronvolt.symbol == "meV")
        #expect(Microelectronvolt.symbol == "μeV")
    }

    @Test
    func prefixedElectronVoltsExposeExpectedScaleMetadata() throws {
        // ElectronVolt base scale is (1_602_176_634, 1, -28)
        // Kilo adds decimalExponent: 3 → combined: (1_602_176_634, 1, -25)
        // Mega adds decimalExponent: 6 → combined: (1_602_176_634, 1, -22)
        // Milli adds decimalExponent: -3 → combined: (1_602_176_634, 1, -31)
        let kilo = try UnitScale(numerator: 1_602_176_634, denominator: 1, decimalExponent: -25)
        let mega = try UnitScale(numerator: 1_602_176_634, denominator: 1, decimalExponent: -22)
        let milli = try UnitScale(numerator: 1_602_176_634, denominator: 1, decimalExponent: -31)

        #expect(Kiloelectronvolt.scale == kilo)
        #expect(Megaelectronvolt.scale == mega)
        #expect(Millielectronvolt.scale == milli)
    }

    @Test
    func prefixedElectronVoltsShareDimensionWithBaseElectronVolt() {
        requireSameDimension(ElectronVolt.self, Kiloelectronvolt.self)
        requireSameDimension(ElectronVolt.self, Megaelectronvolt.self)
        requireSameDimension(ElectronVolt.self, Gigaelectronvolt.self)
        requireSameDimension(ElectronVolt.self, Millielectronvolt.self)
    }

    @Test
    func prefixedElectronVoltsRoundTripAgainstBaseElectronVolt() throws {
        let energy = try Quantity<Double, Kiloelectronvolt, Linear>(2.5)
        let inEV = energy.converted(to: ElectronVolt.self)
        let backToKeV = inEV.converted(to: Kiloelectronvolt.self)

        let small = try Quantity<Double, Millielectronvolt, Linear>(500)
        let inEVFromMeV = small.converted(to: ElectronVolt.self)

        #expect(abs(inEV.value - 2_500) < 0.000_000_1)
        #expect(abs(backToKeV.value - 2.5) < 0.000_000_1)
        #expect(abs(inEVFromMeV.value - 0.5) < 0.000_000_1)
    }

    @Test
    func integerPrefixedElectronVoltConversionsRejectFractionalResults() throws {
        // Large numerator causes integer overflow before divisibility can be checked
        #expect(throws: QuantityError.arithmeticOverflow) {
            try Quantity<Int, Kiloelectronvolt, Linear>(exactly: 1)
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            try Quantity<Int, ElectronVolt, Linear>(exactly: 1)
        }
    }

    @Test
    func electronVoltIsPrefixableAndDirectlyInitializable() {
        requirePrefixable(ElectronVolt.self)
        requireDirectlyInitializable(ElectronVolt.self)
    }
}

// MARK: - Prefixed Dalton

struct PrefixedDaltonTests {
    @Test
    func representativePrefixedDaltonsExposeCorrectSymbols() {
        #expect(Kilodalton.symbol == "kDa")
        #expect(Megadalton.symbol == "MDa")
        #expect(Gigadalton.symbol == "GDa")
        #expect(Millidalton.symbol == "mDa")
        #expect(Microdalton.symbol == "μDa")
    }

    @Test
    func prefixedDaltonsExposeExpectedScaleMetadata() throws {
        // Dalton base scale is (16_605_390_666, 1, -37)
        // Kilo adds decimalExponent: 3 → combined: (16_605_390_666, 1, -34)
        // Mega adds decimalExponent: 6 → combined: (16_605_390_666, 1, -31)
        // Milli adds decimalExponent: -3 → combined: (16_605_390_666, 1, -40)
        let kilo = try UnitScale(numerator: 16_605_390_666, denominator: 1, decimalExponent: -34)
        let mega = try UnitScale(numerator: 16_605_390_666, denominator: 1, decimalExponent: -31)
        let milli = try UnitScale(numerator: 16_605_390_666, denominator: 1, decimalExponent: -40)

        #expect(Kilodalton.scale == kilo)
        #expect(Megadalton.scale == mega)
        #expect(Millidalton.scale == milli)
    }

    @Test
    func prefixedDaltonsShareDimensionWithBaseDalton() {
        requireSameDimension(Dalton.self, Kilodalton.self)
        requireSameDimension(Dalton.self, Megadalton.self)
        requireSameDimension(Dalton.self, Gigadalton.self)
        requireSameDimension(Dalton.self, Millidalton.self)
    }

    @Test
    func prefixedDaltonsRoundTripAgainstBaseDalton() throws {
        let mass = try Quantity<Double, Kilodalton, Linear>(2.5)
        let inDaltons = mass.converted(to: Dalton.self)
        let backToKDa = inDaltons.converted(to: Kilodalton.self)

        let small = try Quantity<Double, Millidalton, Linear>(500)
        let inDaltonsFromMDa = small.converted(to: Dalton.self)

        #expect(abs(inDaltons.value - 2_500) < 0.000_000_1)
        #expect(abs(backToKDa.value - 2.5) < 0.000_000_1)
        #expect(abs(inDaltonsFromMDa.value - 0.5) < 0.000_000_1)
    }

    @Test
    func integerPrefixedDaltonConversionsRejectFractionalResults() throws {
        // Large numerator causes integer overflow before divisibility can be checked
        #expect(throws: QuantityError.arithmeticOverflow) {
            try Quantity<Int, Kilodalton, Linear>(exactly: 1)
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            try Quantity<Int, Dalton, Linear>(exactly: 1)
        }
    }

    @Test
    func daltonIsPrefixableAndDirectlyInitializable() {
        requirePrefixable(Dalton.self)
        requireDirectlyInitializable(Dalton.self)
    }
}

// MARK: - Prefixed Bel

struct PrefixedBelTests {
    @Test
    func representativePrefixedBelsExposeCorrectSymbols() {
        #expect(Decibel.symbol == "dB")
        #expect(Millibel.symbol == "mB")
        #expect(Centibel.symbol == "cB")
        #expect(Kilobel.symbol == "kB")
        #expect(Megabel.symbol == "MB")
    }

    @Test
    func prefixedBelsExposeExpectedScaleMetadata() throws {
        // Bel base scale is (1_151_292_546_497_023, 1, -15)
        // Deci adds decimalExponent: -1 → combined: -16
        // Milli adds decimalExponent: -3 → combined: -18
        // Kilo adds decimalExponent: 3 → combined: -12
        let deci = try UnitScale(numerator: 1_151_292_546_497_023, denominator: 1, decimalExponent: -16)
        let milli = try UnitScale(numerator: 1_151_292_546_497_023, denominator: 1, decimalExponent: -18)
        let kilo = try UnitScale(numerator: 1_151_292_546_497_023, denominator: 1, decimalExponent: -12)

        #expect(Decibel.scale == deci)
        #expect(Millibel.scale == milli)
        #expect(Kilobel.scale == kilo)
    }

    @Test
    func prefixedBelsShareDimensionWithBaseBel() {
        requireSameDimension(Bel.self, Decibel.self)
        requireSameDimension(Bel.self, Millibel.self)
        requireSameDimension(Bel.self, Kilobel.self)
        requireSameDimension(Bel.self, Centibel.self)
    }

    @Test
    func prefixedBelsRoundTripAgainstBaseBel() throws {
        let level = try Quantity<Double, Decibel, Linear>(10)
        let inBels = level.converted(to: Bel.self)
        let backToDecibels = inBels.converted(to: Decibel.self)

        let small = try Quantity<Double, Millibel, Linear>(1_000)
        let inBelsFromMB = small.converted(to: Bel.self)

        #expect(abs(inBels.value - 1) < 0.000_000_1)
        #expect(abs(backToDecibels.value - 10) < 0.000_000_1)
        #expect(abs(inBelsFromMB.value - 1) < 0.000_000_1)
    }

    @Test
    func prefixedBelsRoundTripAcrossNepers() throws {
        // 10 dB = 1 B = ln(10)/2 Np ≈ 1.1513 Np
        let tenDecibels = try Quantity<Double, Decibel, Linear>(10)
        let inNepers = tenDecibels.converted(to: Neper.self)
        let backToDecibels = inNepers.converted(to: Decibel.self)

        #expect(abs(inNepers.value - 1.151_292_546_497_023) < 1e-10)
        #expect(abs(backToDecibels.value - 10) < 1e-10)
    }

    @Test
    func integerPrefixedBelConversionsRejectFractionalResults() throws {
        #expect(throws: QuantityError.nonIntegralConversion) {
            try Quantity<Int, Decibel, Linear>(exactly: 1)
        }

        #expect(throws: QuantityError.nonIntegralConversion) {
            try Quantity<Int, Millibel, Linear>(exactly: 1)
        }
    }

    @Test
    func belIsPrefixableAndDirectlyInitializable() {
        requirePrefixable(Bel.self)
        requireDirectlyInitializable(Bel.self)
    }
}
