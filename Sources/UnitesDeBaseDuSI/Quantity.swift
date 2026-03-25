/// Describes quantity operations that can fail because an exact integer representation does not exist.
public enum QuantityError: Error, Equatable, Sendable {
    /// Thrown when an integer-based conversion would require a fractional result.
    case nonIntegralConversion
    /// Thrown when an integer-based conversion would overflow the destination scalar.
    case arithmeticOverflow
    /// Thrown when an integer-based division attempts to divide by zero.
    case divisionByZero
    /// Thrown when a floating-point quantity would store a non-finite value.
    case nonFiniteValue
    /// Thrown when an affine quantity would fall below the dimension's absolute minimum.
    case belowAbsoluteZero
}

/// Stores a quantity value normalized to the canonical base unit of its dimension.
///
/// The `Space` parameter encodes whether this quantity is an affine point or a linear vector:
/// - `Linear`: intervals, differences, and standard vector-space quantities
/// - `Affine`: absolute positions such as thermodynamic temperature
public struct Quantity<Scalar, Unit: UnitProtocol, Space: QuantitySpace>: Sendable
where Scalar: QuantityScalar {
    @usableFromInline
    let storage: Scalar

    /// The quantity value expressed in the canonical base unit for `Unit.Dimension`.
    package var baseValue: Scalar { storage }

    /// Creates a quantity from a value that is already expressed in the canonical base unit.
    package init(baseValue: Scalar) where Unit: DirectlyInitializableUnitProtocol {
        storage = baseValue
    }

    @usableFromInline
    init(inlinableBaseValue baseValue: Scalar) {
        storage = baseValue
    }

    @inlinable
    package init(uncheckedBaseValue baseValue: Scalar) {
        storage = baseValue
    }
}

/// Marks a named SI unit that requires an explicit semantic interpretation step from its canonical quantity.
public protocol ExplicitlyInterpretedUnitProtocol: UnitProtocol {
    /// The canonical quantity dimension produced by equations before a semantic unit is chosen.
    associatedtype CanonicalDimension: DimensionProtocol

    /// Restricts semantic-unit conformances to library-defined types so dimension meaning cannot be forged externally.
    static var semanticInterpretationToken: SemanticInterpretationToken { get }
}

public struct SemanticInterpretationToken: Sendable {
    package init() {}
}

// MARK: - Linear Floating-Point

/// Floating-point linear quantities use ratio-based unit conversions without loss of API availability.
extension Quantity where Space == Linear, Scalar: FloatingPointQuantityScalar {
    /// Creates a linear quantity from a value expressed in `Unit`.
    public init(_ value: Scalar, unit: Unit.Type = Unit.self) throws
    where Unit: DirectlyInitializableUnitProtocol {
        guard value.isFinite else {
            throw QuantityError.nonFiniteValue
        }

        let baseValue = Unit.scale.apply(to: value)
        guard baseValue.isFinite else {
            throw QuantityError.nonFiniteValue
        }

        storage = baseValue
    }

    /// Returns the quantity value expressed in `Unit`.
    @inlinable
    public var value: Scalar {
        Unit.scale.extract(from: storage)
    }

    /// Converts the quantity into another unit of the same dimension.
    @inlinable
    public func converted<Destination: UnitProtocol>(
        to destination: Destination.Type
    ) -> Quantity<Scalar, Destination, Linear> where Destination.Dimension == Unit.Dimension {
        Quantity<Scalar, Destination, Linear>(inlinableBaseValue: storage)
    }
}

// MARK: - Affine Floating-Point

/// Floating-point affine quantities apply the unit's base offset during initialization and value extraction.
extension Quantity where Space == Affine, Scalar: FloatingPointQuantityScalar {
    /// Creates an affine quantity from a value expressed in `Unit`.
    public init(_ value: Scalar, unit: Unit.Type = Unit.self) throws
    where Unit: DirectlyInitializableUnitProtocol {
        guard value.isFinite else {
            throw QuantityError.nonFiniteValue
        }

        let scaled = Unit.scale.apply(to: value)
        let baseValue = scaled + Scalar(Unit.baseOffset)
        guard baseValue.isFinite else {
            throw QuantityError.nonFiniteValue
        }

        storage = try Unit.Dimension.validateAffineBaseValue(baseValue)
    }

    /// Returns the quantity value expressed in `Unit`.
    @inlinable
    public var value: Scalar {
        Unit.scale.extract(from: storage - Scalar(Unit.baseOffset))
    }

    /// Converts the quantity into another unit of the same dimension.
    @inlinable
    public func converted<Destination: UnitProtocol>(
        to destination: Destination.Type
    ) -> Quantity<Scalar, Destination, Affine> where Destination.Dimension == Unit.Dimension {
        Quantity<Scalar, Destination, Affine>(inlinableBaseValue: storage)
    }
}

