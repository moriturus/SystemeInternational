import Testing

@testable import UnitesDeBaseDuSI

struct SupportTests {
    @Test
    func unitMetadataCoversAllSupportedBaseUnits() throws {
        #expect(Meter.symbol == "m")
        #expect(Kilogram.symbol == "kg")
        #expect(Second.symbol == "s")
        #expect(Ampere.symbol == "A")
        #expect(Kelvin.symbol == "K")
        #expect(Mole.symbol == "mol")
        #expect(Candela.symbol == "cd")
        #expect(CanonicalUnit<Dimensionless>.symbol == "")
        #expect(CanonicalUnit<Dimensionless>.scale == .identity)
    }

    @Test
    func quantityCanStillBeCreatedFromCanonicalBaseValuesDirectly() throws {
        let storageReading = Quantity<Double, Meter, Linear>(baseValue: 42)
        let canonicalReading = Quantity<Double, CanonicalUnit<Dimensionless>, Linear>(baseValue: 1)

        #expect(storageReading.baseValue == 42)
        #expect(storageReading.value == 42)
        #expect(canonicalReading.baseValue == 1)
    }

    @Test
    func identityScalePreservesFloatingPointValues() throws {
        let value = UnitScale.identity.apply(to: 12.5 as Double)
        let extracted = UnitScale.identity.extract(from: value)

        #expect(value == 12.5)
        #expect(extracted == 12.5)
    }

    @Test
    func scaleRoundTripPreservesFloatingPointMeaning() throws {
        let scale = try UnitScale(numerator: 1_000, denominator: 1)
        let baseValue = scale.apply(to: 2.75 as Double)
        let restored = scale.extract(from: baseValue)

        #expect(baseValue == 2_750)
        #expect(restored == 2.75)
    }

    @Test
    func exactScaleRoundTripPreservesWholeIntegerValues() throws {
        let scale = try UnitScale(numerator: 3_600, denominator: 1)
        let baseValue = try scale.applyExactly(to: 2 as Int)
        let restored = try scale.extractExactly(from: baseValue)

        #expect(baseValue == 7_200)
        #expect(restored == 2)
    }

