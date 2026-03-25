import Testing
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI

struct TemperatureSampleTests {
    @Test
    func fermentationRoomSetpointConvertsFromCelsiusToKelvin() throws {
        let roomSetpoint = try CelsiusTemperatureValue(24)
        let roomSetpointInKelvin = roomSetpoint.converted(to: Kelvin.self)

        #expect(abs(roomSetpointInKelvin.value - 297.15) < 0.000_000_1)
    }

    @Test
    func cryogenicStorageSetpointCanBeComparedInKelvin() throws {
        let transferStorage = try KelvinTemperatureValue(77)
        let warmupThreshold = try KelvinTemperatureValue(90)

        #expect(transferStorage < warmupThreshold)
        #expect(abs(transferStorage.converted(to: DegreeCelsius.self).value + 196.15) < 0.000_000_1)
    }

    @Test
    func brewingMashRiseIsReadableAsCelsiusInterval() throws {
        let doughIn = try CelsiusTemperatureValue(52)
        let saccharificationRest = try CelsiusTemperatureValue(67)
        let temperatureRise = try saccharificationRest - doughIn

        #expect(abs(temperatureRise.converted(to: DegreeCelsius.self).value - 15) < 0.000_000_1)
    }

    @Test
    func hvacCorrectionUsesKelvinTemperatureDifferenceWithoutOffset() throws {
        let ductRise = try KelvinTemperatureDifference(4)
        let supplyAir = try CelsiusTemperatureValue(18)
        let adjustedSupplyAir = try supplyAir + ductRise.converted(to: DegreeCelsius.self)

        #expect(abs(adjustedSupplyAir.value - 22) < 0.000_000_1)
    }

    @Test
    func coolingAdjustmentCanBeAppliedAsNegativeCelsiusInterval() throws {
        let fermenter = try CelsiusTemperatureValue(20)
        let adjustment = try CelsiusTemperatureDifference(-2.5)
        let correctedSetpoint = try fermenter + adjustment

        #expect(abs(correctedSetpoint.value - 17.5) < 0.000_000_1)
    }

    @Test
    func absoluteZeroBoundaryRejectsInvalidValues() throws {
        let absoluteZero = try CelsiusTemperatureValue(-273.15)

        #expect(absoluteZero.converted(to: Kelvin.self).value == 0)

        #expect(throws: QuantityError.belowAbsoluteZero) {
            _ = try KelvinTemperatureValue(-0.001)
        }
    }
}
