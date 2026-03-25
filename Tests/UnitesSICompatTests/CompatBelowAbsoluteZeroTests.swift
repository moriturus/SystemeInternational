import CompatSupport
import Foundation
import Testing
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI
import UnitesSI

@testable import UnitesSICompat

struct CompatBelowAbsoluteZeroTests {
    @Test
    func belowAbsoluteZeroCelsiusThrowsCompatibilityError() throws {
        let measurement = Measurement(value: -274, unit: UnitTemperature.celsius)

        #expect(throws: CompatibilityError.semanticMismatch) {
            _ = try measurement.absoluteTemperature(as: DegreeCelsius.self)
        }
    }

    @Test
    func belowAbsoluteZeroKelvinThrowsCompatibilityError() throws {
        let measurement = Measurement(value: -1, unit: UnitTemperature.kelvin)

        #expect(throws: CompatibilityError.semanticMismatch) {
            _ = try measurement.absoluteTemperature(as: Kelvin.self)
        }
    }

    @Test
    func justAboveAbsoluteZeroSucceeds() throws {
        let measurement = Measurement(value: -273, unit: UnitTemperature.celsius)
        let result = try measurement.absoluteTemperature(as: DegreeCelsius.self)

        #expect(abs(result.value - (-273)) < 0.000_000_1)
    }

    @Test
    func exactAbsoluteZeroSucceeds() throws {
        let measurement = Measurement(value: 0, unit: UnitTemperature.kelvin)
        let result = try measurement.absoluteTemperature(as: Kelvin.self)

        #expect(result.value == 0)
    }
}
