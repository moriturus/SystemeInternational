import Testing

@testable import UnitesDeBaseDuSI
@testable import UnitesDeriveesDuSI

struct DerivedUnitsIntegerAndTemperatureExtensionTests {

    // MARK: - Angular frequency remains canonical

    @Test
    func floatingPointRadianDividedBySecondProducesCanonicalAngularFrequency() throws {
        let angle = try Quantity<Double, Radian, Linear>(1)
        let time = try Quantity<Double, Second, Linear>(0.02)
        let angularFrequency:
            Quantity<Double, CanonicalUnit<QuotientDimension<PlaneAngleDimension, TimeDimension>>, Linear> =
                try angle / time

        #expect(abs(angularFrequency.value - 50) < 0.000_000_1)
    }

    @Test
    func integerRadianDividedBySecondProducesCanonicalAngularFrequency() throws {
        let angle = try Quantity<Int, Radian, Linear>(exactly: 10)
        let time = try Quantity<Int, Second, Linear>(exactly: 2)
        let angularFrequency:
            Quantity<Int, CanonicalUnit<QuotientDimension<PlaneAngleDimension, TimeDimension>>, Linear> =
                try angle / time

        #expect(angularFrequency.exactValue == 5)
    }

    // MARK: - Floating semantic operator: Candela * Steradian → Lumen

