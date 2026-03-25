import Foundation
import Testing
import UnitesSI
import UnitesSICompat
import UtiliseesNonSICompat

struct CompatImportCoexistenceTests {
    @Test
    func siAndAcceptedCompatModulesCanBeImportedTogether() throws {
        let distance = try Quantity<Double, Kilometer, Linear>(1.2).foundationMeasurement()
        let duration = try Quantity<Double, Minute, Linear>(30).foundationMeasurement()
        let siLength = try Measurement(value: 3, unit: UnitLength.meters).siQuantity(as: Meter.self)
        let acceptedDuration = try Measurement(value: 2, unit: UnitDuration.hours).siQuantity(as: Hour.self)
        let room = try Measurement(value: 25, unit: UnitTemperature.celsius).absoluteTemperature(as: DegreeCelsius.self)

        #expect(distance.unit.symbol == "km")
        #expect(duration.unit.symbol == "min")
        #expect(siLength.value == 3)
        #expect(acceptedDuration.value == 2)
        #expect(abs(room.converted(to: Kelvin.self).value - 298.15) < 0.000_000_1)
    }
}
