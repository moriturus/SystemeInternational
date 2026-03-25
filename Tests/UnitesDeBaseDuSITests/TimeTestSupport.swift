import Testing

@testable import UnitesDeBaseDuSI

struct HalfSecond: DirectlyInitializableUnitProtocol {
    static let symbol = "half-second"
    static let scale = try! UnitScale(numerator: 1, denominator: 2)

    typealias Dimension = TimeDimension
}
