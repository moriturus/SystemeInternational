import Testing

@testable import SIAccessories

struct SemanticUnitTests {
    @Test
    func explicitSemanticNamesRemainVisibleInReturnedTypes() throws {
        let frequency: Quantity<Double, Hertz, Linear> = try 1.0.hertz
        let activity: Quantity<Double, Becquerel, Linear> = try 1.0.becquerel
        let absorbedDose: Quantity<Double, Gray, Linear> = try 1.0.gray
        let equivalentDose: Quantity<Double, Sievert, Linear> = try 1.0.sievert
        let planeAngle: Quantity<Double, Radian, Linear> = try 1.0.radian
        let solidAngle: Quantity<Double, Steradian, Linear> = try 1.0.steradian
        let logarithmicRatio: Quantity<Double, Neper, Linear> = try 1.0.neper

        #expect(frequency.value == 1.0)
        #expect(activity.value == 1.0)
        #expect(absorbedDose.value == 1.0)
        #expect(equivalentDose.value == 1.0)
        #expect(planeAngle.value == 1.0)
        #expect(solidAngle.value == 1.0)
        #expect(logarithmicRatio.value == 1.0)
    }

    @Test
    func prefixedSemanticSIEndpointsProduceExpectedValues() throws {
        let frequency = try 10.0.kilo.hertz
        let activity = try 11.0.mega.becquerel
        let absorbedDose = try 12.0.milli.gray
        let equivalentDose = try 13.0.micro.sievert

        #expect(frequency.converted(to: Hertz.self).value == 10_000.0)
        #expect(activity.converted(to: Becquerel.self).value == 11_000_000.0)
        #expect(abs(absorbedDose.converted(to: Gray.self).value - 0.012) < 0.000_000_000_1)
        #expect(abs(equivalentDose.converted(to: Sievert.self).value - 0.000_013) < 0.000_000_000_1)
    }

    @Test
    func prefixedNonSIEndpointsProduceExpectedValues() throws {
        let shipment = try 2.0.kilo.tonne
        let particleMass = try 3.0.mega.dalton
        let beamEnergy = try 4.0.giga.electronVolt
        let sampleVolume = try 5.0.micro.liter
        let signal = try 6.0.deci.bel

        #expect(shipment.converted(to: Tonne.self).value == 2_000.0)
        #expect(abs(particleMass.converted(to: Dalton.self).value - 3_000_000.0) < 0.000_001)
        #expect(abs(beamEnergy.converted(to: ElectronVolt.self).value - 4_000_000_000.0) < 0.001)
        #expect(abs(sampleVolume.converted(to: Liter.self).value - 0.000_005) < 0.000_000_000_1)
        #expect(abs(signal.converted(to: Bel.self).value - 0.6) < 0.000_000_000_1)
    }
}
