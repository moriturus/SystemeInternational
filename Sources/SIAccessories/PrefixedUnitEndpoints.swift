extension PrefixedScalar {
    /// Materializes a prefixed quantity for a unit that is explicitly eligible for SI prefixes.
    ///
    /// Units that are not `SIPrefixableUnitProtocol` are intentionally absent from the
    /// `value.prefix.unit` DSL surface, so invalid chains such as `value.mega.kilogram`
    /// remain unrepresentable at compile time.
    @inlinable
    func quantity<Unit>(for unit: Unit.Type = Unit.self) throws -> Quantity<
        Scalar, SIPrefixedUnit<Unit, Prefix>, Linear
    >
    where Unit: DirectlyInitializableUnitProtocol & SIPrefixableUnitProtocol {
        try .init(value)
    }
}

extension PrefixedScalar {
    /// Creates a quantity in prefixed meters.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var meter: Quantity<Scalar, SIPrefixedUnit<Meter, Prefix>, Linear> {
        get throws {
            try quantity(for: Meter.self)
        }
    }

    /// Creates a quantity in prefixed seconds.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var second: Quantity<Scalar, SIPrefixedUnit<Second, Prefix>, Linear> {
        get throws {
            try quantity(for: Second.self)
        }
    }

    /// Creates a quantity in prefixed amperes.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var ampere: Quantity<Scalar, SIPrefixedUnit<Ampere, Prefix>, Linear> {
        get throws {
            try quantity(for: Ampere.self)
        }
    }

    /// Creates a quantity in prefixed kelvins.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var kelvin: Quantity<Scalar, SIPrefixedUnit<Kelvin, Prefix>, Linear> {
        get throws {
            try quantity(for: Kelvin.self)
        }
    }

    /// Creates a quantity in prefixed moles.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var mole: Quantity<Scalar, SIPrefixedUnit<Mole, Prefix>, Linear> {
        get throws {
            try quantity(for: Mole.self)
        }
    }

    /// Creates a quantity in prefixed candelas.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var candela: Quantity<Scalar, SIPrefixedUnit<Candela, Prefix>, Linear> {
        get throws {
            try quantity(for: Candela.self)
        }
    }

    /// Creates a quantity in prefixed grams.
    ///
    /// This endpoint applies the chosen prefix to `Gram`, so `value.kilo.gram` produces the kilogram type.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var gram: Quantity<Scalar, SIPrefixedUnit<Gram, Prefix>, Linear> {
        get throws {
            try quantity(for: Gram.self)
        }
    }

    /// Creates a quantity in prefixed newtons.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var newton: Quantity<Scalar, SIPrefixedUnit<Newton, Prefix>, Linear> {
        get throws {
            try quantity(for: Newton.self)
        }
    }

    /// Creates a quantity in prefixed pascals.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var pascal: Quantity<Scalar, SIPrefixedUnit<Pascal, Prefix>, Linear> {
        get throws {
            try quantity(for: Pascal.self)
        }
    }

    /// Creates a quantity in prefixed joules.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var joule: Quantity<Scalar, SIPrefixedUnit<Joule, Prefix>, Linear> {
        get throws {
            try quantity(for: Joule.self)
        }
    }

    /// Creates a quantity in prefixed watts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var watt: Quantity<Scalar, SIPrefixedUnit<Watt, Prefix>, Linear> {
        get throws {
            try quantity(for: Watt.self)
        }
    }

    /// Creates a quantity in prefixed coulombs.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var coulomb: Quantity<Scalar, SIPrefixedUnit<Coulomb, Prefix>, Linear> {
        get throws {
            try quantity(for: Coulomb.self)
        }
    }

    /// Creates a quantity in prefixed volts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var volt: Quantity<Scalar, SIPrefixedUnit<Volt, Prefix>, Linear> {
        get throws {
            try quantity(for: Volt.self)
        }
    }

    /// Creates a quantity in prefixed farads.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var farad: Quantity<Scalar, SIPrefixedUnit<Farad, Prefix>, Linear> {
        get throws {
            try quantity(for: Farad.self)
        }
    }

    /// Creates a quantity in prefixed ohms.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var ohm: Quantity<Scalar, SIPrefixedUnit<Ohm, Prefix>, Linear> {
        get throws {
            try quantity(for: Ohm.self)
        }
    }

    /// Creates a quantity in prefixed siemens.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var siemens: Quantity<Scalar, SIPrefixedUnit<Siemens, Prefix>, Linear> {
        get throws {
            try quantity(for: Siemens.self)
        }
    }

    /// Creates a quantity in prefixed webers.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var weber: Quantity<Scalar, SIPrefixedUnit<Weber, Prefix>, Linear> {
        get throws {
            try quantity(for: Weber.self)
        }
    }

    /// Creates a quantity in prefixed teslas.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var tesla: Quantity<Scalar, SIPrefixedUnit<Tesla, Prefix>, Linear> {
        get throws {
            try quantity(for: Tesla.self)
        }
    }

    /// Creates a quantity in prefixed henries.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var henry: Quantity<Scalar, SIPrefixedUnit<Henry, Prefix>, Linear> {
        get throws {
            try quantity(for: Henry.self)
        }
    }

    /// Creates a quantity in prefixed lumens.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var lumen: Quantity<Scalar, SIPrefixedUnit<Lumen, Prefix>, Linear> {
        get throws {
            try quantity(for: Lumen.self)
        }
    }

    /// Creates a quantity in prefixed lux.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var lux: Quantity<Scalar, SIPrefixedUnit<Lux, Prefix>, Linear> {
        get throws {
            try quantity(for: Lux.self)
        }
    }

    /// Creates a quantity in prefixed katals.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var katal: Quantity<Scalar, SIPrefixedUnit<Katal, Prefix>, Linear> {
        get throws {
            try quantity(for: Katal.self)
        }
    }

    /// Creates a quantity in prefixed hertz.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var hertz: Quantity<Scalar, SIPrefixedUnit<Hertz, Prefix>, Linear> {
        get throws {
            try quantity(for: Hertz.self)
        }
    }

    /// Creates a quantity in prefixed becquerels.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var becquerel: Quantity<Scalar, SIPrefixedUnit<Becquerel, Prefix>, Linear> {
        get throws {
            try quantity(for: Becquerel.self)
        }
    }

    /// Creates a quantity in prefixed gray.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var gray: Quantity<Scalar, SIPrefixedUnit<Gray, Prefix>, Linear> {
        get throws {
            try quantity(for: Gray.self)
        }
    }

    /// Creates a quantity in prefixed sieverts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var sievert: Quantity<Scalar, SIPrefixedUnit<Sievert, Prefix>, Linear> {
        get throws {
            try quantity(for: Sievert.self)
        }
    }

    /// Creates a quantity in prefixed tonnes.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var tonne: Quantity<Scalar, SIPrefixedUnit<Tonne, Prefix>, Linear> {
        get throws {
            try quantity(for: Tonne.self)
        }
    }

    /// Creates a quantity in prefixed daltons.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var dalton: Quantity<Scalar, SIPrefixedUnit<Dalton, Prefix>, Linear> {
        get throws {
            try quantity(for: Dalton.self)
        }
    }

    /// Creates a quantity in prefixed electronvolts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var electronVolt: Quantity<Scalar, SIPrefixedUnit<ElectronVolt, Prefix>, Linear> {
        get throws {
            try quantity(for: ElectronVolt.self)
        }
    }

    /// Creates a quantity in prefixed liters.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var liter: Quantity<Scalar, SIPrefixedUnit<Liter, Prefix>, Linear> {
        get throws {
            try quantity(for: Liter.self)
        }
    }

    /// Creates a quantity in prefixed bels.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `value` is infinity or NaN.
    public var bel: Quantity<Scalar, SIPrefixedUnit<Bel, Prefix>, Linear> {
        get throws {
            try quantity(for: Bel.self)
        }
    }

}
