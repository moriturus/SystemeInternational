import Testing

@testable import UnitesSI

private func requireSameDimension<Left: UnitProtocol, Right: UnitProtocol>(
    _: Left.Type,
    _: Right.Type
) where Left.Dimension == Right.Dimension {}

private enum OverflowScaleLengthUnit: UnitProtocol {
    static let symbol = "overflow-length"
    static let scale = UnitScale(uncheckedNumerator: 1, denominator: 1, decimalExponent: Int.max)

    typealias Dimension = LengthDimension
}

private func requirePrefixable<Unit: SIPrefixableUnitProtocol>(_: Unit.Type) {}
private func requireDirectlyInitializable<Unit: DirectlyInitializableUnitProtocol>(_: Unit.Type) {}

struct SIPrefixedUnitsTests {
    @Test
    func facadeReexportsRepresentativePrefixedUnitsAcrossAllFamilies() throws {
        #expect(Kilometer.symbol == "km")
        #expect(Kilosecond.symbol == "ks")
        #expect(Microampere.symbol == "μA")
        #expect(Kilokelvin.symbol == "kK")
        #expect(Nanomole.symbol == "nmol")
        #expect(Megacandela.symbol == "Mcd")
        #expect(Gram.symbol == "g")
        #expect(Milligram.symbol == "mg")

        #expect(Kilonewton.symbol == "kN")
        #expect(Kilopascal.symbol == "kPa")
        #expect(Megajoule.symbol == "MJ")
        #expect(Megawatt.symbol == "MW")
        #expect(Picocoulomb.symbol == "pC")
        #expect(Millivolt.symbol == "mV")
        #expect(Microfarad.symbol == "μF")
        #expect(Milliohm.symbol == "mΩ")
        #expect(Millisiemens.symbol == "mS")
        #expect(Microweber.symbol == "μWb")
        #expect(Millitesla.symbol == "mT")
        #expect(Microhenry.symbol == "μH")
        #expect(Kilolumen.symbol == "klm")
        #expect(Kilolux.symbol == "klx")
        #expect(Microkatal.symbol == "μkat")

        requireSameDimension(Milligram.self, Kilogram.self)
        requireSameDimension(Millitesla.self, Tesla.self)
    }

