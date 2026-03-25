/// Provides namespaces reserved for future SI-related unit family grouping APIs.
///
/// The current package exports concrete unit types directly, so these namespaces remain intentionally empty.
public enum SI {
    /// Contains SI base-unit related types.
    public enum Base {}
    /// Contains SI derived-unit related types.
    public enum Derived {}
}

/// The SI base unit for length.
public enum Meter: BaseUnitProtocol {
    public static let symbol = "m"
    public static let scale = UnitScale.identity
}

extension Meter {
    public typealias Dimension = LengthDimension
}

/// The SI base unit for mass.
public enum Kilogram: BaseUnitProtocol {
    public static let symbol = "kg"
    public static let scale = UnitScale.identity
}

extension Kilogram {
    public typealias Dimension = MassDimension
}

/// The SI base unit for time.
public enum Second: BaseUnitProtocol {
    public static let symbol = "s"
    public static let scale = UnitScale.identity
}

extension Second {
    public typealias Dimension = TimeDimension
}

/// The SI base unit for electric current.
public enum Ampere: BaseUnitProtocol {
    public static let symbol = "A"
    public static let scale = UnitScale.identity
}

extension Ampere {
    public typealias Dimension = ElectricCurrentDimension
}

/// The SI base unit for thermodynamic temperature.
public enum Kelvin: BaseUnitProtocol {
    public static let symbol = "K"
    public static let scale = UnitScale.identity
}

extension Kelvin {
    public typealias Dimension = TemperatureDimension
}

/// The SI base unit for amount of substance.
public enum Mole: BaseUnitProtocol {
    public static let symbol = "mol"
    public static let scale = UnitScale.identity
}

extension Mole {
    public typealias Dimension = AmountOfSubstanceDimension
}

/// The SI base unit for luminous intensity.
public enum Candela: BaseUnitProtocol {
    public static let symbol = "cd"
    public static let scale = UnitScale.identity
}

extension Candela {
    public typealias Dimension = LuminousIntensityDimension
}
