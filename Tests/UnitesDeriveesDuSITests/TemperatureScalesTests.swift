import Testing

@testable import UnitesDeBaseDuSI
@testable import UnitesDeriveesDuSI

private enum BoundedTestDimension: AbsoluteLowerBoundDimensionProtocol {
    static let absoluteMinimumBaseValue = 10.0
}

private enum BoundedAffineUnit: DirectlyInitializableUnitProtocol {
    static let symbol = "bat"
    static let scale = UnitScale.identity
    typealias Dimension = BoundedTestDimension
}

struct TemperatureScalesTests {
    @Test
    func celsiusTemperatureUsesDegreeCelsiusAndAffineTemperatureModel() throws {
        #expect(DegreeCelsius.symbol == "°C")
        #expect(Kelvin.symbol == "K")
    }

    @Test
    func realWorldAbsoluteTemperaturesConvertBetweenCelsiusAndKelvin() throws {
        let freezingPoint = try CelsiusTemperatureValue(0)
        let roomTemperature = try CelsiusTemperatureValue(25)
        let boilingPoint = try CelsiusTemperatureValue(100)
        let freezingPointInKelvin = freezingPoint.converted(to: Kelvin.self)
        let roomTemperatureInKelvin = roomTemperature.converted(to: Kelvin.self)
        let boilingPointInKelvin = boilingPoint.converted(to: Kelvin.self)

        #expect(abs(freezingPointInKelvin.value - 273.15) < 0.000_000_1)
        #expect(abs(roomTemperatureInKelvin.value - 298.15) < 0.000_000_1)
        #expect(abs(boilingPointInKelvin.value - 373.15) < 0.000_000_1)
    }

    @Test
    func temperatureIntervalsConvertWithoutOffset() throws {
        let oneDegree = try CelsiusTemperatureDifference(1)
        let tenDegrees = try CelsiusTemperatureDifference(10)
        let cooling = try CelsiusTemperatureDifference(-5)

        #expect(oneDegree.converted(to: Kelvin.self).value == 1)
        #expect(tenDegrees.converted(to: Kelvin.self).value == 10)
        #expect(cooling.converted(to: Kelvin.self).value == -5)
    }

    @Test
    func absoluteTemperaturesSubtractToIntervalsAndIntervalsShiftTemperatures() throws {
        let roomTemperature = try CelsiusTemperatureValue(21)
        let operatingTemperature = try CelsiusTemperatureValue(68)
        let rise = try operatingTemperature - roomTemperature
        let cooldown = try CelsiusTemperatureDifference(-8)
        let reducedOperatingTemperature = try operatingTemperature + cooldown

        #expect(abs(rise.converted(to: DegreeCelsius.self).value - 47) < 0.000_000_1)
        #expect(abs(reducedOperatingTemperature.value - 60) < 0.000_000_1)
        #expect(reducedOperatingTemperature < operatingTemperature)
    }

    @Test
    func absoluteZeroIsAcceptedAndBelowAbsoluteZeroIsRejected() throws {
        let absoluteZero = try CelsiusTemperatureValue(-273.15)

        #expect(absoluteZero.converted(to: Kelvin.self).value == 0)

        #expect(throws: QuantityError.belowAbsoluteZero) {
            _ = try CelsiusTemperatureValue(-273.150_000_1)
        }

        #expect(throws: QuantityError.belowAbsoluteZero) {
            _ = try KelvinTemperatureValue(-0.000_001)
        }
    }

    @Test
    func temperatureRoundTripsRemainStableNearOffsetBoundary() throws {
        let labSetpoint = try CelsiusTemperatureValue(0.01)
        let converted = labSetpoint.converted(to: Kelvin.self)
        let roundTripped = converted.converted(to: DegreeCelsius.self)

        #expect(abs(converted.value - 273.16) < 0.000_000_1)
        #expect(abs(roundTripped.value - 0.01) < 0.000_000_1)
    }

    @Test
    func temperatureInitializersRejectNonFiniteValues() throws {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try CelsiusTemperatureValue(.infinity)
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try CelsiusTemperatureDifference(.nan)
        }
    }

    @Test
    func intervalComparisonAndArithmeticRemainAvailable() throws {
        let rise = try CelsiusTemperatureDifference(12)
        let cooldown = try CelsiusTemperatureDifference(-3)
        let offset = try KelvinTemperatureDifference(2)

        #expect(cooldown < rise)
        #expect((try rise + cooldown).value == 9)
        #expect((try rise - offset.converted(to: DegreeCelsius.self)).value == 10)
    }

    @Test
    func subtractingAnIntervalLowersAnAbsoluteTemperature() throws {
        let setpoint = try KelvinTemperatureValue(295)
        let correction = try CelsiusTemperatureDifference(5)
        let reduced = try setpoint - correction.converted(to: Kelvin.self)

        #expect(reduced.value == 290)
    }

    @Test
    func absoluteTemperatureArithmeticRejectsBelowAbsoluteZeroAndNonFiniteResults() throws {
        let absoluteZero = try KelvinTemperatureValue(0)
        let enormousTemperature = try KelvinTemperatureValue(.greatestFiniteMagnitude)
        let oneKelvin = try KelvinTemperatureDifference(1)
        let huge = try KelvinTemperatureDifference(.greatestFiniteMagnitude)

        #expect(throws: QuantityError.belowAbsoluteZero) {
            _ = try absoluteZero - oneKelvin
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try enormousTemperature + huge
        }
    }

    @Test
    func intervalArithmeticRejectsNonFiniteResults() throws {
        let huge = try KelvinTemperatureDifference(.greatestFiniteMagnitude)
        let negativeHuge = try KelvinTemperatureDifference(-Double.greatestFiniteMagnitude)

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try huge + huge
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try huge - negativeHuge
        }
    }

    @Test
    func affineDimensionsWithAbsoluteLowerBoundsRejectValuesBelowTheirMinimum() throws {
        #expect(throws: QuantityError.belowAbsoluteZero) {
            _ = try Quantity<Double, BoundedAffineUnit, Affine>(9)
        }

        let valid = try Quantity<Double, BoundedAffineUnit, Affine>(12)

        #expect(valid.value == 12)
    }

    @Test
    func affineArithmeticUsesDimensionLowerBoundProtocolInsteadOfTemperatureSpecialCases() throws {
        let baseline = try Quantity<Double, BoundedAffineUnit, Affine>(12)
        let upward = try Quantity<Double, BoundedAffineUnit, Linear>(3)
        let safeDownward = try Quantity<Double, BoundedAffineUnit, Linear>(2)
        let downward = try Quantity<Double, BoundedAffineUnit, Linear>(5)

        #expect((try baseline + upward).value == 15)
        #expect((try baseline - safeDownward).value == 10)
        #expect(throws: QuantityError.belowAbsoluteZero) {
            _ = try baseline - downward
        }
    }

    @Test
    func unboundedAffineDimensionAcceptsAnyValue() throws {
        // Dimensions without AbsoluteLowerBoundDimensionProtocol conformance should
        // accept any finite value, including negative values, via the default
        // DimensionProtocol.validateAffineBaseValue passthrough.
        let negative = try Quantity<Double, Meter, Affine>(-100)
        let zero = try Quantity<Double, Meter, Affine>(0)
        let positive = try Quantity<Double, Meter, Affine>(42)

        #expect(negative.value == -100)
        #expect(zero.value == 0)
        #expect(positive.value == 42)

        // Arithmetic on unbounded affine quantities should not reject negative results.
        let drop = try Quantity<Double, Meter, Linear>(200)
        let result = try negative - drop

        #expect(result.value == -300)
    }
}
