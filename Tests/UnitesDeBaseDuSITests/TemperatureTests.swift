import Testing

@testable import UnitesDeBaseDuSI

struct TemperatureTests {
    @Test
    func incubatorTemperatureSetpointsCanBeOrderedAndDifferenced() throws {
        let standby = try Quantity<Int, Kelvin, Linear>(exactly: 295)
        let activeRun = try Quantity<Int, Kelvin, Linear>(exactly: 310)
        let temperatureRise = try activeRun - standby

        #expect(activeRun > standby)
        #expect(temperatureRise.exactValue == 15)
        #expect(temperatureRise.baseValue == 15)
    }

    @Test
    func equalTemperatureSetpointsRemainEqual() throws {
        let setpointA = try Quantity<Int, Kelvin, Linear>(exactly: 300)
        let setpointB = try Quantity<Int, Kelvin, Linear>(exactly: 300)

        #expect(setpointA == setpointB)
        #expect(setpointA >= setpointB)
        #expect(setpointA <= setpointB)
    }

    @Test
    func subtractingTheSameTemperatureProducesZeroDifference() throws {
        let setpoint = try Quantity<Int, Kelvin, Linear>(exactly: 303)
        let difference = try setpoint - setpoint

        #expect(difference.exactValue == 0)
        #expect(difference.baseValue == 0)
    }

    @Test
    func negativeKelvinValuesRemainRepresentableInCurrentModel() throws {
        let syntheticValue = try Quantity<Int, Kelvin, Linear>(exactly: -5)
        let zeroKelvin = try Quantity<Int, Kelvin, Linear>(exactly: 0)

        #expect(syntheticValue.exactValue == -5)
        #expect(syntheticValue < zeroKelvin)
    }
}
