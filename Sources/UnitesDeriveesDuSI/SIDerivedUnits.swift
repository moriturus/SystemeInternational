import UnitesDeBaseDuSI

/// The SI derived unit for plane angle.
public enum Radian: ExplicitlyInterpretedUnitProtocol, DirectlyInitializableUnitProtocol {
    public static let symbol = "rad"
    public static let scale = UnitScale.identity
    public static let semanticInterpretationToken = SemanticInterpretationToken()
    public typealias Dimension = PlaneAngleDimension
    public typealias CanonicalDimension = Dimensionless
}

/// The SI derived unit for solid angle.
public enum Steradian: ExplicitlyInterpretedUnitProtocol, DirectlyInitializableUnitProtocol {
    public static let symbol = "sr"
    public static let scale = UnitScale.identity
    public static let semanticInterpretationToken = SemanticInterpretationToken()
    public typealias Dimension = SolidAngleDimension
    public typealias CanonicalDimension = Dimensionless
}

/// The SI derived unit for frequency.
public enum Hertz: ExplicitlyInterpretedUnitProtocol, DirectlyInitializableUnitProtocol {
    public static let symbol = "Hz"
    public static let scale = UnitScale.identity
    public static let semanticInterpretationToken = SemanticInterpretationToken()
    public typealias Dimension = FrequencyDimension
    public typealias CanonicalDimension = QuotientDimension<Dimensionless, TimeDimension>
}

/// The SI derived unit for force.
public enum Newton: DirectlyInitializableUnitProtocol {
    public static let symbol = "N"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<
        QuotientDimension<ProductDimension<MassDimension, LengthDimension>, TimeDimension>,
        TimeDimension
    >
}

/// The SI derived unit for pressure and stress.
public enum Pascal: DirectlyInitializableUnitProtocol {
    public static let symbol = "Pa"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<
        QuotientDimension<Newton.Dimension, LengthDimension>, LengthDimension
    >
}

/// The SI derived unit for energy, work, and amount of heat.
public enum Joule: DirectlyInitializableUnitProtocol {
    public static let symbol = "J"
    public static let scale = UnitScale.identity
    public typealias Dimension = ProductDimension<Newton.Dimension, LengthDimension>
}

/// The SI derived unit for power and radiant flux.
public enum Watt: DirectlyInitializableUnitProtocol {
    public static let symbol = "W"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<Joule.Dimension, TimeDimension>
}

/// The SI derived unit for electric charge.
public enum Coulomb: DirectlyInitializableUnitProtocol {
    public static let symbol = "C"
    public static let scale = UnitScale.identity
    public typealias Dimension = ProductDimension<ElectricCurrentDimension, TimeDimension>
}

/// The SI derived unit for electric potential difference.
public enum Volt: DirectlyInitializableUnitProtocol {
    public static let symbol = "V"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<Watt.Dimension, ElectricCurrentDimension>
}

/// The SI derived unit for capacitance.
public enum Farad: DirectlyInitializableUnitProtocol {
    public static let symbol = "F"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<Coulomb.Dimension, Volt.Dimension>
}

/// The SI derived unit for electric resistance.
public enum Ohm: DirectlyInitializableUnitProtocol {
    public static let symbol = "Ω"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<Volt.Dimension, ElectricCurrentDimension>
}

/// The SI derived unit for electric conductance.
public enum Siemens: DirectlyInitializableUnitProtocol {
    public static let symbol = "S"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<ElectricCurrentDimension, Volt.Dimension>
}

/// The SI derived unit for magnetic flux.
public enum Weber: DirectlyInitializableUnitProtocol {
    public static let symbol = "Wb"
    public static let scale = UnitScale.identity
    public typealias Dimension = ProductDimension<Volt.Dimension, TimeDimension>
}

/// The SI derived unit for magnetic flux density.
public enum Tesla: DirectlyInitializableUnitProtocol {
    public static let symbol = "T"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<QuotientDimension<Weber.Dimension, LengthDimension>, LengthDimension>
}

/// The SI derived unit for inductance.
public enum Henry: DirectlyInitializableUnitProtocol {
    public static let symbol = "H"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<Weber.Dimension, ElectricCurrentDimension>
}

/// The SI derived unit for luminous flux.
public enum Lumen: DirectlyInitializableUnitProtocol {
    public static let symbol = "lm"
    public static let scale = UnitScale.identity
    public typealias Dimension = ProductDimension<LuminousIntensityDimension, SolidAngleDimension>
}

/// The SI derived unit for illuminance.
public enum Lux: DirectlyInitializableUnitProtocol {
    public static let symbol = "lx"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<QuotientDimension<Lumen.Dimension, LengthDimension>, LengthDimension>
}

/// The SI derived unit for activity referred to a radionuclide.
public enum Becquerel: ExplicitlyInterpretedUnitProtocol, DirectlyInitializableUnitProtocol {
    public static let symbol = "Bq"
    public static let scale = UnitScale.identity
    public static let semanticInterpretationToken = SemanticInterpretationToken()
    public typealias Dimension = RadionuclideActivityDimension
    public typealias CanonicalDimension = QuotientDimension<Dimensionless, TimeDimension>
}

/// The SI derived unit for absorbed dose.
public enum Gray: ExplicitlyInterpretedUnitProtocol, DirectlyInitializableUnitProtocol {
    public static let symbol = "Gy"
    public static let scale = UnitScale.identity
    public static let semanticInterpretationToken = SemanticInterpretationToken()
    public typealias Dimension = AbsorbedDoseDimension
    public typealias CanonicalDimension = QuotientDimension<Joule.Dimension, MassDimension>
}

