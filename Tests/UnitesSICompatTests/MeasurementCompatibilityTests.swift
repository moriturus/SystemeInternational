import CompatSupport
import Foundation
import Testing
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI
import UnitesSI

@testable import UnitesSICompat

private let millisecondsUnit = UnitDuration(
    symbol: "ms",
    converter: UnitConverterLinear(coefficient: 0.001)
)

private enum HugeLengthBridgeUnit: FoundationBridgeableDirectUnitProtocol {
    static let symbol = "test-m"
    static let scale = UnitScale.identity
    typealias Dimension = LengthDimension
    static let foundationDimension: Foundation.Dimension = UnitLength(
        symbol: "test-m",
        converter: UnitConverterLinear(coefficient: .leastNonzeroMagnitude)
    )
}

private enum UnsupportedTemperatureUnit: DirectlyInitializableUnitProtocol {
    static let symbol = "?T"
    static let scale = UnitScale.identity
    typealias Dimension = TemperatureDimension
}

private enum HugeSemanticLengthDimension: DimensionProtocol {}

private enum HugeSemanticLengthUnit: FoundationBridgeableSemanticUnitProtocol {
    static let symbol = "hLm"
    static let scale = UnitScale(uncheckedNumerator: 1, denominator: 1, decimalExponent: 309)
    static let semanticInterpretationToken = SemanticInterpretationToken()
    typealias Dimension = HugeSemanticLengthDimension
    typealias CanonicalDimension = LengthDimension
    static let foundationDimension: Foundation.Dimension = UnitLength.meters
}

struct MeasurementCompatibilityTests {
    @Test
    func standardFoundationDimensionsRoundTripThroughSIQuantities() throws {
        let roadDistance = try Quantity<Double, Kilometer, Linear>(12.3).foundationMeasurement()
        let roadDistanceInSI = try Measurement(value: 12.3, unit: UnitLength.kilometers).siQuantity(as: Kilometer.self)
        let thicknessInSI = try Measurement(value: 0.8, unit: UnitLength.millimeters).siQuantity(as: Millimeter.self)
        let pulseWidthInSI = try Measurement(value: 250, unit: millisecondsUnit).siQuantity(as: Millisecond.self)
        let currentInSI = try Measurement(value: 4, unit: UnitElectricCurrent.microamperes)
            .siQuantity(as: Microampere.self)

        #expect(roadDistance.unit.symbol == "km")
        #expect(abs(roadDistance.value - 12.3) < 0.000_000_1)
        #expect(abs(roadDistanceInSI.value - 12.3) < 0.000_000_1)
        #expect(abs(thicknessInSI.converted(to: Meter.self).value - 0.000_8) < 0.000_000_1)
        #expect(abs(pulseWidthInSI.converted(to: Second.self).value - 0.25) < 0.000_000_1)
        #expect(abs(currentInSI.converted(to: Ampere.self).value - 0.000_004) < 0.000_000_1)
    }

    @Test
    func additionalFoundationFamiliesBridgeThroughAllPrimaryCompatMappings() throws {
        let distance = try Quantity<Double, Meter, Linear>(3).foundationMeasurement()
        let nanos = try Measurement(value: 12, unit: UnitLength.nanometers).siQuantity(as: Nanometer.self)
        let seconds = try Quantity<Double, Second, Linear>(1.5).foundationMeasurement()
        let mass = try Quantity<Double, Kilogram, Linear>(2).foundationMeasurement()
        let current = try Quantity<Double, Ampere, Linear>(0.25).foundationMeasurement()
        let charge = try Measurement(value: 3, unit: UnitElectricCharge.coulombs).siQuantity(as: Coulomb.self)
        let voltage = try Measurement(value: 9, unit: UnitElectricPotentialDifference.volts).siQuantity(as: Volt.self)
        let energy = try Measurement(value: 42, unit: UnitEnergy.joules).siQuantity(as: Joule.self)
        let amount = try Quantity<Double, Mole, Linear>(0.75).foundationMeasurement()

        #expect(distance.unit.symbol == "m")
        #expect(abs(nanos.value - 12) < 0.000_000_1)
        #expect(seconds.unit.symbol == "s")
        #expect(mass.unit.symbol == "kg")
        #expect(current.unit.symbol == "A")
        #expect(abs(charge.value - 3) < 0.000_000_1)
        #expect(abs(voltage.value - 9) < 0.000_000_1)
        #expect(abs(energy.value - 42) < 0.000_000_1)
        #expect(amount.unit.symbol == "mol")
    }

