# SystemeInternational

A type-safe SI unit system for Swift — catch unit misuse at compile time, not at runtime.

![Swift 6.2](https://img.shields.io/badge/Swift-6.2-F05138?logo=swift&logoColor=white)
![License](https://img.shields.io/badge/License-Apache%202.0-blue)

## Overview

`SystemeInternational` models physical quantities, units, and dimensions using Swift's strong type system. Units are marker types — you never instantiate `Meter()` directly; instead you write `Quantity<Double, Meter, Linear>` or refer to `Meter.self`.

Key characteristics:

- Different physical meanings are different types — no raw `Double` or `typealias` ambiguity
- Unit conversions are type-checked and use exact rational scale metadata
- Named SI derived units with distinct semantics (`Hertz` vs `Becquerel`) are never implicitly convertible
- Affine-space algebra distinguishes absolute positions (points) from intervals (vectors) at compile time
- Temperature uses the same unified `Quantity` type with a `Space` parameter, not a separate type hierarchy
- Foundation `Measurement` interoperability is available through dedicated compatibility modules

## Requirements

- Swift 6.2+

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/moriturus/SystemeInternational.git", from: "0.1.0"),
]
```

Then add the modules you need to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "UnitesSI", package: "SystemeInternational"),
    ]
)
```

## Modules

| Module | Description |
|---|---|
| `UnitesSI` | Main SI facade — re-exports base, prefix, and derived modules with prefixed aliases |
| `UnitesDeBaseDuSI` | Core type system: dimensions, quantities, scales, and SI base units |
| `PrefixesDuSI` | SI prefix metadata (symbol and decimal exponent) |
| `UnitesDeriveesDuSI` | Named SI derived units and temperature units |
| `UnitesSICompat` | Foundation `Measurement` / `Dimension` bridge for SI types |
| `UtiliseesNonSI` | Units accepted for use with the SI (time, mass, angle, volume, etc.) |
| `UtiliseesNonSICompat` | Foundation bridge for accepted non-SI units (re-exports `UnitesSICompat`) |
| `SIAccessories` | Opt-in shorthand DSL (`value.prefix.unit` / `value.unit`) built on `UtiliseesNonSI` |

For most use cases, `import UnitesSI` is sufficient. Use `UtiliseesNonSI` when you need units like `Hour`, `Degree`, or `Liter`. Add the `Compat` variants when you need Foundation interoperability.

## Usage

### Floating-Point Quantities

```swift
import UnitesSI

let commute = try Quantity<Double, Kilometer, Linear>(2.4)
let commuteInMeters = commute.converted(to: Meter.self)

print(commuteInMeters.value)     // 2400.0
```

### `SIAccessories` shorthand DSL

```swift
import SIAccessories

let distance = try 10.0.kilo.meter
let packageMass = try 2.0.kilogram
let tabletMass = try 20.0.milli.gram
let shipmentMass = try 3.0.kilo.gram
let duration = try 5.0.second
let volume = try 1.5.milli.liter
let signal = try 6.0.deci.bel
let integerDistance = try 1.kilo.meter
```

`SIAccessories` is an opt-in convenience module. It re-exports `UtiliseesNonSI`, so one import enables shorthand for both SI units and accepted non-SI units such as `liter`, `minute`, and `bel`.

The shorthand surface always produces `Linear` quantities. Floating-point inputs preserve their scalar type, while integer shorthand widens to `Double` by default, so `try 1.kilo.meter` produces `Quantity<Double, Kilometer, Linear>`.

Mass follows SI convention:

- use `try 1.0.kilogram` for the canonical base unit
- use `try 1.0.kilo.gram` for the prefixed-gram spelling of the same quantity
- use `try 20.0.gram` for grams

`kilogram` is intentionally direct-only. It is not exposed after a prefix, so invalid chains such as `try 1.0.mega.kilogram` remain compile-time errors. Shorthand accessors propagate `QuantityError.nonFiniteValue` to the caller when the scalar is `NaN` or `±infinity`.

### Exact Integer Quantities

```swift
import UnitesSI

let duration = try Quantity<Int, Millisecond, Linear>(exactly: 2_000)
let durationInSeconds = try duration.convertedIfExactly(to: Second.self)

print(durationInSeconds.exactValue) // Optional(2)
```

For integer scalars, conversion throws when the result is not exactly representable:

```swift
import UnitesSI

let oneMeter = try Quantity<Int, Meter, Linear>(exactly: 1)
try oneMeter.convertedIfExactly(to: Kilometer.self) // throws
```

### Derived Quantities

```swift
import UnitesSI

let distance = try Quantity<Double, Kilometer, Linear>(36)
let travelTime = try Quantity<Double, Second, Linear>(3_600)
let speed = try distance / travelTime

print(speed.value) // 10.0
```

Derived quantities are normalized to canonical units, so they are handled in terms of dimension and canonical value rather than unit combinations. Grouping of terms does not affect the canonical dimension. However, named SI units that BIPM distinguishes by application (e.g. `Hertz` vs `Becquerel`) are never treated as the same quantity even when they share the same exponent dimension.

### Affine and Linear Spaces

Every `Quantity` carries a `Space` type parameter: `Affine` or `Linear`. Most physical quantities — length, mass, time, etc. — are `Linear` (the default for typical use). `Affine` marks absolute positions such as thermodynamic temperature, where a zero point has physical meaning.

The compiler enforces affine-space algebra:

| Expression | Result | Meaning |
|---|---|---|
| Point + Vector | Point | Shift a position by an interval |
| Vector + Point | Point | Commutative form |
| Point − Point | Vector | Distance between two positions |
| Point − Vector | Point | Shift a position backwards |
| Vector + Vector | Vector | Combine intervals |
| Point + Point | **compile error** | Adding two positions is meaningless |

Multiplication and division always produce `Linear` quantities.

### SI Prefixes

```swift
import PrefixesDuSI

let kilo = Kilo.scale
let micro = Micro.scale

print(Kilo.symbol)        // k
print(kilo.exponent)      // 3
print(Micro.symbol)       // μ
print(micro.exponent)     // -6
```

`PrefixesDuSI` provides SI prefix metadata as an independent module. The `UnitesSI` facade exposes prefixed units as explicit public type names. The micro prefix symbol uses the Greek small letter mu (`μ`) per the SI Brochure.

Prefixed units like `Kilometer`, `Kilopascal`, and `Microfarad` are available directly from `UnitesSI`. Mass follows SI convention: `Kilogram` remains the canonical base unit while prefixed mass variants are formed from `Gram` (e.g. `Milligram`, `Megagram`).

Temperature expression types (`DegreeCelsius`, `Kelvin`) are not eligible for prefix expansion.

### SI Derived Units

```swift
import UnitesSI

let angularFrequency = try Quantity<Double, Radian, Linear>(1) / try Quantity<Double, Second, Linear>(0.02)
let reciprocalRate = try Quantity<Double, CanonicalUnit<QuotientDimension<Dimensionless, TimeDimension>>, Linear>(50)
let frequency = reciprocalRate.interpreted(as: Hertz.self)
let activity = reciprocalRate.interpreted(as: Becquerel.self)

print(angularFrequency.value) // 50.0
print(frequency.value) // 50.0
print(activity.value) // 50.0
```

`Radian`, `Steradian`, `Hertz`, `Becquerel`, `Gray`, and `Sievert` can be initialized directly as semantic units. Pairs like `Hertz` / `Becquerel` or `Gray` / `Sievert` are never auto-converted even though they share the same numeric coefficient. `Radian / Second` likewise remains an angular-frequency quantity, not `Hertz`. Use `interpreted(as:)` to explicitly assign meaning to an ambiguous canonical quantity.

The specialized semantic operators (`Candela * Steradian -> Lumen`, `Lumen / Area -> Lux`) preserve the same safety guarantees as the generic arithmetic layer. Floating-point overloads throw `QuantityError.divisionByZero` and `QuantityError.nonFiniteValue` instead of storing `Infinity` or `NaN`.

### Absolute Temperature and Temperature Intervals

Temperature is modeled through the unified `Quantity` type using the `Space` parameter. Affine quantities represent absolute temperatures; linear quantities represent temperature intervals.

```swift
import UnitesSI

let roomTemperature = try CelsiusTemperatureValue(25)
let boilingPoint = try CelsiusTemperatureValue(100)
let rise = try boilingPoint - roomTemperature

print(roomTemperature.converted(to: Kelvin.self).value) // 298.15
print(rise.value)                                        // 75.0
```

`DegreeCelsius` is one of the 22 named SI units in BIPM SI Brochure 9th edition Table 4. `CelsiusTemperatureValue` is a type alias for `Quantity<Double, DegreeCelsius, Affine>`. Temperature differences use `Linear` space: `CelsiusTemperatureDifference` is `Quantity<Double, DegreeCelsius, Linear>`.

Affine-space operators enforce physical correctness. Subtracting two absolute temperatures yields an interval; adding an interval to an absolute temperature yields a new absolute temperature. Adding two absolute temperatures is a compile-time error.

```swift
import UnitesSI

let setpoint = try KelvinTemperatureValue(295)
let correction = try CelsiusTemperatureDifference(-5)
let adjusted = try setpoint + correction

print(adjusted.value) // 290.0
```

All affine arithmetic that produces a thermodynamic temperature validates against absolute zero and throws `QuantityError.belowAbsoluteZero` on violation. More generally, affine lower bounds are modeled through `AbsoluteLowerBoundDimensionProtocol`, so the invariant belongs to the dimension rather than to temperature-specific runtime branches inside `Quantity`.

## Performance Notes

Hot-path accessors and arithmetic are annotated selectively with `@inlinable`; the package does not blanket-export all implementation details. A reproducible benchmark target is included:

```sh
swift run SystemeInternationalBenchmarks
```

One run on 2026-03-24 in the default debug configuration on Apple silicon reported:

- `linear_add_same_unit`: 248 ns/op
- `convert_kilometer_to_meter`: 225 ns/op
- `multiply_canonical_area`: 265 ns/op
- `semantic_lumen_operator`: 291 ns/op
- `semantic_lux_operator`: 435 ns/op

### Foundation Compatibility

```swift
import Foundation
import UnitesSICompat

let roadDistance = try Quantity<Double, Kilometer, Linear>(12.3).foundationMeasurement()
let roomTemperature = try Measurement(value: 25, unit: UnitTemperature.celsius)
    .absoluteTemperature(as: DegreeCelsius.self)

print(roadDistance.unit.symbol)                           // km
print(roomTemperature.converted(to: Kelvin.self).value)   // 298.15
```

`UnitesSICompat` provides bidirectional conversion with Foundation `Measurement` / `Dimension`. Conversion APIs are exposed only for bridge-compatible units; incompatible units are excluded at the type level. The bridge rejects `NaN` and `±infinity` with typed errors.

The absolute temperature and temperature interval bridges are limited to Kelvin and Celsius. Custom `Foundation.Dimension` subclasses fill gaps where Apple does not provide a standard unit type.

Temperature intervals use the throwing `foundationMeasurementComponents()` to extract the raw value and unit, avoiding accidental routing through absolute temperature conversion.

### Accepted Non-SI Units

```swift
import UtiliseesNonSI

let halfDay = try Quantity<Double, Hour, Linear>(12).converted(to: Day.self)
let sampleMass = try Quantity<Double, Dalton, Linear>(12)

print(halfDay.value)                            // 0.5
print(sampleMass.converted(to: Kilogram.self).value)
```

`UtiliseesNonSI` provides the 16 non-SI units that BIPM accepts for use with the SI:

| Category | Units |
|---|---|
| Time | `Minute`, `Hour`, `Day` |
| Mass | `Tonne`†, `Dalton`† |
| Area | `Hectare` |
| Length | `AstronomicalUnit` |
| Energy | `ElectronVolt`† |
| Volume | `Liter`† |
| Plane angle | `Degree`, `Arcminute`, `Arcsecond` |
| Logarithmic ratio | `Neper`, `Bel`†, `Decibel` |

† SI-prefixable (`SIPrefixable`). These units can produce prefixed variants (e.g. `Milliliter`, `Kiloliter`, `Decibel` = `SIPrefixedUnit<Bel, Deci>`).

```swift
import UtiliseesNonSI

// Volume
let water = try Quantity<Double, Milliliter, Linear>(500)
print(water.converted(to: Liter.self).value) // 0.5

// Plane angle
let rightAngle = try Quantity<Double, Degree, Linear>(90)
print(rightAngle.converted(to: Radian.self).value) // 1.5707963267948966

// Logarithmic ratio
let gain = try Quantity<Double, Decibel, Linear>(20)
let ratio = try Quantity<Double, Neper, Linear>(1)
```

### Accepted Non-SI Foundation Compatibility

```swift
import Foundation
import UtiliseesNonSICompat

let elapsed = try Quantity<Double, Day, Linear>(2).foundationMeasurement()
let particleMass = try Measurement(value: 12, unit: UnitMass.daltons)
    .siQuantity(as: Dalton.self)

print(elapsed.unit.symbol)   // d
print(particleMass.value)    // 12.0
```

`UtiliseesNonSICompat` bridges `UtiliseesNonSI` with Foundation. It re-exports `UnitesSICompat` as a higher-level facade, so importing both modules simultaneously does not create API ambiguity. The bridge covers volume (`Liter` — `UnitVolume.liters`), plane angle (`Degree`, `Arcminute`, `Arcsecond` — custom `UnitPlaneAngle`), logarithmic ratio (`Neper`, `Bel` — custom `UnitLogarithmicRatio`), and prefixed variants such as `Decibel`.

## License

This project is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.
