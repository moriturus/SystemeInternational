import UtiliseesNonSI

extension FloatingPointQuantityScalar {
    // MARK: - SI base units

    /// Creates a linear quantity expressed in meters.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var meter: Quantity<Self, Meter, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in seconds.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var second: Quantity<Self, Second, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in amperes.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var ampere: Quantity<Self, Ampere, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in kelvins.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var kelvin: Quantity<Self, Kelvin, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in moles.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var mole: Quantity<Self, Mole, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in candelas.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var candela: Quantity<Self, Candela, Linear> {
        get throws {
            try .init(self)
        }
    }

    // MARK: - Mass

    /// Creates a linear quantity expressed in grams.
    ///
    /// This refers to `Gram`, the prefixable mass unit used to form prefixed mass units.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var gram: Quantity<Self, Gram, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in kilograms.
    ///
    /// This is the canonical SI base unit for mass.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var kilogram: Quantity<Self, Kilogram, Linear> {
        get throws {
            try .init(self)
        }
    }

    // MARK: - SI derived units

    /// Creates a linear quantity expressed in newtons.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var newton: Quantity<Self, Newton, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in pascals.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var pascal: Quantity<Self, Pascal, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in joules.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var joule: Quantity<Self, Joule, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in watts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var watt: Quantity<Self, Watt, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in coulombs.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var coulomb: Quantity<Self, Coulomb, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in volts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var volt: Quantity<Self, Volt, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in farads.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var farad: Quantity<Self, Farad, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in ohms.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var ohm: Quantity<Self, Ohm, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in siemens.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var siemens: Quantity<Self, Siemens, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in webers.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var weber: Quantity<Self, Weber, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in teslas.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var tesla: Quantity<Self, Tesla, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in henries.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var henry: Quantity<Self, Henry, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in lumens.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var lumen: Quantity<Self, Lumen, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in lux.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var lux: Quantity<Self, Lux, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in katals.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var katal: Quantity<Self, Katal, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in hertz.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var hertz: Quantity<Self, Hertz, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in becquerels.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var becquerel: Quantity<Self, Becquerel, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in grays.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var gray: Quantity<Self, Gray, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in sieverts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var sievert: Quantity<Self, Sievert, Linear> {
        get throws {
            try .init(self)
        }
    }

    // MARK: - Accepted non-SI units

    /// Creates a linear quantity expressed in tonnes.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var tonne: Quantity<Self, Tonne, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in daltons.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var dalton: Quantity<Self, Dalton, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in electronvolts.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var electronVolt: Quantity<Self, ElectronVolt, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in liters.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var liter: Quantity<Self, Liter, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in bels.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var bel: Quantity<Self, Bel, Linear> {
        get throws {
            try .init(self)
        }
    }

    // MARK: - Accepted standalone shorthand units

    /// Creates a linear quantity expressed in minutes.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var minute: Quantity<Self, Minute, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in hours.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var hour: Quantity<Self, Hour, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in days.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var day: Quantity<Self, Day, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in hectares.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var hectare: Quantity<Self, Hectare, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in astronomical units.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var astronomicalUnit: Quantity<Self, AstronomicalUnit, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in degrees.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var degree: Quantity<Self, Degree, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in arcminutes.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var arcminute: Quantity<Self, Arcminute, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in arcseconds.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var arcsecond: Quantity<Self, Arcsecond, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in radians.
    ///
    /// `radian` is an explicitly named semantic unit and remains available as direct shorthand.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var radian: Quantity<Self, Radian, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in steradians.
    ///
    /// `steradian` is an explicitly named semantic unit and remains available as direct shorthand.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var steradian: Quantity<Self, Steradian, Linear> {
        get throws {
            try .init(self)
        }
    }

    /// Creates a linear quantity expressed in nepers.
    ///
    /// `neper` is an explicitly named semantic unit and remains available as direct shorthand.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `self` is infinity or NaN.
    @inlinable
    public var neper: Quantity<Self, Neper, Linear> {
        get throws {
            try .init(self)
        }
    }
}

extension BinaryInteger {
    /// Creates a linear quantity expressed in meters.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var meter: Quantity<Double, Meter, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in seconds.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var second: Quantity<Double, Second, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in amperes.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var ampere: Quantity<Double, Ampere, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in kelvins.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var kelvin: Quantity<Double, Kelvin, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in moles.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var mole: Quantity<Double, Mole, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in candelas.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var candela: Quantity<Double, Candela, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in grams.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var gram: Quantity<Double, Gram, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in kilograms.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var kilogram: Quantity<Double, Kilogram, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in newtons.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var newton: Quantity<Double, Newton, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in pascals.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var pascal: Quantity<Double, Pascal, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in joules.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var joule: Quantity<Double, Joule, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in watts.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var watt: Quantity<Double, Watt, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in coulombs.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var coulomb: Quantity<Double, Coulomb, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in volts.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var volt: Quantity<Double, Volt, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in farads.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var farad: Quantity<Double, Farad, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in ohms.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var ohm: Quantity<Double, Ohm, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in siemens.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var siemens: Quantity<Double, Siemens, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in webers.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var weber: Quantity<Double, Weber, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in teslas.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var tesla: Quantity<Double, Tesla, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in henries.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var henry: Quantity<Double, Henry, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in lumens.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var lumen: Quantity<Double, Lumen, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in lux.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var lux: Quantity<Double, Lux, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in katals.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var katal: Quantity<Double, Katal, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in hertz.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var hertz: Quantity<Double, Hertz, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in becquerels.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var becquerel: Quantity<Double, Becquerel, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in grays.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var gray: Quantity<Double, Gray, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in sieverts.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var sievert: Quantity<Double, Sievert, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in tonnes.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var tonne: Quantity<Double, Tonne, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in daltons.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var dalton: Quantity<Double, Dalton, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in electronvolts.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var electronVolt: Quantity<Double, ElectronVolt, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in liters.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var liter: Quantity<Double, Liter, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in bels.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var bel: Quantity<Double, Bel, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in minutes.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var minute: Quantity<Double, Minute, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in hours.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var hour: Quantity<Double, Hour, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in days.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var day: Quantity<Double, Day, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in hectares.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var hectare: Quantity<Double, Hectare, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in astronomical units.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var astronomicalUnit: Quantity<Double, AstronomicalUnit, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in degrees.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var degree: Quantity<Double, Degree, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in arcminutes.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var arcminute: Quantity<Double, Arcminute, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in arcseconds.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var arcsecond: Quantity<Double, Arcsecond, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in radians.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var radian: Quantity<Double, Radian, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in steradians.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var steradian: Quantity<Double, Steradian, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

    /// Creates a linear quantity expressed in nepers.
    ///
    /// Integer shorthand widens the scalar to `Double` before constructing the quantity.
    ///
    /// - Throws: `QuantityError.nonFiniteValue` when `Double(self)` would become a non-finite value.
    @inlinable
    public var neper: Quantity<Double, Neper, Linear> {
        get throws {
            try .init(Double(self))
        }
    }

}
