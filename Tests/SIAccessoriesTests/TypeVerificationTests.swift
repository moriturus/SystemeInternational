import Testing

@testable import SIAccessories

struct TypeVerificationTests {
    @Test
    func prefixedScalarStoresItsScalarAndIsConstructible() {
        let scalar = PrefixedScalar<Double, Kilo>(value: 12.5)

        #expect(scalar.value == 12.5)
    }

    @Test
    func prefixedScalarConformsToSendable() {
        func requireSendable<T: Sendable>(_: T.Type) {}

        requireSendable(PrefixedScalar<Double, Mega>.self)
    }

    @Test
    func representativePrefixedChainsHaveExpectedStaticTypes() throws {
        let distance: Quantity<Double, SIPrefixedUnit<Meter, Kilo>, Linear> = try 10.0.kilo.meter
        let mass: Quantity<Double, SIPrefixedUnit<Gram, Milli>, Linear> = try 20.0.milli.gram
        let volume: Quantity<Double, SIPrefixedUnit<Liter, Milli>, Linear> = try 1.5.milli.liter
        let power: Quantity<Double, SIPrefixedUnit<Watt, Mega>, Linear> = try 3.0.mega.watt
        let frequency: Quantity<Double, SIPrefixedUnit<Hertz, Kilo>, Linear> = try 10.0.kilo.hertz
        let radiationDose: Quantity<Double, SIPrefixedUnit<Gray, Micro>, Linear> = try 2.0.micro.gray
        let signalLevel: Quantity<Double, SIPrefixedUnit<Bel, Deci>, Linear> = try 1.0.deci.bel
        let particleMass: Quantity<Double, SIPrefixedUnit<Dalton, Kilo>, Linear> = try 4.0.kilo.dalton
        let beamEnergy: Quantity<Double, SIPrefixedUnit<ElectronVolt, Mega>, Linear> = try 5.0.mega.electronVolt
        let shipment: Quantity<Double, SIPrefixedUnit<Tonne, Kilo>, Linear> = try 6.0.kilo.tonne

        #expect(distance.value == 10.0)
        #expect(mass.value == 20.0)
        #expect(volume.value == 1.5)
        #expect(power.value == 3.0)
        #expect(frequency.value == 10.0)
        #expect(radiationDose.value == 2.0)
        #expect(signalLevel.value == 1.0)
        #expect(particleMass.value == 4.0)
        #expect(abs(beamEnergy.value - 5.0) < 0.000_000_000_1)
        #expect(shipment.value == 6.0)
    }

    @Test
    func prefixedUnitEndpointsExistAcrossTheSupportedSurface() throws {
        let _: Quantity<Double, SIPrefixedUnit<Meter, Kilo>, Linear> = try 1.0.kilo.meter
        let _: Quantity<Double, SIPrefixedUnit<Second, Kilo>, Linear> = try 1.0.kilo.second
        let _: Quantity<Double, SIPrefixedUnit<Ampere, Kilo>, Linear> = try 1.0.kilo.ampere
        let _: Quantity<Double, SIPrefixedUnit<Kelvin, Kilo>, Linear> = try 1.0.kilo.kelvin
        let _: Quantity<Double, SIPrefixedUnit<Mole, Kilo>, Linear> = try 1.0.kilo.mole
        let _: Quantity<Double, SIPrefixedUnit<Candela, Kilo>, Linear> = try 1.0.kilo.candela
        let _: Quantity<Double, SIPrefixedUnit<Gram, Kilo>, Linear> = try 1.0.kilo.gram
        let _: Quantity<Double, SIPrefixedUnit<Newton, Kilo>, Linear> = try 1.0.kilo.newton
        let _: Quantity<Double, SIPrefixedUnit<Pascal, Kilo>, Linear> = try 1.0.kilo.pascal
        let _: Quantity<Double, SIPrefixedUnit<Joule, Kilo>, Linear> = try 1.0.kilo.joule
        let _: Quantity<Double, SIPrefixedUnit<Watt, Kilo>, Linear> = try 1.0.kilo.watt
        let _: Quantity<Double, SIPrefixedUnit<Coulomb, Kilo>, Linear> = try 1.0.kilo.coulomb
        let _: Quantity<Double, SIPrefixedUnit<Volt, Kilo>, Linear> = try 1.0.kilo.volt
        let _: Quantity<Double, SIPrefixedUnit<Farad, Kilo>, Linear> = try 1.0.kilo.farad
        let _: Quantity<Double, SIPrefixedUnit<Ohm, Kilo>, Linear> = try 1.0.kilo.ohm
        let _: Quantity<Double, SIPrefixedUnit<Siemens, Kilo>, Linear> = try 1.0.kilo.siemens
        let _: Quantity<Double, SIPrefixedUnit<Weber, Kilo>, Linear> = try 1.0.kilo.weber
        let _: Quantity<Double, SIPrefixedUnit<Tesla, Kilo>, Linear> = try 1.0.kilo.tesla
        let _: Quantity<Double, SIPrefixedUnit<Henry, Kilo>, Linear> = try 1.0.kilo.henry
        let _: Quantity<Double, SIPrefixedUnit<Lumen, Kilo>, Linear> = try 1.0.kilo.lumen
        let _: Quantity<Double, SIPrefixedUnit<Lux, Kilo>, Linear> = try 1.0.kilo.lux
        let _: Quantity<Double, SIPrefixedUnit<Katal, Kilo>, Linear> = try 1.0.kilo.katal
        let _: Quantity<Double, SIPrefixedUnit<Hertz, Kilo>, Linear> = try 1.0.kilo.hertz
        let _: Quantity<Double, SIPrefixedUnit<Becquerel, Kilo>, Linear> = try 1.0.kilo.becquerel
        let _: Quantity<Double, SIPrefixedUnit<Gray, Kilo>, Linear> = try 1.0.kilo.gray
        let _: Quantity<Double, SIPrefixedUnit<Sievert, Kilo>, Linear> = try 1.0.kilo.sievert
        let _: Quantity<Double, SIPrefixedUnit<Tonne, Kilo>, Linear> = try 1.0.kilo.tonne
        let _: Quantity<Double, SIPrefixedUnit<Dalton, Kilo>, Linear> = try 1.0.kilo.dalton
        let _: Quantity<Double, SIPrefixedUnit<ElectronVolt, Kilo>, Linear> = try 1.0.kilo.electronVolt
        let _: Quantity<Double, SIPrefixedUnit<Liter, Kilo>, Linear> = try 1.0.kilo.liter
        let _: Quantity<Double, SIPrefixedUnit<Bel, Kilo>, Linear> = try 1.0.kilo.bel
    }
}
