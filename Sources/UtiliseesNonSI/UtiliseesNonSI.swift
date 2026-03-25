import UnitesDeBaseDuSI
import UnitesDeriveesDuSI
@_exported import UnitesSI

/// A shorthand namespace reserved for future accepted-unit grouping APIs.
///
/// The current package exports unit types directly, so this namespace remains intentionally empty.
public enum UtiliseesNonSINamespace {}

/// Represents the semantic dimension of logarithmic ratio (neper, bel, decibel).
///
/// Defined in the non-SI module because neper, bel, and decibel are non-SI units
/// accepted for use with the SI, not SI base or derived units.
public enum LogarithmicRatioDimension: DimensionProtocol {}

/// The non-SI unit accepted for use with the SI for time equal to 60 seconds.
public enum Minute: DirectlyInitializableUnitProtocol {
    public static let symbol = "min"
    public static let scale = UnitScale(uncheckedNumerator: 60, denominator: 1)

    public typealias Dimension = TimeDimension
}

/// The non-SI unit accepted for use with the SI for time equal to 3,600 seconds.
public enum Hour: DirectlyInitializableUnitProtocol {
    public static let symbol = "h"
    public static let scale = UnitScale(uncheckedNumerator: 3_600, denominator: 1)

    public typealias Dimension = TimeDimension
}

/// The non-SI unit accepted for use with the SI for time equal to 86,400 seconds.
public enum Day: DirectlyInitializableUnitProtocol {
    public static let symbol = "d"
    public static let scale = UnitScale(uncheckedNumerator: 86_400, denominator: 1)

    public typealias Dimension = TimeDimension
}

/// The non-SI unit accepted for use with the SI for mass equal to 1,000 kilograms.
///
/// SI prefixes may be applied to the tonne (e.g. kt, Mt, Gt).
public enum Tonne: DirectlyInitializableUnitProtocol, SIPrefixableUnitProtocol {
    public static let symbol = "t"
    public static let scale = UnitScale(uncheckedNumerator: 1, denominator: 1, decimalExponent: 3)
    public static let siPrefixableUnitToken = SIPrefixableUnitToken()

    public typealias Dimension = MassDimension
}

/// The non-SI unit accepted for use with the SI for area equal to 10,000 square meters.
public enum Hectare: DirectlyInitializableUnitProtocol {
    public static let symbol = "ha"
    public static let scale = UnitScale(uncheckedNumerator: 1, denominator: 1, decimalExponent: 4)

    public typealias Dimension = ProductDimension<LengthDimension, LengthDimension>
}

/// The non-SI unit accepted for use with the SI for length equal to 149,597,870,700 meters.
public enum AstronomicalUnit: DirectlyInitializableUnitProtocol {
    public static let symbol = "au"
    public static let scale = UnitScale(uncheckedNumerator: 149_597_870_700, denominator: 1)

    public typealias Dimension = LengthDimension
}

/// The non-SI unit accepted for use with the SI for energy equal to 1.602176634e-19 joules.
///
/// SI prefixes may be applied to the electronvolt (e.g. meV, keV, MeV, GeV, TeV).
public enum ElectronVolt: DirectlyInitializableUnitProtocol, SIPrefixableUnitProtocol {
    public static let symbol = "eV"
    public static let scale = UnitScale(uncheckedNumerator: 1_602_176_634, denominator: 1, decimalExponent: -28)
    public static let siPrefixableUnitToken = SIPrefixableUnitToken()

    public typealias Dimension = Joule.Dimension
}

/// The non-SI unit accepted for use with the SI for mass equal to 1.66053906660e-27 kilograms.
///
/// SI prefixes may be applied to the dalton (e.g. kDa, MDa).
public enum Dalton: DirectlyInitializableUnitProtocol, SIPrefixableUnitProtocol {
    public static let symbol = "Da"
    public static let scale = UnitScale(uncheckedNumerator: 16_605_390_666, denominator: 1, decimalExponent: -37)
    public static let siPrefixableUnitToken = SIPrefixableUnitToken()

    public typealias Dimension = MassDimension
}

/// The non-SI unit accepted for use with the SI for volume equal to 10⁻³ cubic metres.
///
/// The symbol "L" is used instead of "l" to avoid visual confusion with the digit "1",
/// following the recommendation of the CGPM (16th CGPM, 1979, Resolution 6).
/// SI prefixes may be applied to the liter (e.g. mL, µL, kL).
public enum Liter: DirectlyInitializableUnitProtocol, SIPrefixableUnitProtocol {
    public static let symbol = "L"
    public static let scale = UnitScale(uncheckedNumerator: 1, denominator: 1, decimalExponent: -3)
    public static let siPrefixableUnitToken = SIPrefixableUnitToken()

