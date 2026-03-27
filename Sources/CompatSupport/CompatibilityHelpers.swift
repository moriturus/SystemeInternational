import Foundation
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI

/// Marks a unit that can be bridged to a Foundation `Dimension`.
public protocol FoundationBridgeableUnitProtocol: UnitProtocol {
    /// Returns the Foundation unit used for compatibility conversions.
    static var foundationDimension: Foundation.Dimension { get }
}

/// Marks a directly initializable unit that can be bridged to Foundation.
public protocol FoundationBridgeableDirectUnitProtocol:
    FoundationBridgeableUnitProtocol,
    DirectlyInitializableUnitProtocol
{
}

/// Marks a semantic SI unit that can be bridged to Foundation while preserving its explicit semantics.
public protocol FoundationBridgeableSemanticUnitProtocol:
    FoundationBridgeableUnitProtocol,
    ExplicitlyInterpretedUnitProtocol
{
}

package func compatFoundationMeasurement<Unit: FoundationBridgeableUnitProtocol>(
    value: Double,
    unitType: Unit.Type = Unit.self
) throws -> Measurement<Dimension> {
    guard value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    return Measurement(value: value, unit: unitType.foundationDimension)
}

package func compatDirectQuantity<UnitType: Dimension, Unit: FoundationBridgeableDirectUnitProtocol>(
    from measurement: Measurement<UnitType>,
) throws -> Quantity<Double, Unit, Linear> {
    guard measurement.value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    guard let typedUnit = Unit.foundationDimension as? UnitType else {
        throw CompatibilityError.unsupportedMeasurement
    }
    guard sameMeasurementFamily(measurement.unit, typedUnit) else {
        throw CompatibilityError.unsupportedMeasurement
    }

    let converted = measurement.converted(to: typedUnit)
    guard converted.value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    do {
        return try Quantity<Double, Unit, Linear>(converted.value)
    } catch {
        throw CompatibilityError.nonFiniteValue
    }
}

package func compatSemanticQuantity<UnitType: Dimension, Unit: FoundationBridgeableSemanticUnitProtocol>(
    from measurement: Measurement<UnitType>
) throws -> Quantity<Double, Unit, Linear> {
    guard measurement.value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    guard let typedUnit = Unit.foundationDimension as? UnitType else {
        throw CompatibilityError.unsupportedMeasurement
    }
    guard sameMeasurementFamily(measurement.unit, typedUnit) else {
        throw CompatibilityError.unsupportedMeasurement
    }

    let converted = measurement.converted(to: typedUnit)
    guard converted.value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    let scaledBase = Unit.scale.apply(to: converted.value)
    guard scaledBase.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    let canonicalQuantity = Quantity<Double, CanonicalUnit<Unit.CanonicalDimension>, Linear>(
        uncheckedBaseValue: scaledBase
    )
    return canonicalQuantity.interpretedUnchecked(as: Unit.self)
}

package func compatFoundationMeasurementForAffineTemperature<Unit: UnitProtocol>(
    _ quantity: Quantity<Double, Unit, Affine>
) throws -> Measurement<UnitTemperature>
where Unit.Dimension == TemperatureDimension {
    let value = quantity.value
    guard value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }
    if Unit.self == Kelvin.self {
        return Measurement(value: value, unit: .kelvin)
    }
    if Unit.self == DegreeCelsius.self {
        return Measurement(value: value, unit: .celsius)
    }
    throw CompatibilityError.unsupportedUnit
}

package func compatFoundationMeasurementComponentsForLinearTemperature<Unit: UnitProtocol>(
    _ quantity: Quantity<Double, Unit, Linear>
) throws -> (value: Double, unit: UnitTemperature)
where Unit.Dimension == TemperatureDimension {
    let value = quantity.value
    if Unit.self == Kelvin.self {
        return (value, .kelvin)
    }
    if Unit.self == DegreeCelsius.self {
        return (value, .celsius)
    }
    throw CompatibilityError.unsupportedUnit
}

package func compatAffineTemperature<Unit: DirectlyInitializableUnitProtocol>(
    from measurement: Measurement<UnitTemperature>,
    as destination: Unit.Type
) throws -> Quantity<Double, Unit, Affine>
where Unit.Dimension == TemperatureDimension {
    guard measurement.value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    let convertedValue: Double

    if destination == Kelvin.self {
        convertedValue = measurement.converted(to: .kelvin).value
    } else if destination == DegreeCelsius.self {
        convertedValue = measurement.converted(to: .celsius).value
    } else {
        throw CompatibilityError.unsupportedUnit
    }

    guard convertedValue.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    do {
        return try Quantity<Double, Unit, Affine>(convertedValue)
    } catch QuantityError.nonFiniteValue {
        throw CompatibilityError.nonFiniteValue
    } catch {
        throw CompatibilityError.semanticMismatch
    }
}

package func compatLinearTemperature<Unit: DirectlyInitializableUnitProtocol>(
    from measurement: Measurement<UnitTemperature>,
    as destination: Unit.Type
) throws -> Quantity<Double, Unit, Linear>
where Unit.Dimension == TemperatureDimension {
    guard destination == Kelvin.self || destination == DegreeCelsius.self else {
        throw CompatibilityError.unsupportedUnit
    }

    guard measurement.value.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    // For intervals, kelvin and celsius have the same magnitude (1K interval = 1°C interval)
    let kelvinIntervalValue: Double

    // Foundation's UnitTemperature singletons are compared by value equality
    // (symbol + converter). Custom instances with different converters will NOT match.
    if measurement.unit == .kelvin || measurement.unit == .celsius {
        kelvinIntervalValue = measurement.value
    } else {
        throw CompatibilityError.unsupportedMeasurement
    }

    guard kelvinIntervalValue.isFinite else {
        throw CompatibilityError.nonFiniteValue
    }

    do {
        return try Quantity<Double, Unit, Linear>(kelvinIntervalValue)
    } catch {
        throw CompatibilityError.nonFiniteValue
    }
}

private func sameMeasurementFamily(_ lhs: Dimension, _ rhs: Dimension) -> Bool {
    ObjectIdentifier(type(of: type(of: lhs).baseUnit())) == ObjectIdentifier(type(of: type(of: rhs).baseUnit()))
}