// MARK: - Linear Integer

/// Integer linear quantities expose only exact conversions so the type does not silently round values.
extension Quantity where Space == Linear, Scalar: IntegerQuantityScalar {
    /// Creates a quantity from an integer value expressed in `Unit` if the canonical base value is exact.
    public init(exactly value: Scalar, unit: Unit.Type = Unit.self) throws
    where Unit: DirectlyInitializableUnitProtocol {
        storage = try Unit.scale.applyExactly(to: value)
    }

    /// Returns the value in `Unit` when it can be represented exactly as an integer.
    public var exactValue: Scalar? {
        try? Unit.scale.extractExactly(from: storage)
    }

    /// Converts the quantity into another unit of the same dimension when the destination value is exact.
    public func convertedIfExactly<Destination: UnitProtocol>(
        to destination: Destination.Type
    ) throws -> Quantity<Scalar, Destination, Linear> where Destination.Dimension == Unit.Dimension {
        _ = try Destination.scale.extractExactly(from: storage)
        return Quantity<Scalar, Destination, Linear>(uncheckedBaseValue: storage)
    }
}

// MARK: - Semantic Interpretation

extension Quantity {
    /// Interprets a canonical quantity as a named SI unit with distinct semantics but the same numeric base value.
    package func interpretedUnchecked<Destination: ExplicitlyInterpretedUnitProtocol>(
        as destination: Destination.Type
    ) -> Quantity<Scalar, Destination, Space> where Unit == CanonicalUnit<Destination.CanonicalDimension> {
        Quantity<Scalar, Destination, Space>(uncheckedBaseValue: storage)
    }
}

// MARK: - Equatable, Comparable, Hashable

extension Quantity: Equatable where Scalar: Equatable {}

extension Quantity: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.baseValue < rhs.baseValue
    }
}

extension Quantity: Hashable where Scalar: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(baseValue)
    }
}

// MARK: - Linear Same-Type Arithmetic

extension Quantity where Space == Linear, Scalar: FloatingPointQuantityScalar {
    /// Adds two linear quantities of the same unit.
    @inlinable
    public static func + (lhs: Self, rhs: Self) throws -> Self {
        let result = lhs.storage + rhs.storage
        guard result.isFinite else {
            throw QuantityError.nonFiniteValue
        }

        return Self(inlinableBaseValue: result)
    }

    /// Subtracts two linear quantities of the same unit.
    @inlinable
    public static func - (lhs: Self, rhs: Self) throws -> Self {
        let result = lhs.storage - rhs.storage
        guard result.isFinite else {
            throw QuantityError.nonFiniteValue
        }

        return Self(inlinableBaseValue: result)
    }
}

extension Quantity where Space == Linear, Scalar: IntegerQuantityScalar {
    /// Adds two integer linear quantities of the same unit and reports overflow as a typed failure.
    public static func + (lhs: Self, rhs: Self) throws -> Self {
        let result = lhs.baseValue.addingReportingOverflow(rhs.baseValue)
        guard result.overflow == false else {
            throw QuantityError.arithmeticOverflow
        }

        return Self(uncheckedBaseValue: result.partialValue)
    }

    /// Subtracts two integer linear quantities of the same unit and reports overflow as a typed failure.
    public static func - (lhs: Self, rhs: Self) throws -> Self {
        let result = lhs.baseValue.subtractingReportingOverflow(rhs.baseValue)
        guard result.overflow == false else {
            throw QuantityError.arithmeticOverflow
        }

        return Self(uncheckedBaseValue: result.partialValue)
    }
}

// MARK: - Cross-Unit Comparison

/// Compares two quantities of the same dimension and space after normalization to their canonical base values.
public func == <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol, Space: QuantitySpace>(
    lhs: Quantity<Scalar, LhsUnit, Space>,
    rhs: Quantity<Scalar, RhsUnit, Space>
) -> Bool
where
    Scalar: QuantityScalar,
    LhsUnit.Dimension == RhsUnit.Dimension
{
    lhs.baseValue == rhs.baseValue
}

/// Orders two quantities of the same dimension and space by their canonical base values.
public func < <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol, Space: QuantitySpace>(
    lhs: Quantity<Scalar, LhsUnit, Space>,
    rhs: Quantity<Scalar, RhsUnit, Space>
) -> Bool
where
    Scalar: QuantityScalar,
    LhsUnit.Dimension == RhsUnit.Dimension
{
    lhs.baseValue < rhs.baseValue
}

