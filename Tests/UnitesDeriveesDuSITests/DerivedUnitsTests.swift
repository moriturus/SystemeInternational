import Testing

@testable import UnitesDeBaseDuSI
@testable import UnitesDeriveesDuSI

struct DerivedUnitsTests {
    @Test
    func specialNamedDerivedUnitsExposeExpectedSymbolsAndCoherentScales() throws {
        #expect(Radian.symbol == "rad")
        #expect(Steradian.symbol == "sr")
        #expect(Hertz.symbol == "Hz")
        #expect(Newton.symbol == "N")
        #expect(Pascal.symbol == "Pa")
        #expect(Joule.symbol == "J")
        #expect(Watt.symbol == "W")
        #expect(Coulomb.symbol == "C")
        #expect(Volt.symbol == "V")
        #expect(Farad.symbol == "F")
        #expect(Ohm.symbol == "Ω")
        #expect(Siemens.symbol == "S")
        #expect(Weber.symbol == "Wb")
        #expect(Tesla.symbol == "T")
        #expect(Henry.symbol == "H")
        #expect(DegreeCelsius.symbol == "°C")
        #expect(Lumen.symbol == "lm")
        #expect(Lux.symbol == "lx")
        #expect(Becquerel.symbol == "Bq")
        #expect(Gray.symbol == "Gy")
        #expect(Sievert.symbol == "Sv")
        #expect(Katal.symbol == "kat")
        #expect(Newton.scale == .identity)
        #expect(Watt.scale == .identity)
        #expect(Katal.scale == .identity)
    }

    @Test
    func semanticNamedUnitsRequireExplicitInterpretationFromCanonicalQuantities() throws {
        let planeAngle = Quantity<Double, CanonicalUnit<Dimensionless>, Linear>(baseValue: .pi)
            .interpreted(as: Radian.self)
        let solidAngle = Quantity<Double, CanonicalUnit<Dimensionless>, Linear>(baseValue: 1)
            .interpreted(as: Steradian.self)
        let reciprocalSecond = Quantity<Double, CanonicalUnit<QuotientDimension<Dimensionless, TimeDimension>>, Linear>(
            baseValue: 50
        )
        let frequency = reciprocalSecond.interpreted(as: Hertz.self)
        let activity = reciprocalSecond.interpreted(as: Becquerel.self)
        let doseBase = Quantity<Double, CanonicalUnit<QuotientDimension<Joule.Dimension, MassDimension>>, Linear>(
            baseValue: 2.5
        )
        let absorbedDose = doseBase.interpreted(as: Gray.self)
        let equivalentDose = doseBase.interpreted(as: Sievert.self)

        #expect(abs(planeAngle.value - .pi) < 0.000_000_1)
        #expect(abs(solidAngle.value - 1) < 0.000_000_1)
        #expect(abs(frequency.value - 50) < 0.000_000_1)
        #expect(abs(activity.value - 50) < 0.000_000_1)
        #expect(abs(absorbedDose.value - 2.5) < 0.000_000_1)
        #expect(abs(equivalentDose.value - 2.5) < 0.000_000_1)
    }

    @Test
    func semanticUnitsCanBeDirectlyInitializedWithoutErasingTheirMeaning() throws {
        let angle = try Quantity<Double, Radian, Linear>(.pi)
        let solidAngle = try Quantity<Double, Steradian, Linear>(2)
        let frequency = try Quantity<Double, Hertz, Linear>(50)
        let activity = try Quantity<Double, Becquerel, Linear>(4)
        let absorbedDose = try Quantity<Double, Gray, Linear>(1.2)
        let equivalentDose = try Quantity<Double, Sievert, Linear>(3.4)

        #expect(abs(angle.value - .pi) < 0.000_000_1)
        #expect(abs(solidAngle.value - 2) < 0.000_000_1)
        #expect(abs(frequency.value - 50) < 0.000_000_1)
        #expect(abs(activity.value - 4) < 0.000_000_1)
        #expect(abs(absorbedDose.value - 1.2) < 0.000_000_1)
        #expect(abs(equivalentDose.value - 3.4) < 0.000_000_1)
    }

