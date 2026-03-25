import CompatSupport
import Foundation
import Testing
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI
import UtiliseesNonSI

@testable import UtiliseesNonSICompat

private enum UnsupportedTemperatureUnit: DirectlyInitializableUnitProtocol {
    static let symbol = "?T"
    static let scale = UnitScale.identity
    typealias Dimension = TemperatureDimension
}

struct MeasurementCompatibilityTests {
    @Test
    func standardFoundationFamiliesRoundTripThroughAcceptedUnits() throws {
        let minutes = try Quantity<Double, Minute, Linear>(15).foundationMeasurement()
        let hours = try Quantity<Double, Hour, Linear>(1.5).foundationMeasurement()
        let tonnes = try Quantity<Double, Tonne, Linear>(2).foundationMeasurement()
        let hectares = try Quantity<Double, Hectare, Linear>(3).foundationMeasurement()
        let astronomical = try Quantity<Double, AstronomicalUnit, Linear>(1).foundationMeasurement()
        let liters = try Quantity<Double, Liter, Linear>(2.5).foundationMeasurement()

        let fromMinutes = try Measurement(value: 90, unit: UnitDuration.minutes).siQuantity(as: Hour.self)
        let fromHours = try Measurement(value: 36, unit: UnitDuration.hours).siQuantity(as: Day.self)
        let fromTonnes = try Measurement(value: 2, unit: UnitMass.metricTons).siQuantity(as: Kilogram.self)
        let fromHectares = try Measurement(value: 1.2, unit: UnitArea.hectares).siQuantity(as: Hectare.self)
        let fromAstronomical = try Measurement(value: 2, unit: UnitLength.astronomicalUnits)
            .siQuantity(as: AstronomicalUnit.self)
        let fromLiters = try Measurement(value: 750, unit: UnitVolume.milliliters).siQuantity(as: Liter.self)

        #expect(minutes.unit.symbol == "min")
        #expect(hours.unit.symbol == "h")
        #expect(tonnes.unit.symbol == "t")
        #expect(hectares.unit.symbol == "ha")
        #expect(astronomical.unit.symbol == "au")

        #expect(abs(fromMinutes.value - 1.5) < 0.000_000_1)
        #expect(abs(fromHours.value - 1.5) < 0.000_000_1)
        #expect(abs(fromTonnes.value - 2_000) < 0.000_000_1)
        #expect(abs(fromHectares.value - 1.2) < 0.000_000_1)
        #expect(abs(fromAstronomical.value - 2) < 0.000_000_1)

        #expect(liters.unit.symbol == "L")
        #expect(abs(fromLiters.value - 0.75) < 0.000_000_1)
    }