    @Test
    func prefixedUnitsExposeExpectedScaleMetadata() throws {
        let kilo = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 3)
        let micro = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -6)
        let nano = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -9)
        let mega = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 6)
        let gram = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -3)

        #expect(Kilometer.scale == kilo)
        #expect(Kilosecond.scale == kilo)
        #expect(Microampere.scale == micro)
        #expect(Kilokelvin.scale == kilo)
        #expect(Nanomole.scale == nano)
        #expect(Megacandela.scale == mega)

        #expect(Gram.scale == gram)
        #expect(Milligram.scale == micro)
        #expect(Megagram.scale == kilo)

        #expect(Kilopascal.scale == kilo)
        #expect(Microfarad.scale == micro)
    }

    @Test
    func prefixedUnitsRoundTripAgainstCanonicalUnits() throws {
        let distance = try Quantity<Double, Kilometer, Linear>(2.4)
        let inMeters = distance.converted(to: Meter.self)
        let backToKilometers = inMeters.converted(to: Kilometer.self)

        let pulseWidth = try Quantity<Double, Millisecond, Linear>(250)
        let inSeconds = pulseWidth.converted(to: Second.self)

        let current = try Quantity<Double, Microampere, Linear>(120)
        let inAmperes = current.converted(to: Ampere.self)

        let amount = try Quantity<Double, Nanomole, Linear>(2.5)
        let inMoles = amount.converted(to: Mole.self)

        let brightness = try Quantity<Double, Megacandela, Linear>(1.2)
        let inCandelas = brightness.converted(to: Candela.self)

        let pressure = try Quantity<Double, Kilopascal, Linear>(101.3)
        let inPascals = pressure.converted(to: Pascal.self)

        let capacitance = try Quantity<Double, Microfarad, Linear>(47)
        let inFarads = capacitance.converted(to: Farad.self)

        #expect(inMeters.value == 2_400)
        #expect(abs(backToKilometers.value - 2.4) < 0.000_000_1)
        #expect(abs(inSeconds.value - 0.25) < 0.000_000_1)
        #expect(abs(inAmperes.value - 0.000_12) < 0.000_000_1)
        #expect(abs(inMoles.value - 0.000_000_002_5) < 0.000_000_000_000_1)
        #expect(abs(inCandelas.value - 1_200_000) < 0.000_000_1)
        #expect(abs(inPascals.value - 101_300) < 0.000_000_1)
        #expect(abs(inFarads.value - 0.000_047) < 0.000_000_000_1)
    }

    @Test
    func gramFamilyRoundsTripAgainstKilogram() throws {
        let sample = try Quantity<Double, Milligram, Linear>(3_200_000)
        let inKilograms = sample.converted(to: Kilogram.self)
        let inGrams = inKilograms.converted(to: Gram.self)
        let cargo = try Quantity<Double, Megagram, Linear>(1.5)

        #expect(abs(inKilograms.value - 3.2) < 0.000_000_1)
        #expect(abs(inGrams.value - 3_200) < 0.000_000_1)
        #expect(abs(cargo.converted(to: Kilogram.self).value - 1_500) < 0.000_000_1)
    }

    @Test
    func prefixedUnitAndGramMarkersRemainAvailableAsTypeMarkers() throws {
        requireSameDimension(Kilometer.self, Meter.self)
        requireSameDimension(Gram.self, Kilogram.self)
    }

    @Test
    func integerPrefixedConversionsPreserveExactnessWhenRepresentable() throws {
        let oneThousandMeters = try Quantity<Int, Meter, Linear>(exactly: 1_000)
        let oneKilometer = try oneThousandMeters.convertedIfExactly(to: Kilometer.self)

        let oneSecond = try Quantity<Int, Second, Linear>(exactly: 1)
        let oneThousandMilliseconds = try oneSecond.convertedIfExactly(to: Millisecond.self)

        let oneKilogram = try Quantity<Int, Kilogram, Linear>(exactly: 1)
        let oneMillionMilligrams = try oneKilogram.convertedIfExactly(to: Milligram.self)

        #expect(oneKilometer.exactValue == 1)
        #expect(oneThousandMilliseconds.exactValue == 1_000)
        #expect(oneMillionMilligrams.exactValue == 1_000_000)
    }

    @Test
    func integerPrefixedConversionsFailWhenExactRepresentationDoesNotExist() throws {
        let oneMeter = try Quantity<Int, Meter, Linear>(exactly: 1)
        let oneKilogram = try Quantity<Int, Kilogram, Linear>(exactly: 1)

        #expect(throws: QuantityError.nonIntegralConversion) {
            try oneMeter.convertedIfExactly(to: Kilometer.self)
        }

        #expect(throws: QuantityError.nonIntegralConversion) {
            try oneKilogram.convertedIfExactly(to: Megagram.self)
        }

        #expect(Quantity<Int, Kilometer, Linear>(baseValue: 1).exactValue == nil)
    }

    @Test
    func veryLargeIntegerPrefixedQuantitiesReportOverflow() throws {
        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try Quantity<Int, Quettameter, Linear>(exactly: 1)
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try Quantity<Int, Quettagram, Linear>(exactly: 1)
        }
    }

    @Test
    func prefixedScaleOverflowReportsTypedFailureBeforeInvariantTrap() throws {
        #expect(throws: UnitScaleError.arithmeticOverflow) {
            _ = try checkedCombinedScale(for: OverflowScaleLengthUnit.self, prefix: Kilo.self)
        }
    }

    @Test
    func prefixEligibilityExcludesNonSIAndAffineTypes() throws {
        requirePrefixable(Meter.self)
        requirePrefixable(Pascal.self)
        requirePrefixable(Gram.self)
        requirePrefixable(Hertz.self)
        requirePrefixable(Becquerel.self)
        requirePrefixable(Gray.self)
        requirePrefixable(Sievert.self)

        #expect((Kilogram.self is any SIPrefixableUnitProtocol.Type) == false)
        #expect((Radian.self is any SIPrefixableUnitProtocol.Type) == false)
        #expect((Steradian.self is any SIPrefixableUnitProtocol.Type) == false)
    }

    @Test
    func semanticUnitsRemainNonPrefixableWhileAllowingDirectInitialization() throws {
        requireDirectlyInitializable(Meter.self)
        requireDirectlyInitializable(Pascal.self)
        requireDirectlyInitializable(Hertz.self)
        requireDirectlyInitializable(Becquerel.self)
        requireDirectlyInitializable(Gray.self)
        requireDirectlyInitializable(Sievert.self)
        requireDirectlyInitializable(Radian.self)
        requireDirectlyInitializable(Steradian.self)
    }

    @Test
    func facadeReexportsAffineTemperatureModelForRealWorldTemperatures() throws {
        let freezer = try CelsiusTemperatureValue(-18)
        let room = try CelsiusTemperatureValue(22)
        let rise = try room - freezer

        #expect(abs(freezer.converted(to: Kelvin.self).value - 255.15) < 0.000_000_1)
        #expect(abs(rise.converted(to: DegreeCelsius.self).value - 40) < 0.000_000_1)
    }
}