    @Test
    func exactScaleApplicationFailsForFractionalBaseValue() throws {
        let scale = try UnitScale(numerator: 1, denominator: 2)

        #expect(throws: QuantityError.nonIntegralConversion) {
            _ = try scale.applyExactly(to: 1 as Int)
        }
    }

    @Test
    func exactScaleExtractionFailsForFractionalDisplayedValue() throws {
        let scale = try UnitScale(numerator: 2, denominator: 1)

        #expect(throws: QuantityError.nonIntegralConversion) {
            _ = try scale.extractExactly(from: 1 as Int)
        }
    }

    @Test
    func exactScaleReportsOverflowWhenScaleComponentsDoNotFitDestinationIntegerType() throws {
        let oversizedNumerator = try UnitScale(numerator: 129, denominator: 1)
        let oversizedDenominator = try UnitScale(numerator: 1, denominator: 129)

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try oversizedNumerator.applyExactly(to: 1 as Int8)
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try oversizedNumerator.extractExactly(from: 1 as Int8)
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try oversizedDenominator.applyExactly(to: 1 as Int8)
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try oversizedDenominator.extractExactly(from: 1 as Int8)
        }
    }

    @Test
    func zeroValueIsStableAcrossScaleApplicationAndExtraction() throws {
        let scale = try UnitScale(numerator: 3_600, denominator: 1)

        #expect(scale.apply(to: 0 as Double) == 0)
        #expect(scale.extract(from: 0 as Double) == 0)
        #expect(try scale.applyExactly(to: 0 as Int) == 0)
        #expect(try scale.extractExactly(from: 0 as Int) == 0)
    }

    @Test
    func decimalExponentScalePreservesFloatingPointMeaning() throws {
        let scale = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 3)
        let baseValue = scale.apply(to: 2.75 as Double)
        let restored = scale.extract(from: baseValue)

        #expect(baseValue == 2_750)
        #expect(restored == 2.75)
    }

    @Test
    func scaleEqualityReflectsNormalizedMeaning() throws {
        let normalized = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 3)
        let equivalentViaConstructor = try UnitScale(numerator: 1_000, denominator: 1, decimalExponent: 0)

        #expect(normalized == equivalentViaConstructor)
    }

    @Test
    func scaleNormalizationPreservesSignAndFactorsOfTenInDenominator() throws {
        let scale = try UnitScale(numerator: 1, denominator: -20)

        #expect(scale.numerator == -1)
        #expect(scale.denominator == 2)
        #expect(scale.decimalExponent == -1)
    }

    @Test
    func exactDecimalExponentScaleReportsOverflow() throws {
        let scale = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 30)

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try scale.applyExactly(to: 1 as Int)
        }
    }

    @Test
    func invalidScaleInputsFailWithoutTrapping() throws {
        #expect(throws: UnitScaleError.invalidScale) {
            _ = try UnitScale(numerator: 0, denominator: 1)
        }

        #expect(throws: UnitScaleError.invalidScale) {
            _ = try UnitScale(numerator: 1, denominator: 0)
        }

        #expect(throws: UnitScaleError.invalidScale) {
            _ = try UnitScale(numerator: Int.min, denominator: -1)
        }

        #expect(throws: UnitScaleError.invalidScale) {
            _ = try UnitScale(numerator: 1, denominator: Int.min)
        }
    }

    @Test
    func exponentNormalizationReportsOverflowAsTypedFailure() throws {
        #expect(throws: UnitScaleError.arithmeticOverflow) {
            _ = try UnitScale(numerator: 10, denominator: 1, decimalExponent: Int.max)
        }

        #expect(throws: UnitScaleError.arithmeticOverflow) {
            _ = try UnitScale(numerator: 1, denominator: 10, decimalExponent: Int.min)
        }
    }

    @Test
    func combinedScaleReportsOverflowAsTypedFailure() throws {
        let lhs = try UnitScale(numerator: Int.max, denominator: 1)
        let rhs = try UnitScale(numerator: 2, denominator: 1)

        #expect(throws: UnitScaleError.arithmeticOverflow) {
            _ = try lhs.combined(with: rhs)
        }
    }

    @Test
    func uncheckedCombinedMatchesCheckedCombinationForRepresentableScales() throws {
        let lhs = try UnitScale(numerator: 4, denominator: 5, decimalExponent: 2)
        let rhs = try UnitScale(numerator: 15, denominator: 8, decimalExponent: -1)

        #expect(lhs.uncheckedCombined(with: rhs) == (try lhs.combined(with: rhs)))
    }

    @Test
    func largeExponentScaleCompletesWithoutLinearIteration() throws {
        let scale = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 1_024)
        let scaled = scale.apply(to: 1 as Double)

        #expect(scaled.isInfinite)
    }

    @Test
    func integerQuantityArithmeticReportsTypedFailures() throws {
        let oneMeter = try Quantity<Int, Meter, Linear>(exactly: 1)
        let twoSeconds = try Quantity<Int, Second, Linear>(exactly: 2)
        let zeroSeconds = try Quantity<Int, Second, Linear>(exactly: 0)
        let fourMeters = try Quantity<Int, Meter, Linear>(exactly: 4)
        let maxMeters = try Quantity<Int, Meter, Linear>(exactly: .max)

        let exactRate = try fourMeters / twoSeconds

        #expect(exactRate.baseValue == 2)

        #expect(throws: QuantityError.nonIntegralConversion) {
            _ = try oneMeter / twoSeconds
        }

        #expect(throws: QuantityError.divisionByZero) {
            _ = try oneMeter / zeroSeconds
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try maxMeters + oneMeter
        }
    }

    @Test
    func integerQuantityArithmeticCoversRemainingOverflowBranches() throws {
        let oneMeter = try Quantity<Int, Meter, Linear>(exactly: 1)
        let minMeters = try Quantity<Int, Meter, Linear>(exactly: .min)
        let maxMeters = try Quantity<Int, Meter, Linear>(exactly: .max)
        let oneSecond = try Quantity<Int, Second, Linear>(exactly: 1)
        let twoSeconds = try Quantity<Int, Second, Linear>(exactly: 2)
        let negativeOneSecond = try Quantity<Int, Second, Linear>(exactly: -1)

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try minMeters - oneMeter
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try maxMeters * twoSeconds
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try minMeters / negativeOneSecond
        }

        let groupedRate = try Quantity<Int, Meter, Linear>(exactly: 8) / (try twoSeconds * twoSeconds)
        let intermediateRate = try Quantity<Int, Meter, Linear>(exactly: 8) / twoSeconds
        let repeatedRate = try intermediateRate / twoSeconds

        #expect(groupedRate.baseValue == repeatedRate.baseValue)

        #expect(throws: QuantityError.divisionByZero) {
            _ = try oneMeter / (try Quantity<Int, Second, Linear>(exactly: 0) * oneSecond)
        }

        #expect(throws: QuantityError.nonIntegralConversion) {
            _ = try oneMeter / (try twoSeconds * oneSecond)
        }

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try minMeters / (try negativeOneSecond * oneSecond)
        }
    }
}
