import Testing
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI

struct DerivedUnitSampleTests {
    @Test
    func cameraPanAngleCanBeExpressedInRadians() throws {
        let halfTurn = try Quantity<Double, Radian, Linear>(.pi)
        let directAngle = try Quantity<Double, Radian, Linear>(.pi / 2)

        #expect(abs(halfTurn.value - .pi) < 0.000_000_1)
        #expect(abs(directAngle.value - (.pi / 2)) < 0.000_000_1)
    }

    @Test
    func spotlightBeamSpreadCanBeExpressedInSteradians() throws {
        let beamSpread = try Quantity<Double, Steradian, Linear>(1.8)
        let narrowBeam = try Quantity<Double, Steradian, Linear>(0.75)

        #expect(abs(beamSpread.value - 1.8) < 0.000_000_1)
        #expect(narrowBeam < beamSpread)
    }

    @Test
    func rotatingFanProducesCanonicalAngularFrequency() throws {
        let bladeAnglePerSecond = try Quantity<Double, Radian, Linear>(188.495_559_2)
        let second = try Quantity<Double, Second, Linear>(1)
        let angularFrequency:
            Quantity<Double, CanonicalUnit<QuotientDimension<PlaneAngleDimension, TimeDimension>>, Linear> =
                try bladeAnglePerSecond / second
        let interpretedFrequency = try Quantity<
            Double, CanonicalUnit<QuotientDimension<Dimensionless, TimeDimension>>, Linear
        >(
            60
        )
        .interpreted(as: Hertz.self)

        #expect(abs(angularFrequency.value - 188.495_559_2) < 0.000_000_1)
        #expect(abs(interpretedFrequency.value - 60) < 0.000_000_1)
    }

    @Test
    func warehousePalletPushCalculatesForceInNewtons() throws {
        let palletMass = try Quantity<Double, Kilogram, Linear>(250)
        let firstSecond = try Quantity<Double, Second, Linear>(1)
        let secondSecond = try Quantity<Double, Second, Linear>(1)
        let timeSquared = try firstSecond * secondSecond
        let displacement = try Quantity<Double, Meter, Linear>(1.2)
        let massDistance = try palletMass * displacement
        let pushForce = try (massDistance / timeSquared).converted(to: Newton.self)

        #expect(abs(pushForce.value - 300) < 0.000_000_1)
    }

    @Test
    func hydraulicJackPressureCalculatesInPascals() throws {
        let appliedForce = try Quantity<Double, Newton, Linear>(12_500)
        let firstEdge = try Quantity<Double, Meter, Linear>(0.05)
        let secondEdge = try Quantity<Double, Meter, Linear>(0.05)
        let pistonArea = try firstEdge * secondEdge
        let pressure = try (appliedForce / pistonArea).converted(to: Pascal.self)

        #expect(abs(pressure.value - 5_000_000) < 0.000_000_1)
    }

    @Test
    func batteryDischargeWorkCalculatesInJoules() throws {
        let pushForce = try Quantity<Double, Newton, Linear>(48)
        let travel = try Quantity<Double, Meter, Linear>(12)
        let work = try (pushForce * travel).converted(to: Joule.self)

        #expect(abs(work.value - 576) < 0.000_000_1)
    }

    @Test
    func treadmillEffortCalculatesInWatts() throws {
        let work = try Quantity<Double, Joule, Linear>(900)
        let interval = try Quantity<Double, Second, Linear>(30)
        let power = try (work / interval).converted(to: Watt.self)

        #expect(abs(power.value - 30) < 0.000_000_1)
    }

    @Test
    func phoneBatteryTransferCalculatesInCoulombs() throws {
        let chargingCurrent = try Quantity<Double, Ampere, Linear>(2.4)
        let chargingTime = try Quantity<Double, Second, Linear>(1_800)
        let charge = try (chargingCurrent * chargingTime).converted(to: Coulomb.self)

        #expect(abs(charge.value - 4_320) < 0.000_000_1)
    }

    @Test
    func solarPanelPotentialDifferenceCalculatesInVolts() throws {
        let outputPower = try Quantity<Double, Watt, Linear>(360)
        let outputCurrent = try Quantity<Double, Ampere, Linear>(10)
        let voltage = try (outputPower / outputCurrent).converted(to: Volt.self)

        #expect(abs(voltage.value - 36) < 0.000_000_1)
    }

    @Test
    func flashCircuitCapacitanceCalculatesInFarads() throws {
        let storedCharge = try Quantity<Double, Coulomb, Linear>(0.94)
        let chargingVoltage = try Quantity<Double, Volt, Linear>(200)
        let capacitance = try (storedCharge / chargingVoltage).converted(to: Farad.self)

        #expect(abs(capacitance.value - 0.0047) < 0.000_000_1)
    }

    @Test
    func heaterElementResistanceCalculatesInOhms() throws {
        let supplyVoltage = try Quantity<Double, Volt, Linear>(230)
        let runningCurrent = try Quantity<Double, Ampere, Linear>(10)
        let resistance = try (supplyVoltage / runningCurrent).converted(to: Ohm.self)

        #expect(abs(resistance.value - 23) < 0.000_000_1)
    }

