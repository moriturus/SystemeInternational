/// Intermediate typestate representing a floating-point scalar together with a chosen SI prefix.
///
/// Use this transient type as the middle step in the `value.prefix.unit` DSL chain.
public struct PrefixedScalar<Scalar, Prefix: OfficialSIPrefixProtocol>: Sendable
where Scalar: FloatingPointQuantityScalar {
    /// The scalar value that will be interpreted in a prefixed unit endpoint.
    public let value: Scalar

    /// Creates a prefixed scalar that can be completed by selecting a unit endpoint.
    public init(value: Scalar) {
        self.value = value
    }
}