    @Test
    func directSemanticInitializationDoesNotEnableAutomaticCrossSemanticConversion() throws {
        let angle = try Quantity<Double, Radian, Linear>(1)
        let rate = try Quantity<Double, Hertz, Linear>(1)
        let dose = try Quantity<Double, Gray, Linear>(1)
        let reciprocalRate = try Quantity<
            Double, CanonicalUnit<QuotientDimension<Dimensionless, TimeDimension>>, Linear
        >(1)
        let canonicalDose = try Quantity<
            Double, CanonicalUnit<QuotientDimension<Joule.Dimension, MassDimension>>, Linear
        >(1)

        #expect(abs(angle.value - 1) < 0.000_000_1)
        #expect(abs(rate.value - 1) < 0.000_000_1)
        #expect(abs(dose.value - 1) < 0.000_000_1)
        #expect(abs(reciprocalRate.interpreted(as: Becquerel.self).value - 1) < 0.000_000_1)
        #expect(abs(canonicalDose.interpreted(as: Sievert.self).value - 1) < 0.000_000_1)
    }

    @Test
    func mechanicalElectricalAndRadiometricFormulasConvertToNamedUnits() throws {
        let mass = try Quantity<Double, Kilogram, Linear>(2)
        let distance = try Quantity<Double, Meter, Linear>(3)
        let time = try Quantity<Double, Second, Linear>(4)
        let current = try Quantity<Double, Ampere, Linear>(5)
        let luminousIntensity = try Quantity<Double, Candela, Linear>(8)
        let solidAngle = Quantity<Double, CanonicalUnit<Dimensionless>, Linear>(baseValue: 2)
            .interpreted(as: Steradian.self)

        let force = try (try (try mass * distance) / time) / time
        let forceInNewtons = force.converted(to: Newton.self)
        let area = try distance * distance
        let pressure = try forceInNewtons / area
        let pressureInPascals = pressure.converted(to: Pascal.self)
        let energy = try forceInNewtons * distance
        let energyInJoules = energy.converted(to: Joule.self)
        let power = try energyInJoules / time
        let powerInWatts = power.converted(to: Watt.self)
        let charge = try current * time
        let chargeInCoulombs = charge.converted(to: Coulomb.self)
        let voltage = try powerInWatts / current
        let voltageInVolts = voltage.converted(to: Volt.self)
        let flux = try voltageInVolts * time
        let fluxInWebers = flux.converted(to: Weber.self)
        let fluxDensity = try fluxInWebers / area
        let fluxDensityInTesla = fluxDensity.converted(to: Tesla.self)
        let inductance = try fluxInWebers / current
        let inductanceInHenries = inductance.converted(to: Henry.self)
        let luminousFlux = try luminousIntensity * solidAngle
        let luminousFluxInLumens = luminousFlux.converted(to: Lumen.self)
        let illuminance = try luminousFluxInLumens / area
        let illuminanceInLux = illuminance.converted(to: Lux.self)

        #expect(abs(forceInNewtons.value - 0.375) < 0.000_000_1)
        #expect(abs(pressureInPascals.value - 0.041_666_666_7) < 0.000_000_1)
        #expect(abs(energyInJoules.value - 1.125) < 0.000_000_1)
        #expect(abs(powerInWatts.value - 0.281_25) < 0.000_000_1)
        #expect(abs(chargeInCoulombs.value - 20) < 0.000_000_1)
        #expect(abs(voltageInVolts.value - 0.056_25) < 0.000_000_1)
        #expect(abs(fluxInWebers.value - 0.225) < 0.000_000_1)
        #expect(abs(fluxDensityInTesla.value - 0.025) < 0.000_000_1)
        #expect(abs(inductanceInHenries.value - 0.045) < 0.000_000_1)
        #expect(abs(luminousFluxInLumens.value - 16) < 0.000_000_1)
        #expect(abs(illuminanceInLux.value - 1.777_777_777_8) < 0.000_000_1)
    }

    @Test
    func reciprocalDoseAndCatalyticActivityFormulasConvertToNamedUnits() throws {
        let one = Quantity<Double, CanonicalUnit<Dimensionless>, Linear>(baseValue: 1)
        let time = try Quantity<Double, Second, Linear>(5)
        let moles = try Quantity<Double, Mole, Linear>(2)
        let mass = try Quantity<Double, Kilogram, Linear>(4)
        let forceMass = try Quantity<Double, Kilogram, Linear>(2)
        let forceDistance = try Quantity<Double, Meter, Linear>(3)
        let forceNumerator = try forceMass * forceDistance
        let force = try (try forceNumerator / time) / time
        let workDistance = try Quantity<Double, Meter, Linear>(3)
        let energy = try force.converted(to: Newton.self) * workDistance
        let energyInJoules = energy.converted(to: Joule.self)

        let reciprocalRate = try one / time
        let doseBase = try energyInJoules / mass

        let frequency = reciprocalRate.interpreted(as: Hertz.self)
        let activity = reciprocalRate.interpreted(as: Becquerel.self)
        let absorbedDose = doseBase.interpreted(as: Gray.self)
        let doseEquivalent = doseBase.interpreted(as: Sievert.self)
        let catalyticActivity = (try moles / time).converted(to: Katal.self)

        #expect(abs(frequency.value - 0.2) < 0.000_000_1)
        #expect(abs(activity.value - 0.2) < 0.000_000_1)
        #expect(abs(absorbedDose.value - 0.18) < 0.000_000_1)
        #expect(abs(doseEquivalent.value - 0.18) < 0.000_000_1)
        #expect(abs(catalyticActivity.value - 0.4) < 0.000_000_1)
    }