    public typealias Dimension = ProductDimension<ProductDimension<LengthDimension, LengthDimension>, LengthDimension>
}

// MARK: - Plane angle units

/// The non-SI unit accepted for use with the SI for plane angle equal to π/180 radians.
///
/// The scale uses a Double-precision rational approximation of π:
/// `3_141_592_653_589_793 × 10⁻¹⁵ ≈ π`. This is not exact but matches
/// `Double.pi` to the full precision of IEEE 754 binary64.
public enum Degree: DirectlyInitializableUnitProtocol {
    public static let symbol = "°"
    public static let scale = UnitScale(
        uncheckedNumerator: 3_141_592_653_589_793,
        denominator: 180,
        decimalExponent: -15
    )

    public typealias Dimension = PlaneAngleDimension
}

/// The non-SI unit accepted for use with the SI for plane angle equal to 1/60 of a degree (π/10800 radians).
///
/// The scale uses the same Double-precision rational approximation of π as ``Degree``.
public enum Arcminute: DirectlyInitializableUnitProtocol {
    public static let symbol = "′"
    public static let scale = UnitScale(
        uncheckedNumerator: 3_141_592_653_589_793,
        denominator: 10_800,
        decimalExponent: -15
    )

    public typealias Dimension = PlaneAngleDimension
}

/// The non-SI unit accepted for use with the SI for plane angle equal to 1/60 of an arcminute (π/648000 radians).
///
/// The scale uses the same Double-precision rational approximation of π as ``Degree``.
public enum Arcsecond: DirectlyInitializableUnitProtocol {
    public static let symbol = "″"
    public static let scale = UnitScale(
        uncheckedNumerator: 3_141_592_653_589_793,
        denominator: 648_000,
        decimalExponent: -15
    )

    public typealias Dimension = PlaneAngleDimension
}

// MARK: - Logarithmic ratio units

/// The coherent SI unit for logarithmic ratio quantities.
///
/// The neper expresses the natural logarithm of a ratio:
/// for field quantities `L_F = ln(F/F₀) Np`, for power quantities `L_P = ½ ln(P/P₀) Np`.
/// As the coherent unit, 1 Np = 1 in the canonical (dimensionless) representation.
///
/// SI prefixes may be applied to the neper (e.g. mNp).
///
/// - Note: The neper, bel and decibel have been accepted by the CIPM for use with the SI.
///   Conversions between Np and B are **linear** (`1 B = ln(10)/2 Np`);
///   the non-linearity is between the logarithmic quantity and the underlying physical ratio,
///   not between the units themselves.
public enum Neper: ExplicitlyInterpretedUnitProtocol, DirectlyInitializableUnitProtocol {
    public static let symbol = "Np"
    public static let scale = UnitScale.identity
    public static let semanticInterpretationToken = SemanticInterpretationToken()

    public typealias Dimension = LogarithmicRatioDimension
    public typealias CanonicalDimension = Dimensionless
}

/// The non-SI unit accepted for use with the SI for logarithmic ratio quantities.
///
/// The bel relates to the neper by `1 B = (ln 10)/2 Np ≈ 1.1513 Np`.
/// SI prefixes may be applied to the bel; the decibel (`dB = SIPrefixedUnit<Bel, Deci>`)
/// is by far the most common variant.
///
/// The scale uses a Double-precision rational approximation of ln(10):
/// `2_302_585_092_994_046 × 10⁻¹⁵ ≈ ln(10)`, divided by 2 to give
/// `1_151_292_546_497_023 × 10⁻¹⁵ ≈ ln(10)/2`.
public enum Bel: DirectlyInitializableUnitProtocol, SIPrefixableUnitProtocol {
    public static let symbol = "B"
    public static let scale = UnitScale(
        uncheckedNumerator: 1_151_292_546_497_023,
        denominator: 1,
        decimalExponent: -15
    )
    public static let siPrefixableUnitToken = SIPrefixableUnitToken()

    public typealias Dimension = LogarithmicRatioDimension
}

// MARK: - Semantic interpretation for logarithmic ratio

extension Quantity where Unit == CanonicalUnit<Dimensionless> {
    /// Interprets a dimensionless canonical quantity as a logarithmic ratio in nepers.
    ///
    /// Use this when you have computed a logarithmic ratio (e.g. via `ln(P₁/P₀)`)
    /// and want to express it as a typed neper quantity.
    public func interpreted(as destination: Neper.Type) -> Quantity<Scalar, Neper, Space> {
        interpretedUnchecked(as: Neper.self)
    }
}
