/// Errors that can occur while constructing or combining unit scales.
public enum UnitScaleError: Error, Equatable, Sendable {
    /// The requested scale is structurally invalid.
    case invalidScale
    /// The requested scale cannot be represented without overflow.
    case arithmeticOverflow
}

/// Describes a rational scale factor between a unit and its canonical base unit.
public struct UnitScale: Sendable, Equatable {
    /// The numerator of the scale factor.
    public let numerator: Int
    /// The denominator of the scale factor.
    public let denominator: Int
    /// The decimal exponent applied after the rational factor.
    public let decimalExponent: Int

    /// The identity scale for canonical base units.
    public static let identity = Self.assumeValid(
        numerator: 1,
        denominator: 1,
        decimalExponent: 0,
        reason: "The canonical identity scale must remain structurally valid."
    )

    /// Creates a scale from a rational factor.
    public init(numerator: Int, denominator: Int, decimalExponent: Int = 0) throws {
        let normalized = try Self.normalize(
            numerator: numerator,
            denominator: denominator,
            decimalExponent: decimalExponent
        )
        self.numerator = normalized.numerator
        self.denominator = normalized.denominator
        self.decimalExponent = normalized.decimalExponent
    }

    package init(uncheckedNumerator numerator: Int, denominator: Int, decimalExponent: Int = 0) {
        let normalized = Self.assumeNormalized(
            numerator: numerator,
            denominator: denominator,
            decimalExponent: decimalExponent,
            reason: "Unchecked unit scales are reserved for package-defined constants."
        )
        self.numerator = normalized.numerator
        self.denominator = normalized.denominator
        self.decimalExponent = normalized.decimalExponent
    }

    /// Applies the scale to a floating-point value to obtain a canonical base value.
    @inlinable
    public func apply<Value: BinaryFloatingPoint>(to value: Value) -> Value {
        Self.applyDecimalExponent(
            to: value * Value(numerator) / Value(denominator),
            exponent: decimalExponent
        )
    }

    /// Converts a canonical base value back into the unit described by this scale.
    @inlinable
    public func extract<Value: BinaryFloatingPoint>(from baseValue: Value) -> Value {
        Self.applyDecimalExponent(
            to: baseValue * Value(denominator) / Value(numerator),
            exponent: -decimalExponent
        )
    }

    /// Applies the scale to an integer value and fails if the result would be fractional.
    public func applyExactly<Value: FixedWidthInteger>(to value: Value) throws -> Value {
        let scaled = try Self.multipliedByIntExactly(value, factor: numerator)
        guard let divisor = Value(exactly: denominator) else {
            throw QuantityError.arithmeticOverflow
        }

        guard scaled.isMultiple(of: divisor) else {
            throw QuantityError.nonIntegralConversion
        }

        return try Self.applyingDecimalExponentExactly(
            to: scaled / divisor,
            exponent: decimalExponent
        )
    }

    /// Extracts an integer value from a canonical base value and fails if the result would be fractional.
    public func extractExactly<Value: FixedWidthInteger>(from baseValue: Value) throws -> Value {
        let scaled = try Self.multipliedByIntExactly(baseValue, factor: denominator)
        guard let divisor = Value(exactly: numerator) else {
            throw QuantityError.arithmeticOverflow
        }

        guard scaled.isMultiple(of: divisor) else {
            throw QuantityError.nonIntegralConversion
        }

        return try Self.applyingDecimalExponentExactly(
            to: scaled / divisor,
            exponent: -decimalExponent
        )
    }

    /// Returns the product of two scales.
    public func combined(with other: UnitScale) throws -> UnitScale {
        let combinedNumerator = numerator.multipliedReportingOverflow(by: other.numerator)
        let combinedDenominator = denominator.multipliedReportingOverflow(by: other.denominator)
        let exponent = decimalExponent.addingReportingOverflow(other.decimalExponent)

        guard combinedNumerator.overflow == false,
            combinedDenominator.overflow == false,
            exponent.overflow == false
        else {
            throw UnitScaleError.arithmeticOverflow
        }

        return try UnitScale(
            numerator: combinedNumerator.partialValue,
            denominator: combinedDenominator.partialValue,
            decimalExponent: exponent.partialValue
        )
    }

    package func uncheckedCombined(with other: UnitScale) -> UnitScale {
        do {
            return try combined(with: other)
        } catch {
            preconditionFailure("Unchecked unit-scale combinations must remain representable.")
        }
    }

    public static func == (lhs: UnitScale, rhs: UnitScale) -> Bool {
        lhs.numerator == rhs.numerator
            && lhs.denominator == rhs.denominator
            && lhs.decimalExponent == rhs.decimalExponent
    }

    private static func normalize(
        numerator: Int,
        denominator: Int,
        decimalExponent: Int
    ) throws -> (numerator: Int, denominator: Int, decimalExponent: Int) {
        guard numerator != 0, denominator != 0 else {
            throw UnitScaleError.invalidScale
        }

        var normalizedNumerator = numerator
        var normalizedDenominator = denominator
        var normalizedExponent = decimalExponent

        if normalizedDenominator < 0 {
            guard normalizedNumerator != Int.min, normalizedDenominator != Int.min else {
                throw UnitScaleError.invalidScale
            }
            normalizedNumerator *= -1
            normalizedDenominator *= -1
        }

        let commonDivisor = Self.greatestCommonDivisor(
            normalizedNumerator.magnitude,
            normalizedDenominator.magnitude
        )
        normalizedNumerator /= commonDivisor
        normalizedDenominator /= commonDivisor

        while normalizedNumerator.isMultiple(of: 10) {
            normalizedNumerator /= 10
            let incrementedExponent = normalizedExponent.addingReportingOverflow(1)
            guard incrementedExponent.overflow == false else {
                throw UnitScaleError.arithmeticOverflow
            }
            normalizedExponent = incrementedExponent.partialValue
        }

        while normalizedDenominator.isMultiple(of: 10) {
            normalizedDenominator /= 10
            let decrementedExponent = normalizedExponent.subtractingReportingOverflow(1)
            guard decrementedExponent.overflow == false else {
                throw UnitScaleError.arithmeticOverflow
            }
            normalizedExponent = decrementedExponent.partialValue
        }

        return (
            numerator: normalizedNumerator,
            denominator: normalizedDenominator,
            decimalExponent: normalizedExponent
        )
    }

