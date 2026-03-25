import Foundation
import UnitesDeBaseDuSI
import UnitesDeriveesDuSI
import UnitesSI

@inline(__always)
func measure(
    name: String,
    iterations: Int,
    operation: () throws -> Void
) rethrows -> String {
    let start = DispatchTime.now().uptimeNanoseconds
    for _ in 0..<iterations {
        try operation()
    }
    let elapsed = DispatchTime.now().uptimeNanoseconds - start
    let perIteration = Double(elapsed) / Double(iterations)
    return "\(name): \(Int(perIteration.rounded())) ns/op over \(iterations) iterations"
}

@main
struct SystemeInternationalBenchmarks {
    static func main() throws {
        let iterations = 200_000

        let addLhs = try Quantity<Double, Meter, Linear>(12)
        let addRhs = try Quantity<Double, Meter, Linear>(8)
        let kilometers = try Quantity<Double, Kilometer, Linear>(3.4)
        let intensity = try Quantity<Double, Candela, Linear>(1_200)
        let solidAngle = try Quantity<Double, Steradian, Linear>(1.5)
        let width = try Quantity<Double, Meter, Linear>(3)
        let height = try Quantity<Double, Meter, Linear>(2)

        let area = try width * height

        let results = try [
            measure(name: "linear_add_same_unit", iterations: iterations) {
                _ = try addLhs + addRhs
            },
            measure(name: "convert_kilometer_to_meter", iterations: iterations) {
                _ = kilometers.converted(to: Meter.self).value
            },
            measure(name: "multiply_canonical_area", iterations: iterations) {
                _ = try width * height
            },
            measure(name: "semantic_lumen_operator", iterations: iterations) {
                _ = try intensity * solidAngle
            },
            measure(name: "semantic_lux_operator", iterations: iterations) {
                _ = try Quantity<Double, Lumen, Linear>(1_500) / area
            },
        ]

        for result in results {
            print(result)
        }
    }
}
