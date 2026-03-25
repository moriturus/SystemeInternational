import Testing

@testable import SIAccessories

struct EdgeCaseTests {
    @Test
    func representativeShorthandPathsAlwaysProduceLinearQuantities() throws {
        let _: Quantity<Double, Meter, Linear> = try 5.0.meter
        let _: Quantity<Double, Gram, Linear> = try 20.0.gram
        let _: Quantity<Double, Kilogram, Linear> = try 20.0.kilogram
        let _: Quantity<Double, SIPrefixedUnit<Gram, Kilo>, Linear> = try 1.0.kilo.gram
        let _: Quantity<Double, Hertz, Linear> = try 1.0.hertz
        let _: Quantity<Double, SIPrefixedUnit<Sievert, Micro>, Linear> = try 2.0.micro.sievert
        let _: Quantity<Double, Kelvin, Linear> = try 3.0.kelvin
    }

    @Test
    func extremePrefixesPreserveExpectedMagnitudes() throws {
        let enormousPower = try 1.0.quetta.watt.converted(to: Watt.self).value
        let tinyLength = try 1.0.quecto.meter.converted(to: Meter.self).value

        #expect(abs((enormousPower - 1e30) / 1e30) < 0.000_000_000_001)
        #expect(abs((tinyLength - 1e-30) / 1e-30) < 0.000_000_000_001)
    }

    @Test
    func nonFiniteInputsArePropagatedToCallers() {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Double.infinity.meter
        }

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Double.nan.kilo.hertz
        }
    }
}
