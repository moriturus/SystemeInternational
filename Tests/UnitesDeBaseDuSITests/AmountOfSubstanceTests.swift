import Testing

@testable import UnitesDeBaseDuSI

struct AmountOfSubstanceTests {
    @Test
    func reagentBatchesCanBeCombinedInMoles() throws {
        let firstBatch = try Quantity<Int, Mole, Linear>(exactly: 2)
        let secondBatch = try Quantity<Int, Mole, Linear>(exactly: 3)
        let totalAmount = try firstBatch + secondBatch

        #expect(totalAmount.exactValue == 5)
        #expect(totalAmount.baseValue == 5)
        #expect(totalAmount > firstBatch)
    }

    @Test
    func zeroMolesBehaveAsAdditiveIdentity() throws {
        let referenceBatch = try Quantity<Int, Mole, Linear>(exactly: 6)
        let zeroBatch = try Quantity<Int, Mole, Linear>(exactly: 0)

        #expect(try (referenceBatch + zeroBatch).exactValue == 6)
        #expect(try (referenceBatch - referenceBatch).exactValue == 0)
    }

    @Test
    func equalMoleAmountsCompareAsEqual() throws {
        let sampleA = try Quantity<Int, Mole, Linear>(exactly: 4)
        let sampleB = try Quantity<Int, Mole, Linear>(exactly: 4)

        #expect(sampleA == sampleB)
        #expect(sampleA >= sampleB)
        #expect(sampleA <= sampleB)
    }

    @Test
    func negativeMoleAmountsRemainRepresentable() throws {
        let correction = try Quantity<Int, Mole, Linear>(exactly: -1)
        let zeroMoles = try Quantity<Int, Mole, Linear>(exactly: 0)

        #expect(correction.exactValue == -1)
        #expect(correction < zeroMoles)
    }
}
