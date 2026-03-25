import Testing

@testable import UnitesDeBaseDuSI

struct TimeTests {
    @Test
    func scaledTimeUnitsConvertThroughSeconds() throws {
        let planningSlice = try Quantity<Double, HalfSecond, Linear>(3)
        let planningSliceInSeconds = planningSlice.converted(to: Second.self)
        let exactSlice = try Quantity<Int, HalfSecond, Linear>(exactly: 4)
        let exactSliceInSeconds = try exactSlice.convertedIfExactly(to: Second.self)

        #expect(planningSliceInSeconds.value == 1.5)
        #expect(planningSliceInSeconds.baseValue == 1.5)
        #expect(exactSlice.baseValue == 2)
        #expect(exactSliceInSeconds.exactValue == 2)
    }

    @Test
    func zeroDurationIsPreservedAcrossRepresentations() throws {
        let zeroHalfSeconds = try Quantity<Double, HalfSecond, Linear>(0)
        let zeroSeconds = zeroHalfSeconds.converted(to: Second.self)
        let zeroStoredSeconds = try Quantity<Int, Second, Linear>(exactly: 0)

        #expect(zeroSeconds.value == 0)
        #expect(zeroSeconds.baseValue == 0)
        #expect(zeroStoredSeconds.exactValue == 0)
    }

    @Test
    func negativeDurationRemainsSupportedByCurrentSemantics() throws {
        let scheduleSlip = try Quantity<Double, HalfSecond, Linear>(-3)
        let scheduleSlipInSeconds = scheduleSlip.converted(to: Second.self)

        #expect(scheduleSlipInSeconds.value == -1.5)
        #expect(scheduleSlipInSeconds.baseValue == -1.5)
        let zeroSeconds = try Quantity<Double, Second, Linear>(0)
        #expect(scheduleSlip < zeroSeconds)
    }

    @Test
    func floatingPointDurationRoundTripPreservesCanonicalValue() throws {
        let elapsed = try Quantity<Double, HalfSecond, Linear>(5.5)
        let inSeconds = elapsed.converted(to: Second.self)
        let roundTripped = inSeconds.converted(to: HalfSecond.self)

        #expect(abs(roundTripped.value - 5.5) < 0.000_000_1)
        #expect(roundTripped.baseValue == elapsed.baseValue)
    }

    @Test
    func integerExactConversionPreservesWholeHalfSecondDurations() throws {
        let twoHalfSeconds = try Quantity<Int, HalfSecond, Linear>(exactly: 2)
        let oneSecond = try twoHalfSeconds.convertedIfExactly(to: Second.self)
        let roundTripped = try oneSecond.convertedIfExactly(to: HalfSecond.self)

        #expect(oneSecond.exactValue == 1)
        #expect(roundTripped.exactValue == 2)
        #expect(roundTripped.baseValue == twoHalfSeconds.baseValue)
    }

    @Test
    func subtractingTheSameDurationProducesZero() throws {
        let recorded = try Quantity<Int, Second, Linear>(exactly: 45)
        let difference = try recorded - recorded

        #expect(difference.exactValue == 0)
        #expect(difference.baseValue == 0)
    }

    @Test
    func canonicalSecondsExpandToWholeHalfSecondCounts() throws {
        let recordedHalfSeconds = Quantity<Int, HalfSecond, Linear>(baseValue: 3)

        #expect(recordedHalfSeconds.exactValue == 6)
    }

    @Test
    func nonWholeHalfSecondInitializationFailsForIntegerStorage() throws {
        #expect(throws: QuantityError.nonIntegralConversion) {
            _ = try Quantity<Int, HalfSecond, Linear>(exactly: 1)
        }
    }
}