/// The SI derived unit for dose equivalent and equivalent dose.
public enum Sievert: ExplicitlyInterpretedUnitProtocol, DirectlyInitializableUnitProtocol {
    public static let symbol = "Sv"
    public static let scale = UnitScale.identity
    public static let semanticInterpretationToken = SemanticInterpretationToken()
    public typealias Dimension = EquivalentDoseDimension
    public typealias CanonicalDimension = QuotientDimension<Joule.Dimension, MassDimension>
}

/// The SI derived unit for catalytic activity.
public enum Katal: DirectlyInitializableUnitProtocol {
    public static let symbol = "kat"
    public static let scale = UnitScale.identity
    public typealias Dimension = QuotientDimension<AmountOfSubstanceDimension, TimeDimension>
}

extension Quantity where Unit == CanonicalUnit<Dimensionless> {
    /// Interprets a canonical dimensionless quantity as plane angle.
    public func interpreted(as destination: Radian.Type) -> Quantity<Scalar, Radian, Space> {
        interpretedUnchecked(as: Radian.self)
    }

    /// Interprets a canonical dimensionless quantity as solid angle.
    public func interpreted(as destination: Steradian.Type) -> Quantity<Scalar, Steradian, Space> {
        interpretedUnchecked(as: Steradian.self)
    }
}

extension Quantity where Unit == CanonicalUnit<QuotientDimension<Dimensionless, TimeDimension>> {
    /// Interprets a canonical reciprocal-time quantity as frequency.
    public func interpreted(as destination: Hertz.Type) -> Quantity<Scalar, Hertz, Space> {
        interpretedUnchecked(as: Hertz.self)
    }

    /// Interprets a canonical reciprocal-time quantity as radionuclide activity.
    public func interpreted(as destination: Becquerel.Type) -> Quantity<Scalar, Becquerel, Space> {
        interpretedUnchecked(as: Becquerel.self)
    }
}

extension Quantity where Unit == CanonicalUnit<QuotientDimension<Joule.Dimension, MassDimension>> {
    /// Interprets a canonical energy-per-mass quantity as absorbed dose.
    public func interpreted(as destination: Gray.Type) -> Quantity<Scalar, Gray, Space> {
        interpretedUnchecked(as: Gray.self)
    }

    /// Interprets a canonical energy-per-mass quantity as dose equivalent.
    public func interpreted(as destination: Sievert.Type) -> Quantity<Scalar, Sievert, Space> {
        interpretedUnchecked(as: Sievert.self)
    }
}

/// Multiplies luminous intensity and solid angle while preserving the named luminous-flux unit.
public func * <Scalar>(
    lhs: Quantity<Scalar, Candela, Linear>,
    rhs: Quantity<Scalar, Steradian, Linear>
) throws -> Quantity<Scalar, Lumen, Linear>
where Scalar: FloatingPointArithmeticQuantityScalar {
    let result = lhs.baseValue * rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<Scalar, Lumen, Linear>(uncheckedBaseValue: result)
}

/// Multiplies solid angle and luminous intensity while preserving the named luminous-flux unit.
public func * <Scalar>(
    lhs: Quantity<Scalar, Steradian, Linear>,
    rhs: Quantity<Scalar, Candela, Linear>
) throws -> Quantity<Scalar, Lumen, Linear>
where Scalar: FloatingPointArithmeticQuantityScalar {
    let result = lhs.baseValue * rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<Scalar, Lumen, Linear>(uncheckedBaseValue: result)
}

/// Multiplies luminous intensity and solid angle while preserving the named luminous-flux unit when exact.
public func * <Scalar>(
    lhs: Quantity<Scalar, Candela, Linear>,
    rhs: Quantity<Scalar, Steradian, Linear>
) throws -> Quantity<Scalar, Lumen, Linear>
where Scalar: IntegerQuantityScalar {
    let product = lhs.baseValue.multipliedReportingOverflow(by: rhs.baseValue)

    guard product.overflow == false else {
        throw QuantityError.arithmeticOverflow
    }

    return Quantity<Scalar, Lumen, Linear>(uncheckedBaseValue: product.partialValue)
}

/// Multiplies solid angle and luminous intensity while preserving the named luminous-flux unit when exact.
public func * <Scalar>(
    lhs: Quantity<Scalar, Steradian, Linear>,
    rhs: Quantity<Scalar, Candela, Linear>
) throws -> Quantity<Scalar, Lumen, Linear>
where Scalar: IntegerQuantityScalar {
    let product = lhs.baseValue.multipliedReportingOverflow(by: rhs.baseValue)

    guard product.overflow == false else {
        throw QuantityError.arithmeticOverflow
    }

    return Quantity<Scalar, Lumen, Linear>(uncheckedBaseValue: product.partialValue)
}

/// Divides luminous flux by area while preserving the named illuminance unit.
public func / <Scalar>(
    lhs: Quantity<Scalar, Lumen, Linear>,
    rhs: Quantity<Scalar, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear>
) throws -> Quantity<Scalar, Lux, Linear>
where Scalar: FloatingPointArithmeticQuantityScalar {
    guard rhs.baseValue != 0 else {
        throw QuantityError.divisionByZero
    }

    let result = lhs.baseValue / rhs.baseValue
    guard result.isFinite else {
        throw QuantityError.nonFiniteValue
    }

    return Quantity<Scalar, Lux, Linear>(uncheckedBaseValue: result)
}

/// Divides luminous flux by area while preserving the named illuminance unit when exact.
public func / <Scalar>(
    lhs: Quantity<Scalar, Lumen, Linear>,
    rhs: Quantity<Scalar, CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>, Linear>
) throws -> Quantity<Scalar, Lux, Linear>
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

    return Quantity<Scalar, Lux, Linear>(uncheckedBaseValue: quotient.partialValue)
}
