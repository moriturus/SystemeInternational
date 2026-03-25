/// Describes the minimum scalar capabilities required to store a quantity value.
public protocol QuantityScalar: AdditiveArithmetic, Comparable, Sendable {}
/// Describes floating-point scalar types that support non-throwing arithmetic operators.
public protocol FloatingPointArithmeticQuantityScalar: FloatingPointQuantityScalar {
    static func * (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
}
/// Describes integer scalar types that only support exact conversions.
public protocol IntegerQuantityScalar: QuantityScalar, FixedWidthInteger {}
/// Describes floating-point scalar types that support ratio-based conversions.
public protocol FloatingPointQuantityScalar: QuantityScalar, BinaryFloatingPoint {}

extension Float: FloatingPointArithmeticQuantityScalar {}
extension Double: FloatingPointArithmeticQuantityScalar {}
extension Int: IntegerQuantityScalar {}
extension Int64: IntegerQuantityScalar {}
