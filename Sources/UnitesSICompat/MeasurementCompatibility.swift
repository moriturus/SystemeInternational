import CompatSupport
import Foundation
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI
import UnitesSI

extension Quantity where Scalar == Double, Unit: FoundationBridgeableUnitProtocol, Space == Linear {
    /// Converts a Foundation-bridgeable SI quantity into a Foundation measurement.
    public func foundationMeasurement() throws -> Measurement<Dimension> {
        try compatFoundationMeasurement(value: value, unitType: Unit.self)
    }
}

extension Measurement where UnitType: Dimension {
    /// Converts a Foundation measurement into a directly initializable SI quantity of the requested unit type.
    public func siQuantity<Unit: FoundationBridgeableDirectUnitProtocol>(
        as destination: Unit.Type
    ) throws -> Quantity<Double, Unit, Linear> {
        try compatDirectQuantity(from: self)
    }
}

extension Measurement where UnitType: Dimension {
    /// Converts a Foundation measurement into a semantic SI angle quantity.
    public func siQuantity(as destination: Radian.Type) throws -> Quantity<Double, Radian, Linear> {
        try compatSemanticQuantity(from: self)
    }

    /// Converts a Foundation measurement into a semantic SI solid-angle quantity.
    public func siQuantity(as destination: Steradian.Type) throws -> Quantity<Double, Steradian, Linear> {
        try compatSemanticQuantity(from: self)
    }

    /// Converts a Foundation measurement into a semantic SI frequency quantity.
    public func siQuantity(as destination: Hertz.Type) throws -> Quantity<Double, Hertz, Linear> {
        try compatSemanticQuantity(from: self)
    }

    /// Converts a Foundation measurement into a semantic SI activity quantity.
    public func siQuantity(as destination: Becquerel.Type) throws -> Quantity<Double, Becquerel, Linear> {
        try compatSemanticQuantity(from: self)
    }

    /// Converts a Foundation measurement into a semantic SI absorbed-dose quantity.
    public func siQuantity(as destination: Gray.Type) throws -> Quantity<Double, Gray, Linear> {
        try compatSemanticQuantity(from: self)
    }

    /// Converts a Foundation measurement into a semantic SI equivalent-dose quantity.
    public func siQuantity(as destination: Sievert.Type) throws -> Quantity<Double, Sievert, Linear> {
        try compatSemanticQuantity(from: self)
    }
}

extension Quantity where Scalar == Double, Unit.Dimension == TemperatureDimension, Space == Affine {
    /// Converts an affine temperature quantity into a Foundation measurement.
    public func foundationMeasurement() throws -> Measurement<UnitTemperature> {
        try compatFoundationMeasurementForAffineTemperature(self)
    }
}

extension Measurement where UnitType == UnitTemperature {
    /// Converts a Foundation temperature measurement into an SI affine temperature quantity.
    public func absoluteTemperature<Unit: DirectlyInitializableUnitProtocol>(
        as destination: Unit.Type
    ) throws -> Quantity<Double, Unit, Affine>
    where Unit.Dimension == TemperatureDimension {
        try compatAffineTemperature(from: self, as: destination)
    }

    /// Converts a Foundation temperature measurement into an SI linear temperature quantity.
    public func temperatureInterval<Unit: DirectlyInitializableUnitProtocol>(
        as destination: Unit.Type
    ) throws -> Quantity<Double, Unit, Linear>
    where Unit.Dimension == TemperatureDimension {
        try compatLinearTemperature(from: self, as: destination)
    }
}

extension Quantity where Scalar == Double, Unit.Dimension == TemperatureDimension, Space == Linear {
    /// Returns a raw Foundation-compatible representation for a temperature interval without offset-based conversion.
    public func foundationMeasurementComponents() throws -> (value: Double, unit: UnitTemperature) {
        try compatFoundationMeasurementComponentsForLinearTemperature(self)
    }
}

extension Meter: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitLength.meters
}

/// Describes an SI base unit that can create Foundation dimensions for official prefixed variants.
public protocol FoundationBridgeableSIPrefixedBaseUnitProtocol:
    DirectlyInitializableUnitProtocol,
    SIPrefixableUnitProtocol
{
    /// Creates the Foundation dimension corresponding to `Prefix` applied to this base unit.
    static func makeFoundationDimension<Prefix: OfficialSIPrefixProtocol>(
        for prefix: Prefix.Type
    ) -> Foundation.Dimension
}

