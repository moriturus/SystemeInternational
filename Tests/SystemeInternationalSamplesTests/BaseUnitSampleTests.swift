import Testing
import UnitesDeBaseDuSI
import UnitesSI
import UtiliseesNonSI

struct BaseUnitSampleTests {
    @Test
    func commuteDistanceAndWalkingDetourRemainReadableInMeters() throws {
        let walkToStation = try Quantity<Double, Meter, Linear>(780)
        let stationToOffice = try Quantity<Double, Meter, Linear>(1_420)
        let totalCommute = try walkToStation + stationToOffice
        let twoKilometers = try Quantity<Double, Kilometer, Linear>(2).converted(to: Meter.self)

        #expect(totalCommute.value == 2_200)
        #expect(totalCommute > twoKilometers)
    }

    @Test
    func shipmentMassesAddNaturallyInKilograms() throws {
        let copperWire = try Quantity<Double, Kilogram, Linear>(18.4)
        let packaging = try Quantity<Double, Kilogram, Linear>(1.6)
        let shipmentMass = try copperWire + packaging
        let referenceMass = try Quantity<Double, Tonne, Linear>(0.02).converted(to: Kilogram.self)

        #expect(shipmentMass.value == 20)
        #expect(shipmentMass == referenceMass)
    }

    @Test
    func stageLapTimesCanBeSummedInSeconds() throws {
        let climbSection = try Quantity<Double, Second, Linear>(1_245)
        let descentSection = try Quantity<Double, Second, Linear>(915)
        let totalElapsed = try climbSection + descentSection
        let referenceDuration = try Quantity<Double, Minute, Linear>(36).converted(to: Second.self)

        #expect(totalElapsed.value == 2_160)
        #expect(totalElapsed == referenceDuration)
    }

    @Test
    func branchCurrentsCombineInAmperes() throws {
        let laptopDock = try Quantity<Double, Ampere, Linear>(3.2)
        let monitor = try Quantity<Double, Ampere, Linear>(1.1)
        let deskLoad = try laptopDock + monitor

        #expect(abs(deskLoad.value - 4.3) < 0.000_000_1)
        #expect(deskLoad > laptopDock)
    }

    @Test
    func incubatorSetpointsCanBeComparedInKelvin() throws {
        let standby = try Quantity<Int, Kelvin, Linear>(exactly: 295)
        let activeCulture = try Quantity<Int, Kelvin, Linear>(exactly: 310)
        let temperatureRise = try activeCulture - standby

        #expect(activeCulture > standby)
        #expect(temperatureRise.exactValue == 15)
    }

    @Test
    func reagentBatchesCanBePreparedInMoles() throws {
        let buffer = try Quantity<Int, Mole, Linear>(exactly: 2)
        let catalyst = try Quantity<Int, Mole, Linear>(exactly: 1)
        let totalAmount = try buffer + catalyst

        #expect(totalAmount.exactValue == 3)
        #expect(totalAmount > catalyst)
    }

    @Test
    func lightingSpecsStayComparableInCandela() throws {
        let corridorLamp = try Quantity<Int, Candela, Linear>(exactly: 450)
        let taskLamp = try Quantity<Int, Candela, Linear>(exactly: 300)
        let combinedOutput = try corridorLamp + taskLamp

        #expect(combinedOutput.exactValue == 750)
        #expect(corridorLamp > taskLamp)
    }
}
