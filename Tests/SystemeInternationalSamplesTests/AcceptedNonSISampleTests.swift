import Testing
import UtiliseesNonSI

struct AcceptedNonSISampleTests {
    @Test
    func cookingTimerUsesMinutesNaturally() throws {
        let simmering = try Quantity<Double, Minute, Linear>(12)
        let resting = try Quantity<Double, Minute, Linear>(3)
        let totalTime = try simmering + resting

        #expect(totalTime.value == 15)
        let fifteenMinutes = try Quantity<Double, Second, Linear>(900).converted(to: Minute.self)
        #expect(totalTime == fifteenMinutes)
    }

    @Test
    func maintenanceWindowReadsCleanlyInHours() throws {
        let databaseUpgrade = try Quantity<Double, Hour, Linear>(2.5)
        let verification = try Quantity<Double, Minute, Linear>(45).converted(to: Hour.self)
        let totalWindow = try databaseUpgrade + verification

        #expect(abs(totalWindow.value - 3.25) < 0.000_000_1)
    }

    @Test
    func expeditionDurationCanBePlannedInDays() throws {
        let hiking = try Quantity<Double, Day, Linear>(4)
        let weatherDelay = try Quantity<Double, Hour, Linear>(12).converted(to: Day.self)
        let totalTrip = try hiking + weatherDelay

        #expect(abs(totalTrip.value - 4.5) < 0.000_000_1)
    }

    @Test
    func freightManifestCanBeReadInTonnes() throws {
        let steelCoils = try Quantity<Double, Tonne, Linear>(18)
        let pallets = try Quantity<Double, Kilogram, Linear>(2_500).converted(to: Tonne.self)
        let totalLoad = try steelCoils + pallets

        #expect(abs(totalLoad.value - 20.5) < 0.000_000_1)
    }

    @Test
    func farmPlotAreaCanBeEstimatedInHectares() throws {
        let vineyard = try Quantity<Double, Hectare, Linear>(3.2)
        let width = try Quantity<Double, Meter, Linear>(80)
        let height = try Quantity<Double, Meter, Linear>(40)
        let expansion = try (width * height).converted(to: Hectare.self)
        let totalArea = try vineyard + expansion

        #expect(abs(totalArea.value - 3.52) < 0.000_000_1)
    }

    @Test
    func orbitalDistanceCanBeReadInAstronomicalUnits() throws {
        let earthOrbitRadius = try Quantity<Double, AstronomicalUnit, Linear>(1)
        let earthOrbitInMeters = earthOrbitRadius.converted(to: Meter.self)

        #expect(abs(earthOrbitInMeters.value - 149_597_870_700) < 0.000_000_1)
    }