    private static func assumeValid(
        numerator: Int,
        denominator: Int,
        decimalExponent: Int,
        reason: StaticString
    ) -> UnitScale {
        do {
            return try UnitScale(numerator: numerator, denominator: denominator, decimalExponent: decimalExponent)
        } catch {
            preconditionFailure(String(describing: reason))
        }
    }

    private static func assumeNormalized(
        numerator: Int,
        denominator: Int,
        decimalExponent: Int,
        reason: StaticString
    ) -> (numerator: Int, denominator: Int, decimalExponent: Int) {
        do {
            return try normalize(
                numerator: numerator,
                denominator: denominator,
                decimalExponent: decimalExponent
            )
        } catch {
            preconditionFailure(String(describing: reason))
        }
    }

    private static func greatestCommonDivisor(
        _ lhs: UInt,
        _ rhs: UInt
    ) -> Int {
        var lhs = lhs
        var rhs = rhs

        while rhs != 0 {
            let remainder = lhs % rhs
            lhs = rhs
            rhs = remainder
        }

        return Int(max(lhs, 1))
    }

    @usableFromInline
    static func applyDecimalExponent<Value: BinaryFloatingPoint>(
        to value: Value,
        exponent: Int
    ) -> Value {
        if exponent == 0 {
            return value
        }

        let factor = Self.powerOfTen(exponent.magnitude, as: Value.self)
        return exponent > 0 ? value * factor : value / factor
    }

    private static func applyingDecimalExponentExactly<Value: FixedWidthInteger>(
        to value: Value,
        exponent: Int
    ) throws -> Value {
        if exponent == 0 {
            return value
        }

        let factor = try Self.powerOfTenExactly(exponent.magnitude, as: Value.self)

        if exponent > 0 {
            return try multipliedExactly(value, by: factor)
        }

        guard value.isMultiple(of: factor) else {
            throw QuantityError.nonIntegralConversion
        }

        return value / factor
    }

    private static func multipliedByIntExactly<Value: FixedWidthInteger>(
        _ value: Value,
        factor: Int
    ) throws -> Value {
        guard let convertedFactor = Value(exactly: factor) else {
            throw QuantityError.arithmeticOverflow
        }
        return try multipliedExactly(value, by: convertedFactor)
    }

    private static func multipliedExactly<Value: FixedWidthInteger>(
        _ value: Value,
        by factor: Value
    ) throws -> Value {
        let product = value.multipliedReportingOverflow(by: factor)

        guard product.overflow == false else {
            throw QuantityError.arithmeticOverflow
        }

        return product.partialValue
    }

    @usableFromInline
    static func powerOfTen<Value: BinaryFloatingPoint>(
        _ exponent: Int.Magnitude,
        as valueType: Value.Type
    ) -> Value {
        var result: Value = 1
        var factor: Value = 10
        var remaining = exponent

        while remaining > 0 {
            if remaining & 1 == 1 {
                result *= factor
            }
            remaining >>= 1
            if remaining > 0 {
                factor *= factor
            }
        }

        return result
    }

    private static func powerOfTenExactly<Value: FixedWidthInteger>(
        _ exponent: Int.Magnitude,
        as valueType: Value.Type
    ) throws -> Value {
        var result: Value = 1
        var factor: Value = 10
        var remaining = exponent

        while remaining > 0 {
            if remaining & 1 == 1 {
                result = try multipliedExactly(result, by: factor)
            }
            remaining >>= 1
            if remaining > 0 {
                factor = try multipliedExactly(factor, by: factor)
            }
        }

        return result
    }
}

/// Describes a unit together with its dimension and scale relative to a canonical base unit.
public protocol UnitProtocol {
    /// The physical dimension carried by the unit.
    associatedtype Dimension: DimensionProtocol

    /// A short textual representation of the unit.
    static var symbol: String { get }
    /// The scale factor to and from the canonical base unit of the same dimension.
    static var scale: UnitScale { get }
    /// The offset from the canonical base unit's zero point, expressed in base-unit values.
    ///
    /// Non-zero only for affine units such as degree Celsius, where 0 °C = 273.15 K.
    /// All linear and base units return the default value of zero.
    static var baseOffset: Double { get }
}

extension UnitProtocol {
    /// The default base offset is zero, meaning the unit shares the same zero point
    /// as the canonical base unit.
    public static var baseOffset: Double { 0 }
}

/// Marks units that may be instantiated directly from displayed values.
public protocol DirectlyInitializableUnitProtocol: UnitProtocol {}

/// Marks units that are already canonical base units for their dimension.
public protocol BaseUnitProtocol: DirectlyInitializableUnitProtocol {}

/// Represents a canonical unit that is already normalized to its base-value scale.
public enum CanonicalUnit<Dimension: DimensionProtocol>: BaseUnitProtocol {
    /// Intentionally empty: canonical units are internal base representations
    /// without a user-facing display symbol.
    public static var symbol: String { "" }
    /// The canonical unit uses the identity scale.
    public static var scale: UnitScale { .identity }
}