    @Test
    func standardDerivedUnitsRoundTripThroughFoundationMeasurements() throws {
        let pressureMeasurement = Measurement(value: 101.3, unit: UnitPressure.kilopascals)
        let pressure = try pressureMeasurement.siQuantity(as: Pascal.self)
        let pressureRoundTrip = try pressure.foundationMeasurement()
        let illuminance = try Measurement(value: 500, unit: UnitIlluminance.lux).siQuantity(as: Lux.self)
        let power = try Measurement(value: 1.5, unit: UnitPower.watts).siQuantity(as: Watt.self)

        #expect(abs(pressure.value - 101_300) < 0.000_000_1)
        #expect(abs(pressureRoundTrip.converted(to: UnitPressure.kilopascals).value - 101.3) < 0.000_000_1)
        #expect(abs(illuminance.value - 500) < 0.000_000_1)
        #expect(abs(power.value - 1.5) < 0.000_000_1)
    }

    @Test
    func semanticFoundationDimensionsRoundTripThroughCompatLayer() throws {
        let angle = try Measurement(value: .pi, unit: UnitPlaneAngle.radians).siQuantity(as: Radian.self)
        let solidAngle = try Measurement(value: 2, unit: UnitSolidAngle.steradians).siQuantity(as: Steradian.self)
        let frequency = try Measurement(value: 50, unit: UnitFrequency.hertz).siQuantity(as: Hertz.self)
        let activity = try Measurement(value: 4, unit: UnitRadioactivity.becquerels).siQuantity(as: Becquerel.self)
        let absorbedDose = try Measurement(value: 1.2, unit: UnitAbsorbedDose.grays).siQuantity(as: Gray.self)
        let equivalentDose = try Measurement(value: 3.4, unit: UnitDoseEquivalent.sieverts).siQuantity(as: Sievert.self)

        #expect(abs(angle.value - .pi) < 0.000_000_1)
        #expect(abs(solidAngle.value - 2) < 0.000_000_1)
        #expect(abs(frequency.value - 50) < 0.000_000_1)
        #expect(abs(activity.value - 4) < 0.000_000_1)
        #expect(abs(absorbedDose.value - 1.2) < 0.000_000_1)
        #expect(abs(equivalentDose.value - 3.4) < 0.000_000_1)

        #expect(try angle.foundationMeasurement().unit.symbol == "rad")
        #expect(try solidAngle.foundationMeasurement().unit.symbol == "sr")
        #expect(try frequency.foundationMeasurement().unit.symbol == "Hz")
        #expect(try activity.foundationMeasurement().unit.symbol == "Bq")
        #expect(try absorbedDose.foundationMeasurement().unit.symbol == "Gy")
        #expect(try equivalentDose.foundationMeasurement().unit.symbol == "Sv")
    }

