/// Errors that can occur while bridging SI-compatible types and Foundation measurements.
public enum CompatibilityError: Error, Equatable, Sendable {
    /// The requested unit is not supported by the compat layer.
    case unsupportedUnit
    /// The provided Foundation measurement family cannot be bridged to the requested unit type.
    case unsupportedMeasurement
    /// The attempted conversion mixes incompatible semantics.
    case semanticMismatch
    /// The bridged numeric value is not finite.
    case nonFiniteValue
}