    @Test
    func customFoundationUnitsRoundTripThroughCompatLayer() throws {
        let days = try Quantity<Double, Day, Linear>(2).foundationMeasurement()
        let electronVolts = try Quantity<Double, ElectronVolt, Linear>(5).foundationMeasurement()
        let daltons = try Quantity<Double, Dalton, Linear>(12).foundationMeasurement()

        let fromDays = try Measurement(value: 3, unit: UnitDuration.days).siQuantity(as: Hour.self)
        let fromElectronVolts = try Measurement(value: 2, unit: UnitEnergy.electronVolts).siQuantity(as: Joule.self)
        let fromDaltons = try Measurement(value: 12, unit: UnitMass.daltons).siQuantity(as: Dalton.self)

        #expect(days.unit.symbol == "d")
        #expect(electronVolts.unit.symbol == "eV")
        #expect(daltons.unit.symbol == "Da")
        #expect(abs(fromDays.value - 72) < 0.000_000_1)
        #expect(
            abs(fromElectronVolts.value - 0.000_000_000_000_000_000_320_435_326_8)
                < 0.000_000_000_000_000_000_000_000_001
        )
        #expect(abs(fromDaltons.value - 12) < 0.000_000_000_1)
    }

    @Test
    func temperatureBridgeRemainsAvailableFromAcceptedCompatModule() throws {
        let room = try Measurement(value: 25, unit: UnitTemperature.celsius)
            .absoluteTemperature(as: DegreeCelsius.self)
        let interval = try Measurement(value: 10, unit: UnitTemperature.kelvin)
            .temperatureInterval(as: DegreeCelsius.self)

        #expect(abs(room.converted(to: Kelvin.self).value - 298.15) < 0.000_000_1)
        #expect(abs(interval.value - 10) < 0.000_000_1)
    }

    @Test
    func customTemperatureExpressionsAreRejectedByAcceptedCompatModule() throws {
        let absolute = try Quantity<Double, UnsupportedTemperatureUnit, Affine>(540)

        #expect(throws: CompatibilityError.unsupportedUnit) {
            _ = try absolute.foundationMeasurement()
        }

        let interval = try Quantity<Double, UnsupportedTemperatureUnit, Linear>(18)

        #expect(throws: CompatibilityError.unsupportedUnit) {
            _ = try interval.foundationMeasurementComponents()
        }
    }

    @Test
    func unsupportedFamiliesAndUnitsAreRejected() throws {
        #expect(throws: CompatibilityError.unsupportedMeasurement) {
            _ = try Measurement(value: 1, unit: UnitMass.kilograms).siQuantity(as: Minute.self)
        }
        #expect((CanonicalUnit<Dimensionless>.self is any FoundationBridgeableUnitProtocol.Type) == false)
    }

    @Test
    func erasedFoundationMeasurementsCannotCrossPhysicalFamilies() throws {
        let lengthMeasurement = try Quantity<Double, AstronomicalUnit, Linear>(1).foundationMeasurement()

        #expect(throws: CompatibilityError.unsupportedMeasurement) {
            _ = try lengthMeasurement.siQuantity(as: Tonne.self)
        }
    }

    @Test
    func acceptedCompatRejectsNonFiniteValues() throws {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Minute, Linear>(.infinity).foundationMeasurement()
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Liter, Linear>(.infinity).foundationMeasurement()
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .nan, unit: UnitMass.metricTons).siQuantity(as: Tonne.self)
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .nan, unit: UnitVolume.liters).siQuantity(as: Liter.self)
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: -.infinity, unit: UnitTemperature.celsius)
                .absoluteTemperature(as: DegreeCelsius.self)
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .infinity, unit: UnitTemperature.kelvin)
                .temperatureInterval(as: DegreeCelsius.self)
        }
    }

    @Test
    func angleUnitsRoundTripThroughFoundation() throws {
        let degrees = try Quantity<Double, Degree, Linear>(90.0).foundationMeasurement()
        let arcminutes = try Quantity<Double, Arcminute, Linear>(30.0).foundationMeasurement()
        let arcseconds = try Quantity<Double, Arcsecond, Linear>(45.0).foundationMeasurement()

        let fromDegrees = try degrees.siQuantity(as: Degree.self)
        let fromArcminutes = try arcminutes.siQuantity(as: Arcminute.self)
        let fromArcseconds = try arcseconds.siQuantity(as: Arcsecond.self)

        #expect(degrees.unit.symbol == "°")
        #expect(arcminutes.unit.symbol == "′")
        #expect(arcseconds.unit.symbol == "″")

        #expect(abs(fromDegrees.value - 90.0) < 0.000_000_1)
        #expect(abs(fromArcminutes.value - 30.0) < 0.000_000_1)
        #expect(abs(fromArcseconds.value - 45.0) < 0.000_000_1)
    }

    @Test
    func angleUnitsRejectNonFiniteFoundationBridge() throws {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Degree, Linear>(.infinity).foundationMeasurement()
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Arcminute, Linear>(.infinity).foundationMeasurement()
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Arcsecond, Linear>(.infinity).foundationMeasurement()
        }
    }

    @Test
    func logarithmicRatioUnitsRoundTripThroughFoundation() throws {
        let nepers = try Quantity<Double, Neper, Linear>(1.0).foundationMeasurement()
        let bels = try Quantity<Double, Bel, Linear>(1.0).foundationMeasurement()
        let decibels = try Quantity<Double, Decibel, Linear>(10.0).foundationMeasurement()

        let fromNepers = try nepers.siQuantity(as: Neper.self)
        let fromBels = try bels.siQuantity(as: Bel.self)
        let fromDecibels = try decibels.siQuantity(as: Decibel.self)

        #expect(nepers.unit.symbol == "Np")
        #expect(bels.unit.symbol == "B")
        #expect(decibels.unit.symbol == "dB")

        #expect(abs(fromNepers.value - 1.0) < 0.000_000_1)
        #expect(abs(fromBels.value - 1.0) < 0.000_000_1)
        #expect(abs(fromDecibels.value - 10.0) < 0.000_000_1)
    }

    @Test
    func logarithmicRatioUnitsRejectNonFiniteFoundationBridge() throws {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Neper, Linear>(.infinity).foundationMeasurement()
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Bel, Linear>(.infinity).foundationMeasurement()
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .nan, unit: UnitLogarithmicRatio.nepers).siQuantity(as: Neper.self)
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .nan, unit: UnitLogarithmicRatio.bels).siQuantity(as: Bel.self)
        }
    }
}
