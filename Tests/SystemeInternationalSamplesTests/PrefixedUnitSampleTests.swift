import PrefixesDuSI
import Testing
import UnitesDeBaseDuSI
import UtiliseesNonSI

struct PrefixedUnitSampleTests {
    @Test
    func runningRouteIsConvenientInKilometers() throws {
        let easyRun = try Quantity<Double, Kilometer, Linear>(8.2)
        let warmup = try Quantity<Double, Meter, Linear>(600).converted(to: Kilometer.self)
        let totalDistance = try easyRun + warmup

        #expect(abs(totalDistance.value - 8.8) < 0.000_000_1)
    }

    @Test
    func cameraExposureIsConvenientInMilliseconds() throws {
        let shutterOpen = try Quantity<Double, Millisecond, Linear>(16.7)
        let shutterOpenInSeconds = shutterOpen.converted(to: Second.self)

        #expect(abs(shutterOpenInSeconds.value - 0.0167) < 0.000_000_1)
    }

    @Test
    func sensorBiasCurrentCanBeReadInMicroamperes() throws {
        let sleepCurrent = try Quantity<Double, Microampere, Linear>(85)
        let sleepCurrentInAmperes = sleepCurrent.converted(to: Ampere.self)

        #expect(abs(sleepCurrentInAmperes.value - 0.000_085) < 0.000_000_000_1)
    }

    @Test
    func assayConcentrationCanUseMillimoles() throws {
        let solute = try Quantity<Double, Millimole, Linear>(2.5)
        let soluteInMoles = solute.converted(to: Mole.self)

        #expect(abs(soluteInMoles.value - 0.0025) < 0.000_000_1)
    }

    @Test
    func supplementDoseCanBeMeasuredInMilligrams() throws {
        let tablet = try Quantity<Double, Milligram, Linear>(250)
        let tabletInGrams = tablet.converted(to: Gram.self)

        #expect(abs(tabletInGrams.value - 0.25) < 0.000_000_1)
    }

    @Test
    func weatherReportPressureCanUseKilopascals() throws {
        let stationPressure = try Quantity<Double, Kilopascal, Linear>(101.3)
        let stationPressureInPascals = stationPressure.converted(to: Pascal.self)

        #expect(abs(stationPressureInPascals.value - 101_300) < 0.000_000_1)
    }

    @Test
    func foodEnergyCanUseKilojoules() throws {
        let snack = try Quantity<Double, Kilojoule, Linear>(870)
        let snackInJoules = snack.converted(to: Joule.self)

        #expect(abs(snackInJoules.value - 870_000) < 0.000_000_1)
    }

    @Test
    func timingCapacitorCanUseMicrofarads() throws {
        let timingCapacitor = try Quantity<Double, Microfarad, Linear>(4.7)
        let timingCapacitorInFarads = timingCapacitor.converted(to: Farad.self)

        #expect(abs(timingCapacitorInFarads.value - 0.000_004_7) < 0.000_000_000_000_1)
    }

    @Test
    func pickupCoilFluxCanUseMicrowebers() throws {
        let stringVibrationFlux = try Quantity<Double, Microweber, Linear>(320)
        let stringVibrationFluxInWebers = stringVibrationFlux.converted(to: Weber.self)

        #expect(abs(stringVibrationFluxInWebers.value - 0.000_32) < 0.000_000_000_1)
    }

    @Test
    func warehouseLightingTargetCanUseKilolux() throws {
        let inspectionBench = try Quantity<Double, Kilolux, Linear>(1.2)
        let inspectionBenchInLux = inspectionBench.converted(to: Lux.self)

        #expect(abs(inspectionBenchInLux.value - 1_200) < 0.000_000_1)
    }

    @Test
    func enzymeTraceActivityCanUseMicrokatal() throws {
        let sampleActivity = try Quantity<Double, Microkatal, Linear>(42)
        let sampleActivityInKatal = sampleActivity.converted(to: Katal.self)

        #expect(abs(sampleActivityInKatal.value - 0.000_042) < 0.000_000_000_1)
    }
}
