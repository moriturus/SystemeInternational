@_exported import PrefixesDuSI
@_exported import UnitesDeBaseDuSI
@_exported import UnitesDeriveesDuSI

/// Marks an official SI decimal prefix supported by the `UnitesSI` facade.
public protocol OfficialSIPrefixProtocol: PrefixProtocol {
    /// Restricts official SI prefix conformances to library-defined types.
    static var officialSIPrefixToken: OfficialSIPrefixToken { get }
}

public struct OfficialSIPrefixToken: Sendable {
    package init() {}
}

extension Quetta: OfficialSIPrefixProtocol {}
extension Ronna: OfficialSIPrefixProtocol {}
extension Yotta: OfficialSIPrefixProtocol {}
extension Zetta: OfficialSIPrefixProtocol {}
extension Exa: OfficialSIPrefixProtocol {}
extension Peta: OfficialSIPrefixProtocol {}
extension Tera: OfficialSIPrefixProtocol {}
extension Giga: OfficialSIPrefixProtocol {}
extension Mega: OfficialSIPrefixProtocol {}
extension Kilo: OfficialSIPrefixProtocol {}
extension Hecto: OfficialSIPrefixProtocol {}
extension Deca: OfficialSIPrefixProtocol {}
extension Deci: OfficialSIPrefixProtocol {}
extension Centi: OfficialSIPrefixProtocol {}
extension Milli: OfficialSIPrefixProtocol {}
extension Micro: OfficialSIPrefixProtocol {}
extension Nano: OfficialSIPrefixProtocol {}
extension Pico: OfficialSIPrefixProtocol {}
extension Femto: OfficialSIPrefixProtocol {}
extension Atto: OfficialSIPrefixProtocol {}
extension Zepto: OfficialSIPrefixProtocol {}
extension Yocto: OfficialSIPrefixProtocol {}
extension Ronto: OfficialSIPrefixProtocol {}
extension Quecto: OfficialSIPrefixProtocol {}

extension Quetta { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Ronna { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Yotta { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Zetta { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Exa { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Peta { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Tera { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Giga { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Mega { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Kilo { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Hecto { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Deca { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Deci { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Centi { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Milli { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Micro { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Nano { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Pico { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Femto { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Atto { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Zepto { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Yocto { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Ronto { public static let officialSIPrefixToken = OfficialSIPrefixToken() }
extension Quecto { public static let officialSIPrefixToken = OfficialSIPrefixToken() }

/// Marks SI units that may be combined with official decimal prefixes.
public protocol SIPrefixableUnitProtocol: UnitProtocol {
    /// Returns the exact scale for this unit combined with an official SI prefix.
    static func prefixedScale<Prefix: OfficialSIPrefixProtocol>(for prefix: Prefix.Type) -> UnitScale

    /// Restricts prefixable-unit conformances to library-defined types.
    static var siPrefixableUnitToken: SIPrefixableUnitToken { get }
}

public struct SIPrefixableUnitToken: Sendable {
    package init() {}
}

/// Represents an SI unit prefixed by an SI decimal prefix.
public enum SIPrefixedUnit<Base: SIPrefixableUnitProtocol, Prefix: OfficialSIPrefixProtocol>: UnitProtocol {
    public static var symbol: String {
        Prefix.symbol + Base.symbol
    }

    public static var scale: UnitScale {
        Base.prefixedScale(for: Prefix.self)
    }

    public typealias Dimension = Base.Dimension
}

extension SIPrefixedUnit: DirectlyInitializableUnitProtocol where Base: DirectlyInitializableUnitProtocol {}

package func checkedCombinedScale<Base: UnitProtocol, Prefix: OfficialSIPrefixProtocol>(
    for base: Base.Type,
    prefix: Prefix.Type
) throws -> UnitScale {
    try base.scale.combined(
        with: UnitScale(
            uncheckedNumerator: 1,
            denominator: 1,
            decimalExponent: prefix.scale.exponent
        )
    )
}

private func combinedScale<Base: UnitProtocol, Prefix: OfficialSIPrefixProtocol>(
    for base: Base.Type,
    prefix: Prefix.Type
) -> UnitScale {
    do {
        return try checkedCombinedScale(for: base, prefix: prefix)
    } catch {
        // The witness-token pattern uses package-private initializers to discourage external
        // conformances, but it is not a security boundary — existing public token values can
        // be reused by downstream code. If a forged or unexpected conformance reaches this
        // path, surface it in debug builds and fall back to the base scale in release.
        assertionFailure(
            "Unexpected prefix combination: \(base) with \(prefix). "
                + "This may indicate an unsupported external conformance."
        )
        return base.scale
    }
}

extension SIPrefixableUnitProtocol {
    public static func prefixedScale<Prefix: OfficialSIPrefixProtocol>(for prefix: Prefix.Type) -> UnitScale {
        combinedScale(for: Self.self, prefix: prefix)
    }
}

extension Meter: SIPrefixableUnitProtocol {}
extension Second: SIPrefixableUnitProtocol {}
extension Ampere: SIPrefixableUnitProtocol {}
extension Kelvin: SIPrefixableUnitProtocol {}
extension Mole: SIPrefixableUnitProtocol {}
extension Candela: SIPrefixableUnitProtocol {}
extension Newton: SIPrefixableUnitProtocol {}
extension Pascal: SIPrefixableUnitProtocol {}
extension Joule: SIPrefixableUnitProtocol {}
extension Watt: SIPrefixableUnitProtocol {}
extension Coulomb: SIPrefixableUnitProtocol {}
extension Volt: SIPrefixableUnitProtocol {}
extension Farad: SIPrefixableUnitProtocol {}
extension Ohm: SIPrefixableUnitProtocol {}
extension Siemens: SIPrefixableUnitProtocol {}
extension Weber: SIPrefixableUnitProtocol {}
extension Tesla: SIPrefixableUnitProtocol {}
extension Henry: SIPrefixableUnitProtocol {}
extension Lumen: SIPrefixableUnitProtocol {}
extension Lux: SIPrefixableUnitProtocol {}
extension Katal: SIPrefixableUnitProtocol {}
extension Hertz: SIPrefixableUnitProtocol {}
extension Becquerel: SIPrefixableUnitProtocol {}
extension Gray: SIPrefixableUnitProtocol {}
extension Sievert: SIPrefixableUnitProtocol {}

extension Meter { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Second { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Ampere { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Kelvin { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Mole { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Candela { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Newton { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Pascal { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Joule { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Watt { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Coulomb { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Volt { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Farad { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Ohm { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Siemens { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Weber { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Tesla { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Henry { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Lumen { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Lux { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Katal { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Hertz { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Becquerel { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Gray { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }
extension Sievert { public static let siPrefixableUnitToken = SIPrefixableUnitToken() }

/// Represents the gram as a prefixable SI mass unit relative to the canonical kilogram.
///
/// The SI base unit for mass is the kilogram. Prefixed mass units are formed from the gram,
/// so `UnitesSI` exposes `Gram` and its prefixed variants while keeping `Kilogram` as-is.
public enum Gram: DirectlyInitializableUnitProtocol, SIPrefixableUnitProtocol {
    public static let symbol = "g"
    public static let scale = UnitScale(uncheckedNumerator: 1, denominator: 1, decimalExponent: -3)
    public static let siPrefixableUnitToken = SIPrefixableUnitToken()

    public typealias Dimension = MassDimension
}
