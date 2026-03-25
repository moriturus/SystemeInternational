import Testing

@testable import UnitesDeBaseDuSI

private struct HalfMeter: DirectlyInitializableUnitProtocol {
    static let symbol = "half-meter"
    static let scale = try! UnitScale(numerator: 1, denominator: 2)

    typealias Dimension = LengthDimension
}

private struct DoubleMeter: DirectlyInitializableUnitProtocol {
    static let symbol = "double-meter"
    static let scale = try! UnitScale(numerator: 2, denominator: 1)

    typealias Dimension = LengthDimension
}

struct LengthTests {
    @Test
    func commuterDistanceCanBeComparedAcrossCustomLengthScales() throws {
        let commute = try Quantity<Double, DoubleMeter, Linear>(1_200)
        let scenicDetour = try Quantity<Double, Meter, Linear>(2_150)
        let commuteInMeters = commute.converted(to: Meter.self)
        let expected = try Quantity<Double, Meter, Linear>(2_400)

        #expect(commuteInMeters.value == 2_400)
        #expect(commuteInMeters.baseValue == 2_400)
        #expect(commute > scenicDetour)
        #expect(commute == expected)
    }

    @Test
    func zeroDistanceIsStableAcrossUnits() throws {
        let zeroScaledDistance = try Quantity<Double, DoubleMeter, Linear>(0)
        let zeroMeters = zeroScaledDistance.converted(to: Meter.self)
        let zero = try Quantity<Double, Meter, Linear>(0)

        #expect(zeroMeters.value == 0)
        #expect(zeroMeters.baseValue == 0)
        #expect(zeroScaledDistance == zero)
    }

    @Test
    func negativeDistanceRemainsComparableAndConvertible() throws {
        let retreat = try Quantity<Double, DoubleMeter, Linear>(-625)
        let retreatInMeters = retreat.converted(to: Meter.self)
        let zero = try Quantity<Double, Meter, Linear>(0)

        #expect(retreatInMeters.value == -1_250)
        #expect(retreatInMeters.baseValue == -1_250)
        #expect(retreat < zero)
    }

    @Test
    func customLengthScaleRoundTripPreservesMeaning() throws {
        let originalTrip = try Quantity<Double, DoubleMeter, Linear>(12.75)
        let inMeters = originalTrip.converted(to: Meter.self)
        let roundTripped = inMeters.converted(to: DoubleMeter.self)

        #expect(abs(roundTripped.value - 12.75) < 0.000_000_1)
        #expect(roundTripped.baseValue == originalTrip.baseValue)
        #expect(roundTripped == originalTrip)
    }

    @Test
    func subtractingTheSameDistanceProducesZero() throws {
        let segment = try Quantity<Double, Meter, Linear>(320)
        let difference = try segment - segment

        #expect(difference.value == 0)
        #expect(difference.baseValue == 0)
    }

    @Test
    func roadTripAverageSpeedUsesCanonicalDerivedUnits() throws {
        let distance = try Quantity<Double, Meter, Linear>(36_000)
        let travelTime = try Quantity<Double, Second, Linear>(3_600)
        let averageSpeed = try distance / travelTime

        let typedSpeed: Quantity<Double, CanonicalUnit<QuotientDimension<LengthDimension, TimeDimension>>, Linear> =
            averageSpeed

        #expect(abs(typedSpeed.baseValue - 10) < 0.000_000_1)
    }

    @Test
    func roomFloorAreaUsesCanonicalAreaDimension() throws {
        let roomLength = try Quantity<Int, Meter, Linear>(exactly: 6)
        let roomWidth = try Quantity<Int, Meter, Linear>(exactly: 3)
        let floorArea = try roomLength * roomWidth

        let typedArea: Quantity<Int, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear> =
            floorArea

        #expect(typedArea.baseValue == 18)
    }

    @Test
    func integerDistanceMayLoseExactRepresentationInFractionalUnits() throws {
        let oneMeter = try Quantity<Int, Meter, Linear>(exactly: 1)
        let halfMeterView = try oneMeter.convertedIfExactly(to: HalfMeter.self)

        #expect(halfMeterView.exactValue == 2)
        #expect(oneMeter.exactValue == 1)
        #expect(Quantity<Int, DoubleMeter, Linear>(baseValue: 1).exactValue == nil)
    }

    @Test
    func halfMeterIntegerInitializationFailsWhenStorageWouldBecomeFractional() throws {
        #expect(throws: QuantityError.nonIntegralConversion) {
            _ = try Quantity<Int, HalfMeter, Linear>(exactly: 1)
        }
    }
}