    @Test
    func electricalReciprocalUnitsConvertToNamedUnits() throws {
        let current = try Quantity<Double, Ampere, Linear>(2)
        let time = try Quantity<Double, Second, Linear>(4)
        let charge = (try current * time).converted(to: Coulomb.self)
        let voltage = try Quantity<Double, Volt, Linear>(12)

        let capacitance = (try charge / voltage).converted(to: Farad.self)
        let resistance = (try voltage / current).converted(to: Ohm.self)
        let conductance = (try current / voltage).converted(to: Siemens.self)

        #expect(abs(capacitance.value - 0.666_666_666_7) < 0.000_000_1)
        #expect(abs(resistance.value - 6) < 0.000_000_1)
        #expect(abs(conductance.value - 0.166_666_666_7) < 0.000_000_1)
    }

    @Test
    func engineeringPressureScenarioConvertsSquarelyIntoPascals() throws {
        let force = try Quantity<Double, Newton, Linear>(1_250)
        let width = try Quantity<Double, Meter, Linear>(0.5)
        let height = try Quantity<Double, Meter, Linear>(0.25)
        let area = try width * height
        let pressure = try force / area
        let pressureInPascals = pressure.converted(to: Pascal.self)

        #expect(abs(pressureInPascals.value - 10_000) < 0.000_000_1)
    }

    @Test
    func groupedDenominatorsMatchRepeatedDivisionDimensions() throws {
        let mass = try Quantity<Double, Kilogram, Linear>(2)
        let distance = try Quantity<Double, Meter, Linear>(3)
        let time = try Quantity<Double, Second, Linear>(4)

        let numerator = try mass * distance
        let denominator = try time * time
        let groupedForce = try numerator / denominator
        let repeatedForce = try (try numerator / time) / time

        #expect(abs(groupedForce.converted(to: Newton.self).value - 0.375) < 0.000_000_1)
        #expect(groupedForce.baseValue == repeatedForce.baseValue)
    }

    @Test
    func catalystAndRadiationRealWorldValuesRemainReadableInNamedUnits() throws {
        let substrate = try Quantity<Double, Mole, Linear>(0.012)
        let time = try Quantity<Double, Second, Linear>(60)
        let catalyticActivity = (try substrate / time).converted(to: Katal.self)
        let absorbedDose = Quantity<Double, CanonicalUnit<QuotientDimension<Joule.Dimension, MassDimension>>, Linear>(
            baseValue: 1.8
        )
        .interpreted(as: Gray.self)
        let doseEquivalent = Quantity<Double, CanonicalUnit<QuotientDimension<Joule.Dimension, MassDimension>>, Linear>(
            baseValue: absorbedDose.baseValue
        )
        .interpreted(as: Sievert.self)

        #expect(abs(catalyticActivity.value - 0.0002) < 0.000_000_1)
        #expect(abs(doseEquivalent.value - 1.8) < 0.000_000_1)
    }

    @Test
    func semanticPropagationPreservesKnownPhotometricRelationshipsOnly() throws {
        let intensity = try Quantity<Double, Candela, Linear>(8)
        let solidAngle = try Quantity<Double, Steradian, Linear>(2)
        let luminousFlux = try intensity * solidAngle
        let width = try Quantity<Double, Meter, Linear>(3)
        let height = try Quantity<Double, Meter, Linear>(3)
        let area = try width * height
        let illuminance = try luminousFlux / area

        let luminanceLike = try intensity / area

        let typedFlux: Quantity<Double, Lumen, Linear> = luminousFlux
        let typedIlluminance: Quantity<Double, Lux, Linear> = illuminance
        let typedLuminanceLike:
            Quantity<
                Double,
                CanonicalUnit<
                    QuotientDimension<QuotientDimension<LuminousIntensityDimension, LengthDimension>, LengthDimension>
                >,
                Linear
            > = luminanceLike

        #expect(abs(typedFlux.value - 16) < 0.000_000_1)
        #expect(abs(typedIlluminance.value - 1.777_777_777_8) < 0.000_000_1)
        #expect(abs(typedLuminanceLike.value - 0.888_888_888_9) < 0.000_000_1)
    }
}
