import CompatSupport
import Foundation
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI
@_exported import UnitesSICompat
@_exported import UtiliseesNonSI

extension UnitDuration {
    /// A Foundation-compatible day unit using the same symbol as the library model.
    public static var days: UnitDuration {
        unitDurationDays
    }
}

extension UnitEnergy {
    /// A Foundation-compatible electron-volt unit using the same symbol as the library model.
    public static var electronVolts: UnitEnergy {
        unitEnergyElectronVolts
    }
}

extension UnitMass {
    /// A Foundation-compatible dalton unit using the same symbol as the library model.
    public static var daltons: UnitMass {
        unitMassDaltons
    }
}

extension Minute: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitDuration.minutes
}

extension Hour: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = unitDurationHours
}

extension Day: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = unitDurationDays
}

extension Tonne: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitMass.metricTons
}

extension Hectare: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitArea.hectares
}

extension AstronomicalUnit: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = unitLengthAstronomicalUnits
}

extension ElectronVolt: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = unitEnergyElectronVolts
}

extension Dalton: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = unitMassDaltons
}

extension Liter: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitVolume.liters
}

extension Degree: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitPlaneAngle.degrees
}

extension Arcminute: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitPlaneAngle.arcMinutes
}

extension Arcsecond: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitPlaneAngle.arcSeconds
}

extension Neper: FoundationBridgeableSemanticUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitLogarithmicRatio.nepers
}

extension Bel: FoundationBridgeableDirectUnitProtocol {
    public static let foundationDimension: Foundation.Dimension = UnitLogarithmicRatio.bels
}

extension Bel: FoundationBridgeableSIPrefixedBaseUnitProtocol {
    public static func makeFoundationDimension<Prefix: OfficialSIPrefixProtocol>(
        for prefix: Prefix.Type
    ) -> Foundation.Dimension {
        let belCoefficient = log(10.0) / 2.0
        let prefixCoefficient = pow(10.0, Double(prefix.scale.exponent))
        return UnitLogarithmicRatio(
            symbol: Prefix.symbol + symbol,
            converter: UnitConverterLinear(coefficient: belCoefficient * prefixCoefficient)
        )
    }
}

extension Measurement where UnitType: Dimension {
    /// Converts a Foundation measurement into a semantic SI logarithmic-ratio quantity.
    public func siQuantity(as destination: Neper.Type) throws -> Quantity<Double, Neper, Linear> {
        try compatSemanticQuantity(from: self)
    }
}
