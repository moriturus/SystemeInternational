/// Marks a type that encodes a physical dimension at compile time.
public protocol DimensionProtocol: Sendable {
    /// Validates a base value for affine quantities of this dimension.
    static func validateAffineBaseValue<Scalar: FloatingPointQuantityScalar>(
        _ baseValue: Scalar
    ) throws -> Scalar
}

extension DimensionProtocol {
    public static func validateAffineBaseValue<Scalar: FloatingPointQuantityScalar>(
        _ baseValue: Scalar
    ) throws -> Scalar {
        baseValue
    }
}

/// Marks a dimension whose affine quantities cannot go below a physical lower bound.
public protocol AbsoluteLowerBoundDimensionProtocol: DimensionProtocol {
    /// The minimum allowed base value for affine quantities of this dimension.
    static var absoluteMinimumBaseValue: Double { get }
}

extension AbsoluteLowerBoundDimensionProtocol {
    public static func validateAffineBaseValue<Scalar: FloatingPointQuantityScalar>(
        _ baseValue: Scalar
    ) throws -> Scalar {
        guard baseValue >= Scalar(absoluteMinimumBaseValue) else {
            throw QuantityError.belowAbsoluteZero
        }

        return baseValue
    }
}

/// Represents a dimensionless quantity.
public enum Dimensionless: DimensionProtocol {}
/// Represents the SI length dimension.
public enum LengthDimension: DimensionProtocol {}
/// Represents the SI mass dimension.
public enum MassDimension: DimensionProtocol {}
/// Represents the SI time dimension.
public enum TimeDimension: DimensionProtocol {}
/// Represents the SI electric current dimension.
public enum ElectricCurrentDimension: DimensionProtocol {}
/// Represents the SI thermodynamic temperature dimension.
public enum TemperatureDimension: DimensionProtocol {}
extension TemperatureDimension: AbsoluteLowerBoundDimensionProtocol {
    public static let absoluteMinimumBaseValue = 0.0
}
/// Represents the SI amount of substance dimension.
public enum AmountOfSubstanceDimension: DimensionProtocol {}
/// Represents the SI luminous intensity dimension.
public enum LuminousIntensityDimension: DimensionProtocol {}
/// Represents the semantic dimension of plane angle.
public enum PlaneAngleDimension: DimensionProtocol {}
/// Represents the semantic dimension of solid angle.
public enum SolidAngleDimension: DimensionProtocol {}
/// Represents the semantic dimension of frequency.
public enum FrequencyDimension: DimensionProtocol {}
/// Represents the semantic dimension of radionuclide activity.
public enum RadionuclideActivityDimension: DimensionProtocol {}
/// Represents the semantic dimension of absorbed dose.
public enum AbsorbedDoseDimension: DimensionProtocol {}
/// Represents the semantic dimension of equivalent dose.
public enum EquivalentDoseDimension: DimensionProtocol {}

/// Represents the product of two dimensions.
public enum ProductDimension<Lhs: DimensionProtocol, Rhs: DimensionProtocol>: DimensionProtocol {}

/// Represents the quotient of two dimensions.
public enum QuotientDimension<Lhs: DimensionProtocol, Rhs: DimensionProtocol>: DimensionProtocol {}