    @Test
    func leakPathConductanceCalculatesInSiemens() throws {
        let leakageCurrent = try Quantity<Double, Ampere, Linear>(0.012)
        let testVoltage = try Quantity<Double, Volt, Linear>(24)
        let conductance = try (leakageCurrent / testVoltage).converted(to: Siemens.self)

        #expect(abs(conductance.value - 0.0005) < 0.000_000_1)
    }

    @Test
    func generatorFluxCalculatesInWebers() throws {
        let inducedVoltage = try Quantity<Double, Volt, Linear>(18)
        let fieldCollapseTime = try Quantity<Double, Second, Linear>(0.02)
        let magneticFlux = try (inducedVoltage * fieldCollapseTime).converted(to: Weber.self)

        #expect(abs(magneticFlux.value - 0.36) < 0.000_000_1)
    }

    @Test
    func magnetFluxDensityCalculatesInTesla() throws {
        let magneticFlux = try Quantity<Double, Weber, Linear>(0.012)
        let firstPoleEdge = try Quantity<Double, Meter, Linear>(0.02)
        let secondPoleEdge = try Quantity<Double, Meter, Linear>(0.02)
        let poleArea = try firstPoleEdge * secondPoleEdge
        let fluxDensity = try (magneticFlux / poleArea).converted(to: Tesla.self)

        #expect(abs(fluxDensity.value - 30) < 0.000_000_1)
    }

    @Test
    func coilInductanceCalculatesInHenries() throws {
        let magneticFlux = try Quantity<Double, Weber, Linear>(0.08)
        let current = try Quantity<Double, Ampere, Linear>(4)
        let inductance = try (magneticFlux / current).converted(to: Henry.self)

        #expect(abs(inductance.value - 0.02) < 0.000_000_1)
    }

    @Test
    func projectorLuminousFluxCalculatesInLumens() throws {
        let luminousIntensity = try Quantity<Double, Candela, Linear>(1_200)
        let beamSpread = try Quantity<Double, Steradian, Linear>(1.5)
        let luminousFlux = try (luminousIntensity * beamSpread).converted(to: Lumen.self)

        #expect(abs(luminousFlux.value - 1_800) < 0.000_000_1)
    }

    @Test
    func officeDeskIlluminanceCalculatesInLux() throws {
        let luminousFlux = try Quantity<Double, Lumen, Linear>(1_500)
        let deskWidth = try Quantity<Double, Meter, Linear>(1.5)
        let deskDepth = try Quantity<Double, Meter, Linear>(0.8)
        let deskArea = try deskWidth * deskDepth
        let illuminance = try (luminousFlux / deskArea).converted(to: Lux.self)

        #expect(abs(illuminance.value - 1_250) < 0.000_000_1)
    }

    @Test
    func isotopeActivityCanBeInterpretedAsBecquerels() throws {
        let decaysPerSecond = try Quantity<
            Double, CanonicalUnit<QuotientDimension<Dimensionless, TimeDimension>>, Linear
        >(
            12_500
        )
        .interpreted(as: Becquerel.self)
        let sealedSource = try Quantity<Double, Becquerel, Linear>(3_700)

        #expect(abs(decaysPerSecond.value - 12_500) < 0.000_000_1)
        #expect(sealedSource < decaysPerSecond)
    }

    @Test
    func absorbedRadiationDoseCanBeInterpretedAsGray() throws {
        let depositedEnergy = try Quantity<Double, Joule, Linear>(0.009)
        let tissueMass = try Quantity<Double, Kilogram, Linear>(0.003)
        let absorbedDose =
            try
            ((depositedEnergy / tissueMass)
            .converted(
                to: CanonicalUnit<QuotientDimension<Joule.Dimension, MassDimension>>.self
            ))
            .interpreted(as: Gray.self)
        let directDose = try Quantity<Double, Gray, Linear>(1.2)

        #expect(abs(absorbedDose.value - 3) < 0.000_000_1)
        #expect(directDose < absorbedDose)
    }

    @Test
    func equivalentRadiationDoseCanBeInterpretedAsSievert() throws {
        let doseEquivalentBase = try Quantity<
            Double, CanonicalUnit<QuotientDimension<Joule.Dimension, MassDimension>>, Linear
        >(
            0.006
        )
        .interpreted(as: Sievert.self)
        let directEquivalentDose = try Quantity<Double, Sievert, Linear>(0.002)

        #expect(abs(doseEquivalentBase.value - 0.006) < 0.000_000_1)
        #expect(directEquivalentDose < doseEquivalentBase)
    }

    @Test
    func enzymeTurnoverCalculatesInKatal() throws {
        let convertedSubstrate = try Quantity<Double, Mole, Linear>(0.018)
        let reactionTime = try Quantity<Double, Second, Linear>(90)
        let catalyticActivity = try (convertedSubstrate / reactionTime).converted(to: Katal.self)

        #expect(abs(catalyticActivity.value - 0.0002) < 0.000_000_1)
    }
}
