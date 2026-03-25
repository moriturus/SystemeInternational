import Foundation

// Safety: All custom Dimension subclasses are final classes with no mutable stored properties.
// They are effectively immutable singletons, making @unchecked Sendable safe.

/// A Foundation-compatible unit family for amount of substance.
public final class UnitAmountOfSubstance: Dimension, @unchecked Sendable {
    // Safety: This class is final, so Self is always this concrete type. The force cast cannot fail.
    public override class func baseUnit() -> Self {
        self.moles as! Self
    }

    public static let moles = UnitAmountOfSubstance(
        symbol: "mol",
        converter: UnitConverterLinear(coefficient: 1)
    )
    public static let millimoles = UnitAmountOfSubstance(
        symbol: "mmol",
        converter: UnitConverterLinear(coefficient: 0.001)
    )
}

/// A Foundation-compatible unit family for plane angle.
public final class UnitPlaneAngle: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.radians as! Self
    }

    public static let radians = UnitPlaneAngle(
        symbol: "rad",
        converter: UnitConverterLinear(coefficient: 1)
    )

    public static let degrees = UnitPlaneAngle(
        symbol: "°",
        converter: UnitConverterLinear(coefficient: Double.pi / 180)
    )

    public static let arcMinutes = UnitPlaneAngle(
        symbol: "′",
        converter: UnitConverterLinear(coefficient: Double.pi / 10_800)
    )

    public static let arcSeconds = UnitPlaneAngle(
        symbol: "″",
        converter: UnitConverterLinear(coefficient: Double.pi / 648_000)
    )
}

/// A Foundation-compatible unit family for solid angle.
public final class UnitSolidAngle: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.steradians as! Self
    }

    public static let steradians = UnitSolidAngle(
        symbol: "sr",
        converter: UnitConverterLinear(coefficient: 1)
    )
}

/// A Foundation-compatible unit family for electric capacitance.
public final class UnitElectricCapacitance: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.farads as! Self
    }

    public static let farads = UnitElectricCapacitance(
        symbol: "F",
        converter: UnitConverterLinear(coefficient: 1)
    )
    public static let microfarads = UnitElectricCapacitance(
        symbol: "μF",
        converter: UnitConverterLinear(coefficient: 0.000_001)
    )
}

/// A Foundation-compatible unit family for electric conductance.
public final class UnitElectricConductance: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.siemens as! Self
    }

    public static let siemens = UnitElectricConductance(
        symbol: "S",
        converter: UnitConverterLinear(coefficient: 1)
    )
}

/// A Foundation-compatible unit family for magnetic flux.
public final class UnitMagneticFlux: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.webers as! Self
    }

    public static let webers = UnitMagneticFlux(
        symbol: "Wb",
        converter: UnitConverterLinear(coefficient: 1)
    )
}

/// A Foundation-compatible unit family for magnetic flux density.
public final class UnitMagneticFluxDensity: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.teslas as! Self
    }

    public static let teslas = UnitMagneticFluxDensity(
        symbol: "T",
        converter: UnitConverterLinear(coefficient: 1)
    )
    public static let milliteslas = UnitMagneticFluxDensity(
        symbol: "mT",
        converter: UnitConverterLinear(coefficient: 0.001)
    )
}

/// A Foundation-compatible unit family for inductance.
public final class UnitInductance: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.henries as! Self
    }

    public static let henries = UnitInductance(
        symbol: "H",
        converter: UnitConverterLinear(coefficient: 1)
    )
}

/// A Foundation-compatible unit family for luminous flux.
public final class UnitLuminousFlux: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.lumens as! Self
    }

    public static let lumens = UnitLuminousFlux(
        symbol: "lm",
        converter: UnitConverterLinear(coefficient: 1)
    )
}

/// A Foundation-compatible unit family for radioactivity.
public final class UnitRadioactivity: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.becquerels as! Self
    }

    public static let becquerels = UnitRadioactivity(
        symbol: "Bq",
        converter: UnitConverterLinear(coefficient: 1)
    )
    public static let kilobecquerels = UnitRadioactivity(
        symbol: "kBq",
        converter: UnitConverterLinear(coefficient: 1_000)
    )
}

/// A Foundation-compatible unit family for absorbed dose.
public final class UnitAbsorbedDose: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.grays as! Self
    }

    public static let grays = UnitAbsorbedDose(
        symbol: "Gy",
        converter: UnitConverterLinear(coefficient: 1)
    )
}

/// A Foundation-compatible unit family for dose equivalent.
public final class UnitDoseEquivalent: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.sieverts as! Self
    }

    public static let sieverts = UnitDoseEquivalent(
        symbol: "Sv",
        converter: UnitConverterLinear(coefficient: 1)
    )
    public static let millisieverts = UnitDoseEquivalent(
        symbol: "mSv",
        converter: UnitConverterLinear(coefficient: 0.001)
    )
}

/// A Foundation-compatible unit family for catalytic activity.
public final class UnitCatalyticActivity: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.katals as! Self
    }

    public static let katals = UnitCatalyticActivity(
        symbol: "kat",
        converter: UnitConverterLinear(coefficient: 1)
    )
}

/// A Foundation-compatible unit family for logarithmic ratio.
public final class UnitLogarithmicRatio: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> Self {
        self.nepers as! Self
    }

    public static let nepers = UnitLogarithmicRatio(
        symbol: "Np",
        converter: UnitConverterLinear(coefficient: 1)
    )

    public static let bels = UnitLogarithmicRatio(
        symbol: "B",
        converter: UnitConverterLinear(coefficient: log(10.0) / 2.0)
    )
}

package let unitDurationHours = UnitDuration(
    symbol: "h",
    converter: UnitConverterLinear(coefficient: 3_600)
)

package let unitDurationDays = UnitDuration(
    symbol: "d",
    converter: UnitConverterLinear(coefficient: 86_400)
)

package let unitLengthAstronomicalUnits = UnitLength(
    symbol: "au",
    converter: UnitConverterLinear(coefficient: 149_597_870_700)
)

package let unitEnergyElectronVolts = UnitEnergy(
    symbol: "eV",
    converter: UnitConverterLinear(coefficient: 0.000_000_000_000_000_000_160_217_663_4)
)

package let unitMassDaltons = UnitMass(
    symbol: "Da",
    converter: UnitConverterLinear(coefficient: 0.000_000_000_000_000_000_000_000_001_660_539_066_60)
)