    @Test
    func semanticCompatRejectsNonFiniteScaledBaseValues() throws {
        #expect(throws: CompatibilityError.nonFiniteValue) {
            let _: Quantity<Double, HugeSemanticLengthUnit, Linear> =
                try compatSemanticQuantity(from: Measurement(value: 1, unit: UnitLength.meters))
        }
    }

    @Test
    func customFoundationDimensionsRoundTripThroughCompatLayer() throws {
        let amount = try Measurement(value: 2.5, unit: UnitAmountOfSubstance.millimoles).siQuantity(as: Millimole.self)
        let capacitance = try Measurement(value: 47, unit: UnitElectricCapacitance.microfarads)
            .siQuantity(as: Farad.self)
        let conductance = try Measurement(value: 2, unit: UnitElectricConductance.siemens).siQuantity(as: Siemens.self)
        let magneticFlux = try Measurement(value: 0.25, unit: UnitMagneticFlux.webers).siQuantity(as: Weber.self)
        let magneticFluxDensity = try Measurement(value: 1.5, unit: UnitMagneticFluxDensity.milliteslas)
            .siQuantity(as: Tesla.self)
        let inductance = try Measurement(value: 0.01, unit: UnitInductance.henries).siQuantity(as: Henry.self)
        let luminousFlux = try Measurement(value: 800, unit: UnitLuminousFlux.lumens).siQuantity(as: Lumen.self)
        let catalyticActivity = try Measurement(value: 0.2, unit: UnitCatalyticActivity.katals)
            .siQuantity(as: Katal.self)

        #expect(abs(amount.converted(to: Mole.self).value - 0.002_5) < 0.000_000_1)
        #expect(abs(capacitance.value - 0.000_047) < 0.000_000_000_1)
        #expect(abs(conductance.value - 2) < 0.000_000_1)
        #expect(abs(magneticFlux.value - 0.25) < 0.000_000_1)
        #expect(abs(magneticFluxDensity.value - 0.001_5) < 0.000_000_1)
        #expect(abs(inductance.value - 0.01) < 0.000_000_1)
        #expect(abs(luminousFlux.value - 800) < 0.000_000_1)
        #expect(abs(catalyticActivity.value - 0.2) < 0.000_000_1)
    }

    @Test
    func customCompatMeasurementsRoundTripToFoundationUnits() throws {
        let capacitanceMeasurement = try Quantity<Double, Farad, Linear>(0.000_047).foundationMeasurement()

        #expect(abs(capacitanceMeasurement.converted(to: UnitElectricCapacitance.microfarads).value - 47) < 0.000_000_1)
    }

    @Test
    func prefixedFoundationDimensionsRemainStableWithoutLockBackedCaching() throws {
        #expect(Kilometer.foundationDimension.symbol == "km")
        #expect(Millisecond.foundationDimension.symbol == "ms")
        #expect(Microampere.foundationDimension.symbol == "μA")
        #expect(Millimole.foundationDimension.symbol == "mmol")
        #expect(
            abs(
                Measurement(value: 1, unit: Kilometer.foundationDimension as! UnitLength).converted(to: .meters).value
                    - 1_000
            )
                < 0.000_000_1
        )
        #expect(
            abs(
                Measurement(value: 1, unit: Millisecond.foundationDimension as! UnitDuration).converted(to: .seconds)
                    .value - 0.001
            )
                < 0.000_000_1
        )
    }

    @Test
    func customCompatDimensionFamiliesExposeExpectedBaseUnits() throws {
        #expect(UnitAmountOfSubstance.baseUnit() === UnitAmountOfSubstance.moles)
        #expect(UnitPlaneAngle.baseUnit() === UnitPlaneAngle.radians)
        #expect(UnitSolidAngle.baseUnit() === UnitSolidAngle.steradians)
        #expect(UnitElectricCapacitance.baseUnit() === UnitElectricCapacitance.farads)
        #expect(UnitElectricCapacitance.microfarads.symbol == "μF")
        #expect(UnitElectricConductance.baseUnit() === UnitElectricConductance.siemens)
        #expect(UnitMagneticFlux.baseUnit() === UnitMagneticFlux.webers)
        #expect(UnitMagneticFluxDensity.baseUnit() === UnitMagneticFluxDensity.teslas)
        #expect(UnitInductance.baseUnit() === UnitInductance.henries)
        #expect(UnitLuminousFlux.baseUnit() === UnitLuminousFlux.lumens)
        #expect(UnitRadioactivity.baseUnit() === UnitRadioactivity.becquerels)
        #expect(UnitAbsorbedDose.baseUnit() === UnitAbsorbedDose.grays)
        #expect(UnitDoseEquivalent.baseUnit() === UnitDoseEquivalent.sieverts)
        #expect(UnitCatalyticActivity.baseUnit() === UnitCatalyticActivity.katals)
    }

    @Test
    func absoluteTemperatureBridgesToFoundationMeasurement() throws {
        let freezingPoint = try CelsiusTemperatureValue(0)
        let roomTemperature = try CelsiusTemperatureValue(25)
        let freezingMeasurement = try freezingPoint.foundationMeasurement()
        let roomKelvinMeasurement = try roomTemperature.converted(to: Kelvin.self).foundationMeasurement()
        let fromCelsiusMeasurement = try Measurement(value: 25, unit: UnitTemperature.celsius)
            .absoluteTemperature(as: DegreeCelsius.self)
        let fromKelvinMeasurement = try Measurement(value: 298.15, unit: UnitTemperature.kelvin)
            .absoluteTemperature(as: Kelvin.self)

        #expect(abs(freezingMeasurement.converted(to: .kelvin).value - 273.15) < 0.000_000_1)
        #expect(abs(roomKelvinMeasurement.value - 298.15) < 0.000_000_1)
        #expect(abs(fromCelsiusMeasurement.converted(to: Kelvin.self).value - 298.15) < 0.000_000_1)
        #expect(abs(fromKelvinMeasurement.value - 298.15) < 0.000_000_1)
    }

    @Test
    func temperatureIntervalsBridgeWithoutApplyingCelsiusOffset() throws {
        let interval = try CelsiusTemperatureDifference(10)
        let intervalMeasurement = try interval.foundationMeasurementComponents()
        let kelvinIntervalMeasurement = try KelvinTemperatureDifference(10).foundationMeasurementComponents()
        let roundTripKelvin = try Measurement(value: 10, unit: UnitTemperature.celsius)
            .temperatureInterval(as: Kelvin.self)
        let roundTripCelsius = try Measurement(value: 10, unit: UnitTemperature.kelvin)
            .temperatureInterval(as: DegreeCelsius.self)

        #expect(intervalMeasurement.unit.symbol == "°C")
        #expect(kelvinIntervalMeasurement.unit.symbol == "K")
        #expect(intervalMeasurement.value == 10)
        #expect(kelvinIntervalMeasurement.value == 10)
        #expect(abs(roundTripKelvin.value - 10) < 0.000_000_1)
        #expect(abs(roundTripCelsius.value - 10) < 0.000_000_1)
    }

    @Test
    func unsupportedCasesAreRejectedOrNotExposed() throws {
        #expect(throws: CompatibilityError.unsupportedMeasurement) {
            _ = try Measurement(value: 1, unit: UnitMass.kilograms).siQuantity(as: Meter.self)
        }

        #expect(throws: CompatibilityError.unsupportedUnit) {
            _ = try Measurement(value: 300, unit: UnitTemperature.kelvin)
                .absoluteTemperature(as: UnsupportedTemperatureUnit.self)
        }

        #expect(throws: CompatibilityError.unsupportedMeasurement) {
            _ = try Measurement(value: 32, unit: UnitTemperature.fahrenheit)
                .temperatureInterval(as: Kelvin.self)
        }

        #expect(throws: CompatibilityError.unsupportedUnit) {
            _ = try Measurement(value: 32, unit: UnitTemperature.kelvin)
                .temperatureInterval(as: UnsupportedTemperatureUnit.self)
        }

        #expect((Kelvin.self is any FoundationBridgeableUnitProtocol.Type) == false)
        #expect((CanonicalUnit<Dimensionless>.self is any FoundationBridgeableUnitProtocol.Type) == false)
    }

    @Test
    func customTemperatureExpressionsAreRejectedByFoundationBridge() throws {
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
    func erasedFoundationMeasurementsCannotCrossPhysicalFamilies() throws {
        let lengthMeasurement = try Quantity<Double, Meter, Linear>(1).foundationMeasurement()

        #expect(throws: CompatibilityError.unsupportedMeasurement) {
            _ = try lengthMeasurement.siQuantity(as: Kilogram.self)
        }
    }

    @Test
    func nonFiniteValuesAreRejectedAtCompatBoundaries() throws {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Meter, Linear>(.nan).foundationMeasurement()
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .infinity, unit: UnitLength.meters).siQuantity(as: Meter.self)
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: -.infinity, unit: UnitPlaneAngle.radians).siQuantity(as: Radian.self)
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .nan, unit: UnitTemperature.celsius).absoluteTemperature(as: DegreeCelsius.self)
        }

        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: .infinity, unit: UnitTemperature.kelvin)
                .temperatureInterval(as: Kelvin.self)
        }
    }

    @Test
    func compatHelpersRejectNonFiniteConvertedValuesAndSemanticMismatches() throws {
        #expect(throws: CompatibilityError.nonFiniteValue) {
            _ = try Measurement(value: 1, unit: UnitLength.meters).siQuantity(as: HugeLengthBridgeUnit.self)
        }

        let erasedLengthMeasurement: Measurement<Dimension> = try Quantity<Double, Meter, Linear>(1)
            .foundationMeasurement()

        #expect(throws: CompatibilityError.unsupportedMeasurement) {
            _ = try erasedLengthMeasurement.siQuantity(as: Radian.self)
        }
    }
}
