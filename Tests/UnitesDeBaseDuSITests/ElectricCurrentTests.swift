import Testing

@testable import UnitesDeBaseDuSI

struct ElectricCurrentTests {
    @Test
    func chargerCurrentsCanBeComparedAndSummed() throws {
        let laptopCharger = try Quantity<Int, Ampere, Linear>(exactly: 5)
        let phoneCharger = try Quantity<Int, Ampere, Linear>(exactly: 3)
        let combinedDraw = try laptopCharger + phoneCharger

        #expect(laptopCharger > phoneCharger)
        #expect(combinedDraw.exactValue == 8)
        #expect(combinedDraw.baseValue == 8)
    }

    @Test
    func zeroCurrentActsAsAdditiveIdentity() throws {
        let circuitLoad = try Quantity<Int, Ampere, Linear>(exactly: 7)
        let zeroLoad = try Quantity<Int, Ampere, Linear>(exactly: 0)

        #expect(try (circuitLoad + zeroLoad).exactValue == 7)
        #expect(try (circuitLoad - circuitLoad).exactValue == 0)
    }

    @Test
    func equalCurrentsCompareAsEqual() throws {
        let branchA = try Quantity<Int, Ampere, Linear>(exactly: 4)
        let branchB = try Quantity<Int, Ampere, Linear>(exactly: 4)

        #expect(branchA == branchB)
        #expect(branchA >= branchB)
        #expect(branchA <= branchB)
    }

    @Test
    func negativeCurrentRemainsRepresentable() throws {
        let correctiveCurrent = try Quantity<Int, Ampere, Linear>(exactly: -2)
        let zeroCurrent = try Quantity<Int, Ampere, Linear>(exactly: 0)

        #expect(correctiveCurrent.exactValue == -2)
        #expect(correctiveCurrent < zeroCurrent)
    }
}