/// Orders two quantities of the same dimension and space by their canonical base values.
public func <= <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol, Space: QuantitySpace>(
    lhs: Quantity<Scalar, LhsUnit, Space>,
    rhs: Quantity<Scalar, RhsUnit, Space>
) -> Bool
where
    Scalar: QuantityScalar,
    LhsUnit.Dimension == RhsUnit.Dimension
{
    !(rhs < lhs)
}

/// Orders two quantities of the same dimension and space by their canonical base values.
public func > <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol, Space: QuantitySpace>(
    lhs: Quantity<Scalar, LhsUnit, Space>,
    rhs: Quantity<Scalar, RhsUnit, Space>
) -> Bool
where
    Scalar: QuantityScalar,
    LhsUnit.Dimension == RhsUnit.Dimension
{
    rhs < lhs
}

/// Orders two quantities of the same dimension and space by their canonical base values.
public func >= <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol, Space: QuantitySpace>(
    lhs: Quantity<Scalar, LhsUnit, Space>,
    rhs: Quantity<Scalar, RhsUnit, Space>
) -> Bool
where
    Scalar: QuantityScalar,
    LhsUnit.Dimension == RhsUnit.Dimension
{
    !(lhs < rhs)
}

// MARK: - Linear Cross-Unit Multiplication and Division (Floating-Point)

/// Multiplies two linear quantities and returns a quantity normalized to a canonical derived unit.
@inlinable
public func * <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol>(
    lhs: Quantity<Scalar, LhsUnit, Linear>,
    rhs: Quantity<Scalar, RhsUnit, Linear>
) throws -> Quantity<Scalar, CanonicalUnit<ProductDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>
where Scalar: FloatingPointArithmeticQuantityScalar {
    let result = lhs.storage * rhs.storage
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    // Derived quantities are normalized immediately so unit composition stays purely type-driven.
    return Quantity<Scalar, CanonicalUnit<ProductDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>(
        inlinableBaseValue: result
    )
}

/// Divides two linear quantities and returns a quantity normalized to a canonical derived unit.
///
@inlinable
public func / <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol>(
    lhs: Quantity<Scalar, LhsUnit, Linear>,
    rhs: Quantity<Scalar, RhsUnit, Linear>
) throws -> Quantity<Scalar, CanonicalUnit<QuotientDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>
where Scalar: FloatingPointArithmeticQuantityScalar {
    guard rhs.storage != 0 else {
        throw QuantityError.divisionByZero
    }

    let result = lhs.storage / rhs.storage
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    // Canonical normalization keeps derived-unit arithmetic independent from display-oriented unit choices.
    return Quantity<Scalar, CanonicalUnit<QuotientDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>(
        inlinableBaseValue: result
    )
}

/// Divides a linear quantity by a grouped denominator while preserving the same canonical dimension as repeated division.
public func / <
    Scalar,
    LhsUnit: UnitProtocol,
    FirstDenominator: DimensionProtocol,
    SecondDenominator: DimensionProtocol
>(
    lhs: Quantity<Scalar, LhsUnit, Linear>,
    rhs: Quantity<Scalar, CanonicalUnit<ProductDimension<FirstDenominator, SecondDenominator>>, Linear>
) throws -> Quantity<
    Scalar,
    CanonicalUnit<QuotientDimension<QuotientDimension<LhsUnit.Dimension, FirstDenominator>, SecondDenominator>>,
    Linear
>
where Scalar: FloatingPointArithmeticQuantityScalar {
    guard rhs.baseValue != 0 else {
        throw QuantityError.divisionByZero
    }

    let result = lhs.baseValue / rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<
        Scalar,
        CanonicalUnit<QuotientDimension<QuotientDimension<LhsUnit.Dimension, FirstDenominator>, SecondDenominator>>,
        Linear
    >(
        uncheckedBaseValue: result
    )
}

// MARK: - Linear Cross-Unit Multiplication and Division (Integer)

/// Multiplies two integer linear quantities and returns a quantity normalized to a canonical derived unit.
public func * <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol>(
    lhs: Quantity<Scalar, LhsUnit, Linear>,
    rhs: Quantity<Scalar, RhsUnit, Linear>
) throws -> Quantity<Scalar, CanonicalUnit<ProductDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>
where Scalar: IntegerQuantityScalar {
    let product = lhs.baseValue.multipliedReportingOverflow(by: rhs.baseValue)

    guard product.overflow == false else {
        throw QuantityError.arithmeticOverflow
    }

    return Quantity<Scalar, CanonicalUnit<ProductDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>(
        uncheckedBaseValue: product.partialValue
    )
}

