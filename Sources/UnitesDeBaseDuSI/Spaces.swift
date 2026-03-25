/// Marks the algebraic space of a quantity: affine (point) or linear (vector).
///
/// The space parameter encodes affine-space algebra at compile time.
/// `Linear` quantities behave as vectors (intervals, differences),
/// while `Affine` quantities behave as points (absolute positions).
public protocol QuantitySpace: Sendable {}

/// Marks a quantity as an affine point (e.g., absolute temperature).
///
/// Affine quantities support:
/// - Point + Vector → Point
/// - Point − Point → Vector
/// - Point − Vector → Point
///
/// Point + Point is a compile-time error (no overload exists).
public enum Affine: QuantitySpace {}

/// Marks a quantity as a linear vector (e.g., temperature interval, length, mass).
///
/// Linear quantities support standard vector-space operations:
/// addition, subtraction, scalar multiplication, and division.
public enum Linear: QuantitySpace {}
