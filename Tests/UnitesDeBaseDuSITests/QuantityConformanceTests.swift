import Testing

@testable import UnitesDeBaseDuSI

private struct Thousandth: DirectlyInitializableUnitProtocol {
    static let symbol = "km"
    static let scale = try! UnitScale(numerator: 1_000, denominator: 1)

    typealias Dimension = LengthDimension
}

// MARK: - Float Scalar Tests

struct FloatQuantityTests {
    @Test
    func floatQuantityArithmeticProducesExpectedResults() throws {
        let d1 = try Quantity<Float, Meter, Linear>(1.5)
        let d2 = try Quantity<Float, Meter, Linear>(2.5)
        let sum = try d1 + d2

        #expect(abs(sum.value - 4.0) < 0.001)
    }

    @Test
    func floatQuantitySubtractionProducesExpectedResults() throws {
        let d1 = try Quantity<Float, Meter, Linear>(5.0)
        let d2 = try Quantity<Float, Meter, Linear>(2.5)
        let diff = try d1 - d2

        #expect(abs(diff.value - 2.5) < 0.001)
    }

    @Test
    func floatQuantityConversionMaintainsReasonablePrecision() throws {
        let oneKm = try Quantity<Float, Thousandth, Linear>(1.0)
        let inMeters = oneKm.converted(to: Meter.self)

        #expect(abs(inMeters.value - 1_000.0) < 0.1)
    }

    @Test
    func floatQuantityConversionRoundTripPreservesMeaning() throws {
        let original = try Quantity<Float, Thousandth, Linear>(3.5)
        let inMeters = original.converted(to: Meter.self)
        let roundTripped = inMeters.converted(to: Thousandth.self)

        #expect(abs(roundTripped.value - 3.5) < 0.001)
    }

    @Test
    func floatQuantityMultiplicationProducesCanonicalDerivedUnit() throws {
        let distance = try Quantity<Float, Meter, Linear>(10.0)
        let time = try Quantity<Float, Second, Linear>(2.0)
        let speed = try distance / time

        let typedSpeed: Quantity<Float, CanonicalUnit<QuotientDimension<LengthDimension, TimeDimension>>, Linear> =
            speed

        #expect(abs(typedSpeed.baseValue - 5.0) < 0.001)
    }

    @Test
    func floatQuantityEqualityWorksAcrossUnits() throws {
        let scaled = try Quantity<Float, Thousandth, Linear>(2.0)
        let base = try Quantity<Float, Meter, Linear>(2_000.0)

        #expect(scaled == base)
    }
}

// MARK: - Int64 Scalar Tests

struct Int64QuantityTests {
    @Test
    func int64QuantityHandlesLargeValues() throws {
        let large = try Quantity<Int64, Meter, Linear>(exactly: 1_000_000_000_000)
        let small = try Quantity<Int64, Meter, Linear>(exactly: 1)
        let sum = try large + small

        #expect(sum.baseValue == 1_000_000_000_001)
    }

    @Test
    func int64QuantityOverflowReportsTypedFailure() throws {
        let maxMeters = try Quantity<Int64, Meter, Linear>(exactly: .max)
        let oneMeter = try Quantity<Int64, Meter, Linear>(exactly: 1)

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try maxMeters + oneMeter
        }
    }

    @Test
    func int64QuantityUnderflowReportsTypedFailure() throws {
        let minMeters = try Quantity<Int64, Meter, Linear>(exactly: .min)
        let oneMeter = try Quantity<Int64, Meter, Linear>(exactly: 1)

        #expect(throws: QuantityError.arithmeticOverflow) {
            _ = try minMeters - oneMeter
        }
    }

    @Test
    func int64QuantityDivisionByZeroReportsTypedFailure() throws {
        let oneMeter = try Quantity<Int64, Meter, Linear>(exactly: 1)
        let zeroSeconds = try Quantity<Int64, Second, Linear>(exactly: 0)

        #expect(throws: QuantityError.divisionByZero) {
            _ = try oneMeter / zeroSeconds
        }
    }

    @Test
    func int64QuantityExactDivisionSucceeds() throws {
        let eightMeters = try Quantity<Int64, Meter, Linear>(exactly: 8)
        let twoSeconds = try Quantity<Int64, Second, Linear>(exactly: 2)
        let rate = try eightMeters / twoSeconds

        #expect(rate.baseValue == 4)
    }
}

// MARK: - Non-Finite Value Tests