/// Divides two integer linear quantities and returns a quantity normalized to a canonical derived unit when exact.
public func / <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol>(
    lhs: Quantity<Scalar, LhsUnit, Linear>,
    rhs: Quantity<Scalar, RhsUnit, Linear>
) throws -> Quantity<Scalar, CanonicalUnit<QuotientDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>
where Scalar: IntegerQuantityScalar {
    guard rhs.baseValue != 0 else {
        throw QuantityError.divisionByZero
    }

    let quotient = lhs.baseValue.dividedReportingOverflow(by: rhs.baseValue)
    guard quotient.overflow == false else {
        throw QuantityError.arithmeticOverflow
    }

    guard lhs.baseValue.isMultiple(of: rhs.baseValue) else {
        throw QuantityError.nonIntegralConversion
    }

    return Quantity<Scalar, CanonicalUnit<QuotientDimension<LhsUnit.Dimension, RhsUnit.Dimension>>, Linear>(
        uncheckedBaseValue: quotient.partialValue
    )
}

/// Divides an integer linear quantity by a grouped denominator while preserving the same canonical dimension as repeated division.
public func / <
    Scalar,
    LhsUnit: UnitProtocol,
    FirstDenominator: DimensionProtocol,
    SecondDenominator: DimensionProtocol
>(
    lhs: Quantity<Scalar, LhsUnit, Linear>,
    rhs: Quantity<Scalar, CanonicalUnit<ProductDimension<FirstDenominator, SecondDenominator>>, Linear>
) throws
    -> Quantity<
        Scalar,
        CanonicalUnit<QuotientDimension<QuotientDimension<LhsUnit.Dimension, FirstDenominator>, SecondDenominator>>,
        Linear
    >
where Scalar: IntegerQuantityScalar {
    guard rhs.baseValue != 0 else {
        throw QuantityError.divisionByZero
    }

    let quotient = lhs.baseValue.dividedReportingOverflow(by: rhs.baseValue)
    guard quotient.overflow == false else {
        throw QuantityError.arithmeticOverflow
    }

    guard lhs.baseValue.isMultiple(of: rhs.baseValue) else {
        throw QuantityError.nonIntegralConversion
    }

    return Quantity<
        Scalar,
        CanonicalUnit<QuotientDimension<QuotientDimension<LhsUnit.Dimension, FirstDenominator>, SecondDenominator>>,
        Linear
    >(
        uncheckedBaseValue: quotient.partialValue
    )
}

// MARK: - Affine Operators

/// Adds a linear vector to an affine point, producing an affine point.
public func + <Scalar: FloatingPointQuantityScalar, Unit: UnitProtocol>(
    lhs: Quantity<Scalar, Unit, Affine>,
    rhs: Quantity<Scalar, Unit, Linear>
) throws -> Quantity<Scalar, Unit, Affine> {
    let result = lhs.baseValue + rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<Scalar, Unit, Affine>(
        uncheckedBaseValue: try Unit.Dimension.validateAffineBaseValue(result)
    )
}

/// Adds a linear vector to an affine point (commutative).
public func + <Scalar: FloatingPointQuantityScalar, Unit: UnitProtocol>(
    lhs: Quantity<Scalar, Unit, Linear>,
    rhs: Quantity<Scalar, Unit, Affine>
) throws -> Quantity<Scalar, Unit, Affine> {
    try rhs + lhs
}

/// Subtracts two affine points of the same unit, producing a linear vector.
public func - <Scalar: FloatingPointQuantityScalar, Unit: UnitProtocol>(
    lhs: Quantity<Scalar, Unit, Affine>,
    rhs: Quantity<Scalar, Unit, Affine>
) throws -> Quantity<Scalar, Unit, Linear> {
    let result = lhs.baseValue - rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<Scalar, Unit, Linear>(uncheckedBaseValue: result)
}

/// Subtracts two affine points of different units in the same dimension, producing a canonical linear vector.
public func - <Scalar, LhsUnit: UnitProtocol, RhsUnit: UnitProtocol>(
    lhs: Quantity<Scalar, LhsUnit, Affine>,
    rhs: Quantity<Scalar, RhsUnit, Affine>
) throws -> Quantity<Scalar, CanonicalUnit<LhsUnit.Dimension>, Linear>
where Scalar: FloatingPointQuantityScalar, LhsUnit.Dimension == RhsUnit.Dimension {
    let result = lhs.baseValue - rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<Scalar, CanonicalUnit<LhsUnit.Dimension>, Linear>(uncheckedBaseValue: result)
}

/// Subtracts a linear vector from an affine point, producing an affine point.
public func - <Scalar: FloatingPointQuantityScalar, Unit: UnitProtocol>(
    lhs: Quantity<Scalar, Unit, Affine>,
    rhs: Quantity<Scalar, Unit, Linear>
) throws -> Quantity<Scalar, Unit, Affine> {
    let result = lhs.baseValue - rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<Scalar, Unit, Affine>(
        uncheckedBaseValue: try Unit.Dimension.validateAffineBaseValue(result)
    )
}
