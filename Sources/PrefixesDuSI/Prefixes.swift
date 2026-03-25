/// Describes an exact SI prefix scale as a power of ten.
public struct PrefixScale: Sendable, Equatable, Hashable {
    /// The base-10 exponent for the represented scale.
    public let exponent: Int

    /// The identity scale with exponent zero.
    public static let identity = PrefixScale(exponent: 0)

    /// Creates a prefix scale from a base-10 exponent.
    public init(exponent: Int) {
        self.exponent = exponent
    }
}

/// Describes an SI prefix together with its symbol and exact decimal scale.
public protocol PrefixProtocol: Sendable {
    /// A short textual representation of the prefix.
    static var symbol: String { get }
    /// The exact base-10 scale represented by the prefix.
    static var scale: PrefixScale { get }
}

/// The SI prefix for 10^30.
public enum Quetta: PrefixProtocol {
    public static let symbol = "Q"
    public static let scale = PrefixScale(exponent: 30)
}

/// The SI prefix for 10^27.
public enum Ronna: PrefixProtocol {
    public static let symbol = "R"
    public static let scale = PrefixScale(exponent: 27)
}

/// The SI prefix for 10^24.
public enum Yotta: PrefixProtocol {
    public static let symbol = "Y"
    public static let scale = PrefixScale(exponent: 24)
}

/// The SI prefix for 10^21.
public enum Zetta: PrefixProtocol {
    public static let symbol = "Z"
    public static let scale = PrefixScale(exponent: 21)
}

/// The SI prefix for 10^18.
public enum Exa: PrefixProtocol {
    public static let symbol = "E"
    public static let scale = PrefixScale(exponent: 18)
}

/// The SI prefix for 10^15.
public enum Peta: PrefixProtocol {
    public static let symbol = "P"
    public static let scale = PrefixScale(exponent: 15)
}

/// The SI prefix for 10^12.
public enum Tera: PrefixProtocol {
    public static let symbol = "T"
    public static let scale = PrefixScale(exponent: 12)
}

/// The SI prefix for 10^9.
public enum Giga: PrefixProtocol {
    public static let symbol = "G"
    public static let scale = PrefixScale(exponent: 9)
}

/// The SI prefix for 10^6.
public enum Mega: PrefixProtocol {
    public static let symbol = "M"
    public static let scale = PrefixScale(exponent: 6)
}

/// The SI prefix for 10^3.
public enum Kilo: PrefixProtocol {
    public static let symbol = "k"
    public static let scale = PrefixScale(exponent: 3)
}

/// The SI prefix for 10^2.
public enum Hecto: PrefixProtocol {
    public static let symbol = "h"
    public static let scale = PrefixScale(exponent: 2)
}

/// The SI prefix for 10^1.
public enum Deca: PrefixProtocol {
    public static let symbol = "da"
    public static let scale = PrefixScale(exponent: 1)
}

/// The SI prefix for 10^-1.
public enum Deci: PrefixProtocol {
    public static let symbol = "d"
    public static let scale = PrefixScale(exponent: -1)
}

/// The SI prefix for 10^-2.
public enum Centi: PrefixProtocol {
    public static let symbol = "c"
    public static let scale = PrefixScale(exponent: -2)
}

/// The SI prefix for 10^-3.
public enum Milli: PrefixProtocol {
    public static let symbol = "m"
    public static let scale = PrefixScale(exponent: -3)
}

/// The SI prefix for 10^-6.
public enum Micro: PrefixProtocol {
    public static let symbol = "μ"
    public static let scale = PrefixScale(exponent: -6)
}

/// The SI prefix for 10^-9.
public enum Nano: PrefixProtocol {
    public static let symbol = "n"
    public static let scale = PrefixScale(exponent: -9)
}

/// The SI prefix for 10^-12.
public enum Pico: PrefixProtocol {
    public static let symbol = "p"
    public static let scale = PrefixScale(exponent: -12)
}

/// The SI prefix for 10^-15.
public enum Femto: PrefixProtocol {
    public static let symbol = "f"
    public static let scale = PrefixScale(exponent: -15)
}

/// The SI prefix for 10^-18.
public enum Atto: PrefixProtocol {
    public static let symbol = "a"
    public static let scale = PrefixScale(exponent: -18)
}

/// The SI prefix for 10^-21.
public enum Zepto: PrefixProtocol {
    public static let symbol = "z"
    public static let scale = PrefixScale(exponent: -21)
}

/// The SI prefix for 10^-24.
public enum Yocto: PrefixProtocol {
    public static let symbol = "y"
    public static let scale = PrefixScale(exponent: -24)
}

/// The SI prefix for 10^-27.
public enum Ronto: PrefixProtocol {
    public static let symbol = "r"
    public static let scale = PrefixScale(exponent: -27)
}

/// The SI prefix for 10^-30.
public enum Quecto: PrefixProtocol {
    public static let symbol = "q"
    public static let scale = PrefixScale(exponent: -30)
}