    @Test
    func floatingPointCandelaTimesSteradianThrowsNonFiniteInput() throws {
        let intensity = try Quantity<Double, Candela, Linear>(.greatestFiniteMagnitude)
        let solidAngle = try Quantity<Double, Steradian, Linear>(2)

        #expect(throws: QuantityError.nonFiniteValue) {
            let _: Quantity<Double, Lumen, Linear> = try intensity * solidAngle
        }
    }

    @Test
    func floatingPointSteradianTimesCandelaThrowsNonFiniteInput() throws {
        let solidAngle = try Quantity<Double, Steradian, Linear>(2)
        let intensity = try Quantity<Double, Candela, Linear>(.greatestFiniteMagnitude)

        #expect(throws: QuantityError.nonFiniteValue) {
            let _: Quantity<Double, Lumen, Linear> = try solidAngle * intensity
        }
    }

    // MARK: - Floating semantic operator: Lumen / Area → Lux

    @Test
    func floatingPointLumenDividedByAreaThrowsDivisionByZero() throws {
        let flux = try Quantity<Double, Lumen, Linear>(100)
        let width = try Quantity<Double, Meter, Linear>(0)
        let height = try Quantity<Double, Meter, Linear>(5)
        let area: Quantity<Double, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear> =
            try width * height

        #expect(throws: QuantityError.divisionByZero) {
            let _: Quantity<Double, Lux, Linear> = try flux / area
        }
    }

    @Test
    func floatingPointLumenDividedByAreaThrowsNonFiniteForExtremeValues() throws {
        let hugeFlux = try Quantity<Double, Lumen, Linear>(.greatestFiniteMagnitude)
        let tinyWidth = try Quantity<Double, Meter, Linear>(Double.leastNonzeroMagnitude)
        let oneHeight = try Quantity<Double, Meter, Linear>(1)
        let tinyArea: Quantity<Double, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear> =
            try tinyWidth * oneHeight

        #expect(throws: QuantityError.nonFiniteValue) {
            let _: Quantity<Double, Lux, Linear> = try hugeFlux / tinyArea
        }
    }

    // MARK: - Integer semantic operator: Candela * Steradian → Lumen

    @Test
    func integerCandelaTimesSteradianProducesLumen() throws {
        let intensity = try Quantity<Int, Candela, Linear>(exactly: 8)
        let solidAngle = try Quantity<Int, Steradian, Linear>(exactly: 3)
        let flux: Quantity<Int, Lumen, Linear> = try intensity * solidAngle

        #expect(flux.exactValue == 24)
    }

    @Test
    func integerSteradianTimesCandelaProducesLumen() throws {
        let solidAngle = try Quantity<Int, Steradian, Linear>(exactly: 3)
        let intensity = try Quantity<Int, Candela, Linear>(exactly: 8)
        let flux: Quantity<Int, Lumen, Linear> = try solidAngle * intensity

        #expect(flux.exactValue == 24)
    }

    @Test
    func integerCandelaTimesSteradianIsCommutative() throws {
        let intensity = try Quantity<Int, Candela, Linear>(exactly: 5)
        let solidAngle = try Quantity<Int, Steradian, Linear>(exactly: 7)
        let forward: Quantity<Int, Lumen, Linear> = try intensity * solidAngle
        let reversed: Quantity<Int, Lumen, Linear> = try solidAngle * intensity

        #expect(forward == reversed)
    }

    @Test
    func integerCandelaTimesSteradianThrowsArithmeticOverflow() throws {
        let intensity = try Quantity<Int, Candela, Linear>(exactly: Int.max)
        let solidAngle = try Quantity<Int, Steradian, Linear>(exactly: 2)

        #expect(throws: QuantityError.arithmeticOverflow) {
            let _: Quantity<Int, Lumen, Linear> = try intensity * solidAngle
        }
    }

    @Test
    func integerSteradianTimesCandelaThrowsArithmeticOverflow() throws {
        let solidAngle = try Quantity<Int, Steradian, Linear>(exactly: Int.max)
        let intensity = try Quantity<Int, Candela, Linear>(exactly: 2)

        #expect(throws: QuantityError.arithmeticOverflow) {
            let _: Quantity<Int, Lumen, Linear> = try solidAngle * intensity
        }
    }

    // MARK: - Integer semantic operator: Lumen / Area → Lux

    @Test
    func integerLumenDividedByAreaProducesLux() throws {
        let flux = try Quantity<Int, Lumen, Linear>(exactly: 100)
        let width = try Quantity<Int, Meter, Linear>(exactly: 5)
        let height = try Quantity<Int, Meter, Linear>(exactly: 2)
        let area: Quantity<Int, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear> =
            try width * height
        let illuminance: Quantity<Int, Lux, Linear> = try flux / area

        #expect(illuminance.exactValue == 10)
    }

    @Test
    func integerLumenDividedByAreaThrowsDivisionByZero() throws {
        let flux = try Quantity<Int, Lumen, Linear>(exactly: 100)
        let width = try Quantity<Int, Meter, Linear>(exactly: 0)
        let height = try Quantity<Int, Meter, Linear>(exactly: 5)
        let area: Quantity<Int, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear> =
            try width * height
        // area base value is 0*5 = 0

        #expect(throws: QuantityError.divisionByZero) {
            let _: Quantity<Int, Lux, Linear> = try flux / area
        }
    }

    @Test
    func integerLumenDividedByAreaThrowsNonIntegralConversion() throws {
        let flux = try Quantity<Int, Lumen, Linear>(exactly: 10)
        let width = try Quantity<Int, Meter, Linear>(exactly: 3)
        let height = try Quantity<Int, Meter, Linear>(exactly: 1)
        let area: Quantity<Int, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear> =
            try width * height

        #expect(throws: QuantityError.nonIntegralConversion) {
            let _: Quantity<Int, Lux, Linear> = try flux / area
        }
    }

    // MARK: - Temperature: commutative interval + absolute

    @Test
    func temperatureIntervalPlusAbsoluteTemperatureIsCommutative() throws {
        let abs = try KelvinTemperatureValue(300.0)
        let interval = try KelvinTemperatureDifference(50.0)
        let result1 = try abs + interval
        let result2 = try interval + abs

        #expect(result1 == result2)
    }

    @Test
    func celsiusIntervalPlusAbsoluteCelsiusTemperature() throws {
        let abs = try CelsiusTemperatureValue(25.0)
        let interval = try CelsiusTemperatureDifference(10.0)
        let result1 = try abs + interval
        let result2 = try interval + abs

        #expect(result1 == result2)
        #expect(Swift.abs(result1.value - 35.0) < 0.000_000_1)
    }

    @Test
    func crossScaleIntervalPlusAbsoluteTemperature() throws {
        let abs = try KelvinTemperatureValue(300.0)
        let interval = try CelsiusTemperatureDifference(10.0)
        let forward = try abs + interval.converted(to: Kelvin.self)
        let commuted = try interval.converted(to: Kelvin.self) + abs

        #expect(forward == commuted)
        #expect(Swift.abs(forward.value - 310.0) < 0.000_000_1)
    }

    @Test
    func intervalPlusAbsoluteRejectsBelowAbsoluteZero() throws {
        let abs = try KelvinTemperatureValue(5.0)
        let interval = try KelvinTemperatureDifference(-10.0)

        #expect(throws: QuantityError.belowAbsoluteZero) {
            _ = try interval + abs
        }
    }

    @Test
    func intervalPlusAbsoluteRejectsNonFiniteResult() throws {
        let abs = try KelvinTemperatureValue(.greatestFiniteMagnitude)
        let interval = try KelvinTemperatureDifference(.greatestFiniteMagnitude)

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try interval + abs
        }
    }

    // MARK: - Temperature: Hashable

    @Test
    func absoluteTemperatureIsHashable() throws {
        let t1 = try KelvinTemperatureValue(300.0)
        let t2 = try KelvinTemperatureValue(300.0)
        let t3 = try KelvinTemperatureValue(400.0)
        let set: Set<KelvinTemperatureValue> = [t1, t2, t3]

        #expect(set.count == 2)
    }

    @Test
    func temperatureIntervalIsHashable() throws {
        let i1 = try KelvinTemperatureDifference(10.0)
        let i2 = try KelvinTemperatureDifference(10.0)
        let i3 = try KelvinTemperatureDifference(20.0)
        let set: Set<KelvinTemperatureDifference> = [i1, i2, i3]

        #expect(set.count == 2)
    }

    @Test
    func absoluteTemperatureEqualHashImpliesSetDeduplication() throws {
        let celsius1 = try CelsiusTemperatureValue(100.0)
        let celsius2 = try CelsiusTemperatureValue(100.0)
        let different = try CelsiusTemperatureValue(0.0)
        let set: Set<CelsiusTemperatureValue> = [celsius1, celsius2, different]

        #expect(set.count == 2)
    }
}
