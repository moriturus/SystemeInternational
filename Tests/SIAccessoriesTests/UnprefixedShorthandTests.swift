import Testing
import UtiliseesNonSI

@testable import SIAccessories

private func expectSameQuantity<Scalar, Unit: UnitProtocol>(
    _ actual: Quantity<Scalar, Unit, Linear>,
    equals expected: Quantity<Scalar, Unit, Linear>
) where Scalar: Equatable {
    #expect(actual == expected)
}

struct UnprefixedShorthandTests {
    @Test
    func siBaseAndDerivedUnitsUseDirectShorthand() throws {
        expectSameQuantity(try 5.0.meter, equals: try Quantity<Double, Meter, Linear>(5.0))
        expectSameQuantity(try 5.0.second, equals: try Quantity<Double, Second, Linear>(5.0))
        expectSameQuantity(try 5.0.ampere, equals: try Quantity<Double, Ampere, Linear>(5.0))
        expectSameQuantity(try 5.0.kelvin, equals: try Quantity<Double, Kelvin, Linear>(5.0))
        expectSameQuantity(try 5.0.mole, equals: try Quantity<Double, Mole, Linear>(5.0))
        expectSameQuantity(try 5.0.candela, equals: try Quantity<Double, Candela, Linear>(5.0))

        expectSameQuantity(try 5.0.gram, equals: try Quantity<Double, Gram, Linear>(5.0))
        expectSameQuantity(try 5.0.kilogram, equals: try Quantity<Double, Kilogram, Linear>(5.0))
        expectSameQuantity(try 5.0.newton, equals: try Quantity<Double, Newton, Linear>(5.0))
        expectSameQuantity(try 5.0.pascal, equals: try Quantity<Double, Pascal, Linear>(5.0))
        expectSameQuantity(try 5.0.joule, equals: try Quantity<Double, Joule, Linear>(5.0))
        expectSameQuantity(try 5.0.watt, equals: try Quantity<Double, Watt, Linear>(5.0))
        expectSameQuantity(try 5.0.coulomb, equals: try Quantity<Double, Coulomb, Linear>(5.0))
        expectSameQuantity(try 5.0.volt, equals: try Quantity<Double, Volt, Linear>(5.0))
        expectSameQuantity(try 5.0.farad, equals: try Quantity<Double, Farad, Linear>(5.0))
        expectSameQuantity(try 5.0.ohm, equals: try Quantity<Double, Ohm, Linear>(5.0))
        expectSameQuantity(try 5.0.siemens, equals: try Quantity<Double, Siemens, Linear>(5.0))
        expectSameQuantity(try 5.0.weber, equals: try Quantity<Double, Weber, Linear>(5.0))
        expectSameQuantity(try 5.0.tesla, equals: try Quantity<Double, Tesla, Linear>(5.0))
        expectSameQuantity(try 5.0.henry, equals: try Quantity<Double, Henry, Linear>(5.0))
        expectSameQuantity(try 5.0.lumen, equals: try Quantity<Double, Lumen, Linear>(5.0))
        expectSameQuantity(try 5.0.lux, equals: try Quantity<Double, Lux, Linear>(5.0))
        expectSameQuantity(try 5.0.katal, equals: try Quantity<Double, Katal, Linear>(5.0))
        expectSameQuantity(try 5.0.hertz, equals: try Quantity<Double, Hertz, Linear>(5.0))
        expectSameQuantity(try 5.0.becquerel, equals: try Quantity<Double, Becquerel, Linear>(5.0))
        expectSameQuantity(try 5.0.gray, equals: try Quantity<Double, Gray, Linear>(5.0))
        expectSameQuantity(try 5.0.sievert, equals: try Quantity<Double, Sievert, Linear>(5.0))
    }

    @Test
    func acceptedNonSiUnitsUseDirectShorthand() throws {
        expectSameQuantity(try 2.0.tonne, equals: try Quantity<Double, Tonne, Linear>(2.0))
        expectSameQuantity(try 2.0.dalton, equals: try Quantity<Double, Dalton, Linear>(2.0))
        expectSameQuantity(try 2.0.electronVolt, equals: try Quantity<Double, ElectronVolt, Linear>(2.0))
        expectSameQuantity(try 2.0.liter, equals: try Quantity<Double, Liter, Linear>(2.0))
        expectSameQuantity(try 2.0.bel, equals: try Quantity<Double, Bel, Linear>(2.0))

        expectSameQuantity(try 2.0.minute, equals: try Quantity<Double, Minute, Linear>(2.0))
        expectSameQuantity(try 2.0.hour, equals: try Quantity<Double, Hour, Linear>(2.0))
        expectSameQuantity(try 2.0.day, equals: try Quantity<Double, Day, Linear>(2.0))
        expectSameQuantity(try 2.0.hectare, equals: try Quantity<Double, Hectare, Linear>(2.0))
        expectSameQuantity(try 2.0.astronomicalUnit, equals: try Quantity<Double, AstronomicalUnit, Linear>(2.0))
        expectSameQuantity(try 2.0.degree, equals: try Quantity<Double, Degree, Linear>(2.0))
        expectSameQuantity(try 2.0.arcminute, equals: try Quantity<Double, Arcminute, Linear>(2.0))
        expectSameQuantity(try 2.0.arcsecond, equals: try Quantity<Double, Arcsecond, Linear>(2.0))
    }

    @Test
    func semanticUnitsRemainAvailableAsDirectShorthand() throws {
        expectSameQuantity(try 1.0.radian, equals: try Quantity<Double, Radian, Linear>(1.0))
        expectSameQuantity(try 1.0.steradian, equals: try Quantity<Double, Steradian, Linear>(1.0))
        expectSameQuantity(try 1.0.neper, equals: try Quantity<Double, Neper, Linear>(1.0))
    }

    @Test
    func floatingPointScalarVariantsShareTheSameSurface() throws {
        let duration: Quantity<Float, Minute, Linear> = try Float(2.5).minute
        let distance: Quantity<Float, Meter, Linear> = try Float(12).meter
        let angle: Quantity<Float, Radian, Linear> = try Float.pi.radian

        #expect(duration.value == 2.5)
        #expect(distance.value == 12)
        #expect(abs(angle.value - .pi) < 0.000_001)
    }

    @Test
    func integerShorthandDefaultsToDoubleQuantities() throws {
        let distance: Quantity<Double, Meter, Linear> = try 12.meter
        let duration: Quantity<Double, Minute, Linear> = try 3.minute
        let angle: Quantity<Double, Radian, Linear> = try 1.radian

        #expect(distance.value == 12.0)
        #expect(duration.value == 3.0)
        #expect(angle.value == 1.0)
    }
}