extension SIPrefixedUnit: FoundationBridgeableUnitProtocol
where Base: FoundationBridgeableSIPrefixedBaseUnitProtocol {
    public static var foundationDimension: Foundation.Dimension {
        Base.makeFoundationDimension(for: Prefix.self)
    }
}

extension SIPrefixedUnit: FoundationBridgeableDirectUnitProtocol
where Base: FoundationBridgeableSIPrefixedBaseUnitProtocol {}

extension Meter: FoundationBridgeableSIPrefixedBaseUnitProtocol {
    public static func makeFoundationDimension<Prefix: OfficialSIPrefixProtocol>(
        for prefix: Prefix.Type
    ) -> Foundation.Dimension {
        UnitLength(
            symbol: Prefix.symbol + symbol,
            converter: UnitConverterLinear(coefficient: PrefixScaleCoefficient.value(for: Prefix.self))
        )
    }
}

extension Second: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitDuration.seconds
}

extension Second: FoundationBridgeableSIPrefixedBaseUnitProtocol {
    public static func makeFoundationDimension<Prefix: OfficialSIPrefixProtocol>(
        for prefix: Prefix.Type
    ) -> Foundation.Dimension {
        UnitDuration(
            symbol: Prefix.symbol + symbol,
            converter: UnitConverterLinear(coefficient: PrefixScaleCoefficient.value(for: Prefix.self))
        )
    }
}

extension Kilogram: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitMass.kilograms
}

extension Ampere: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitElectricCurrent.amperes
}

extension Ampere: FoundationBridgeableSIPrefixedBaseUnitProtocol {
    public static func makeFoundationDimension<Prefix: OfficialSIPrefixProtocol>(
        for prefix: Prefix.Type
    ) -> Foundation.Dimension {
        UnitElectricCurrent(
            symbol: Prefix.symbol + symbol,
            converter: UnitConverterLinear(coefficient: PrefixScaleCoefficient.value(for: Prefix.self))
        )
    }
}

extension Mole: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitAmountOfSubstance.moles
}

extension Mole: FoundationBridgeableSIPrefixedBaseUnitProtocol {
    public static func makeFoundationDimension<Prefix: OfficialSIPrefixProtocol>(
        for prefix: Prefix.Type
    ) -> Foundation.Dimension {
        UnitAmountOfSubstance(
            symbol: Prefix.symbol + symbol,
            converter: UnitConverterLinear(coefficient: PrefixScaleCoefficient.value(for: Prefix.self))
        )
    }
}

extension Coulomb: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitElectricCharge.coulombs
}

extension Volt: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitElectricPotentialDifference.volts
}

extension Ohm: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitElectricResistance.ohms
}

extension Joule: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitEnergy.joules
}

extension Watt: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitPower.watts
}

extension Pascal: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitPressure.newtonsPerMetersSquared
}

extension Lux: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitIlluminance.lux
}

extension Farad: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitElectricCapacitance.farads
}

extension Siemens: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitElectricConductance.siemens
}

extension Weber: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitMagneticFlux.webers
}

extension Tesla: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitMagneticFluxDensity.teslas
}

extension Henry: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitInductance.henries
}

extension Lumen: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitLuminousFlux.lumens
}

extension Katal: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitCatalyticActivity.katals
}

extension Radian: FoundationBridgeableSemanticUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitPlaneAngle.radians
}

extension Steradian: FoundationBridgeableSemanticUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitSolidAngle.steradians
}

extension Hertz: FoundationBridgeableSemanticUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitFrequency.hertz
}

extension Becquerel: FoundationBridgeableSemanticUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitRadioactivity.becquerels
}

extension Gray: FoundationBridgeableSemanticUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitAbsorbedDose.grays
}

extension Sievert: FoundationBridgeableSemanticUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitDoseEquivalent.sieverts
}

private enum PrefixScaleCoefficient {
    static func value<Prefix: OfficialSIPrefixProtocol>(for prefix: Prefix.Type) -> Double {
        pow(10, Double(prefix.scale.exponent))
    }
}