    @Test
    func photonEnergyCanBeReadInElectronVolts() throws {
        let visiblePhoton = try Quantity<Double, ElectronVolt, Linear>(2.1)
        let visiblePhotonInJoules = visiblePhoton.converted(to: Joule.self)

        #expect(
            abs(visiblePhotonInJoules.value - 0.000_000_000_000_000_000_336_457_093_14)
                < 0.000_000_000_000_000_000_000_000_001
        )
    }

    @Test
    func peptideMassCanBeReadInDaltons() throws {
        let peptide = try Quantity<Double, Dalton, Linear>(8_500)
        let peptideInKilograms = peptide.converted(to: Kilogram.self)

        #expect(
            abs(peptideInKilograms.value - 0.000_000_000_000_000_000_000_014_114_582_066_1)
                < 0.000_000_000_000_000_000_000_000_000_1
        )
    }

    @Test
    func beverageVolumeCanBeMeasuredInLiters() throws {
        let bottle = try Quantity<Double, Milliliter, Linear>(500)
        let glass = try Quantity<Double, Milliliter, Linear>(200)
        let served = try bottle - glass
        let servedInLiters = served.converted(to: Liter.self)

        #expect(abs(servedInLiters.value - 0.3) < 0.000_000_1)
    }

    @Test
    func aquariumCapacityConvertsFromLiters() throws {
        let aquarium = try Quantity<Double, Liter, Linear>(200)
        let topUp = try Quantity<Double, Milliliter, Linear>(1_500).converted(to: Liter.self)
        let totalVolume = try aquarium + topUp

        #expect(abs(totalVolume.value - 201.5) < 0.000_000_1)

        let inKiloliters = totalVolume.converted(to: Kiloliter.self)
        #expect(abs(inKiloliters.value - 0.201_5) < 0.000_000_1)
    }

    @Test
    func geographicCoordinatesUseDegreesArcminutesArcseconds() throws {
        let oneDegree = try Quantity<Double, Degree, Linear>(1)
        let inArcminutes = oneDegree.converted(to: Arcminute.self)
        let inArcseconds = oneDegree.converted(to: Arcsecond.self)

        // 1° = 60′ = 3600″
        #expect(abs(inArcminutes.value - 60) < 0.000_000_1)
        #expect(abs(inArcseconds.value - 3_600) < 0.000_000_1)

        // London latitude: 51.5074°
        let londonLatitude = try Quantity<Double, Degree, Linear>(51.5074)
        let londonArcminutes = londonLatitude.converted(to: Arcminute.self)

        #expect(abs(londonArcminutes.value - 3_090.444) < 0.000_1)
    }

    @Test
    func astronomicalParallaxUsesArcseconds() throws {
        let parallax = try Quantity<Double, Arcsecond, Linear>(1)
        let inRadians = parallax.converted(to: Radian.self)

        // 1 arcsecond ≈ 4.848e-6 radians (parallax of 1 parsec)
        #expect(abs(inRadians.value - .pi / 648_000) < 1e-20)
    }

    @Test
    func cargoShippingUsesKilotonnes() throws {
        let cargo = try Quantity<Double, Kilotonne, Linear>(15)
        let inTonnes = cargo.converted(to: Tonne.self)

        #expect(abs(inTonnes.value - 15_000) < 0.000_000_1)
    }

    @Test
    func protonRestEnergyInMegaelectronvolts() throws {
        let protonEnergy = try Quantity<Double, Megaelectronvolt, Linear>(938.272)
        let inElectronvolts = protonEnergy.converted(to: ElectronVolt.self)

        #expect(abs(inElectronvolts.value - 938_272_000) < 0.001)
    }

    @Test
    func proteinMassInKilodaltons() throws {
        let protein = try Quantity<Double, Kilodalton, Linear>(50)
        let inDaltons = protein.converted(to: Dalton.self)

        #expect(abs(inDaltons.value - 50_000) < 0.000_000_1)
    }

    @Test
    func audioSignalGainCanBeExpressedInDecibels() throws {
        // A signal at 20 dB represents a power ratio of 100.
        // 20 dB = 2 B = ln(10) Np ≈ 2.3026 Np
        let signalGain = try Quantity<Double, Decibel, Linear>(20)
        let inBels = signalGain.converted(to: Bel.self)
        let inNepers = signalGain.converted(to: Neper.self)

        #expect(abs(inBels.value - 2.0) < 0.000_000_1)
        #expect(abs(inNepers.value - 2.302_585_092_994_046) < 1e-10)
    }

    @Test
    func signalAttenuationCanBeMeasuredInDecibels() throws {
        // 3 dB attenuation represents halving of power. 3 dB = 0.3 B.
        let attenuation = try Quantity<Double, Decibel, Linear>(3)
        let inBels = attenuation.converted(to: Bel.self)

        #expect(abs(inBels.value - 0.3) < 0.000_000_1)
    }

    @Test
    func dimensionlessRatioCanBeInterpretedAsNepers() throws {
        // A dimensionless canonical quantity can be reinterpreted as nepers.
        // ln(10) ≈ 2.3026, which in nepers converts to exactly 2 B.
        let ratio = Quantity<Double, CanonicalUnit<Dimensionless>, Linear>(baseValue: 2.302_585_092_994_046)
        let asNepers = ratio.interpreted(as: Neper.self)
        let asBels = asNepers.converted(to: Bel.self)

        #expect(abs(asNepers.value - 2.302_585_092_994_046) < 1e-10)
        #expect(abs(asBels.value - 2.0) < 1e-10)
    }
}
