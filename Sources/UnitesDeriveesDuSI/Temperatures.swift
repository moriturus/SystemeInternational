import UnitesDeBaseDuSI

/// The degree Celsius unit for thermodynamic temperature.
///
/// In affine space, degree Celsius uses a base offset of 273.15 K so that
/// 0 °C corresponds to 273.15 K. In linear space (temperature intervals),
/// the offset is ignored and 1 °C interval equals 1 K interval.
public enum DegreeCelsius: DirectlyInitializableUnitProtocol {
    public static let symbol = "°C"
    public static let scale = UnitScale.identity
    public static let baseOffset: Double = 273.15

    public typealias Dimension = TemperatureDimension
}

/// A Celsius absolute temperature.
public typealias CelsiusTemperatureValue = Quantity<Double, DegreeCelsius, Affine>

/// An absolute temperature in kelvins.
public typealias KelvinTemperatureValue = Quantity<Double, Kelvin, Affine>

/// A temperature interval in degrees Celsius.
public typealias CelsiusTemperatureDifference = Quantity<Double, DegreeCelsius, Linear>

/// A temperature interval in kelvins.
public typealias KelvinTemperatureDifference = Quantity<Double, Kelvin, Linear>