struct NonFiniteQuantityTests {
    @Test
    func nanQuantityInitializationIsRejected() {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Meter, Linear>(.nan)
        }
    }

    @Test
    func infiniteQuantityInitializationIsRejected() {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Double, Meter, Linear>(.infinity)
        }
    }

    @Test
    func floatNanInitializationIsRejected() {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Float, Meter, Linear>(.nan)
        }
    }

    @Test
    func floatInfinityInitializationIsRejected() {
        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try Quantity<Float, Meter, Linear>(.infinity)
        }
    }

    @Test
    func divisionByZeroIsRejected() throws {
        let one = try Quantity<Double, Meter, Linear>(1.0)
        let zero = try Quantity<Double, Second, Linear>(0.0)

        #expect(throws: QuantityError.divisionByZero) {
            _ = try one / zero
        }
    }

    @Test
    func multiplicationOverflowIsRejected() throws {
        let lhs = try Quantity<Double, Meter, Linear>(Double.greatestFiniteMagnitude)
        let rhs = try Quantity<Double, Second, Linear>(2)

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try lhs * rhs
        }
    }

    @Test
    func additionOverflowIsRejected() throws {
        let lhs = try Quantity<Double, Meter, Linear>(Double.greatestFiniteMagnitude)
        let rhs = try Quantity<Double, Meter, Linear>(Double.greatestFiniteMagnitude)

        #expect(throws: QuantityError.nonFiniteValue) {
            _ = try lhs + rhs
        }
    }
}

// MARK: - Comparable Conformance Tests

struct ComparableConformanceTests {
    @Test
    func quantitiesOfSameUnitAreComparable() throws {
        let small = try Quantity<Double, Meter, Linear>(1.0)
        let large = try Quantity<Double, Meter, Linear>(5.0)

        #expect(small < large)
        #expect(large > small)
        #expect(small <= small)
        #expect(large >= large)

        let sorted = [large, small].sorted()

        #expect(sorted.first!.value < sorted.last!.value)
    }

    @Test
    func integerQuantitiesAreComparable() throws {
        let a = try Quantity<Int, Meter, Linear>(exactly: 3)
        let b = try Quantity<Int, Meter, Linear>(exactly: 7)

        #expect(a < b)
        #expect(min(a, b) == a)
        #expect(max(a, b) == b)
    }

    @Test
    func sortingQuantitiesProducesExpectedOrder() throws {
        let values = [
            try Quantity<Double, Meter, Linear>(3.0),
            try Quantity<Double, Meter, Linear>(1.0),
            try Quantity<Double, Meter, Linear>(4.0),
            try Quantity<Double, Meter, Linear>(1.5),
            try Quantity<Double, Meter, Linear>(2.0),
        ]
        let sorted = values.sorted()

        #expect(sorted.map(\.value) == [1.0, 1.5, 2.0, 3.0, 4.0])
    }

    @Test
    func negativeQuantitiesAreLessThanPositive() throws {
        let negative = try Quantity<Double, Meter, Linear>(-10.0)
        let positive = try Quantity<Double, Meter, Linear>(1.0)

        #expect(negative < positive)
    }

    @Test
    func int64QuantitiesAreComparable() throws {
        let small = try Quantity<Int64, Meter, Linear>(exactly: 100)
        let large = try Quantity<Int64, Meter, Linear>(exactly: 9_999_999_999)

        #expect(small < large)
        #expect(min(small, large) == small)
        #expect(max(small, large) == large)
    }
}

// MARK: - Hashable Conformance Tests

struct HashableConformanceTests {
    @Test
    func quantitiesWithSameValueHaveSameHash() throws {
        let a = try Quantity<Double, Meter, Linear>(42.0)
        let b = try Quantity<Double, Meter, Linear>(42.0)

        #expect(a.hashValue == b.hashValue)
    }

    @Test
    func quantitiesCanBeUsedAsSetElements() throws {
        let q1 = try Quantity<Double, Meter, Linear>(1.0)
        let q2 = try Quantity<Double, Meter, Linear>(2.0)
        let q3 = try Quantity<Double, Meter, Linear>(1.0)
        let set: Set<Quantity<Double, Meter, Linear>> = [q1, q2, q3]

        #expect(set.count == 2)
    }

    @Test
    func quantitiesCanBeUsedAsDictionaryKeys() throws {
        let key = try Quantity<Int, Meter, Linear>(exactly: 5)
        let dict: [Quantity<Int, Meter, Linear>: String] = [key: "five meters"]

        #expect(dict[key] == "five meters")
    }

    @Test
    func floatQuantitiesWithSameValueHaveSameHash() throws {
        let a = try Quantity<Float, Meter, Linear>(7.5)
        let b = try Quantity<Float, Meter, Linear>(7.5)

        #expect(a.hashValue == b.hashValue)
    }

    @Test
    func int64QuantitiesCanBeUsedAsSetElements() throws {
        let a = try Quantity<Int64, Meter, Linear>(exactly: 100)
        let b = try Quantity<Int64, Meter, Linear>(exactly: 200)
        let c = try Quantity<Int64, Meter, Linear>(exactly: 100)
        let set: Set<Quantity<Int64, Meter, Linear>> = [a, b, c]

        #expect(set.count == 2)
    }

    @Test
    func distinctValuesProduceDistinctSetEntries() throws {
        let quantities = try (1...10).map { try Quantity<Double, Meter, Linear>(Double($0)) }
        let set = Set(quantities)

        #expect(set.count == 10)
    }
}
