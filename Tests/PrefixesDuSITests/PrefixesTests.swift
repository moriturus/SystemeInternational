import Foundation
import Testing

@testable import PrefixesDuSI

private struct PrefixMetadata {
    let type: any PrefixProtocol.Type
    let symbol: String
    let exponent: Int
}

private func officialPrefixes() -> [PrefixMetadata] {
    [
        PrefixMetadata(type: Quetta.self, symbol: "Q", exponent: 30),
        PrefixMetadata(type: Ronna.self, symbol: "R", exponent: 27),
        PrefixMetadata(type: Yotta.self, symbol: "Y", exponent: 24),
        PrefixMetadata(type: Zetta.self, symbol: "Z", exponent: 21),
        PrefixMetadata(type: Exa.self, symbol: "E", exponent: 18),
        PrefixMetadata(type: Peta.self, symbol: "P", exponent: 15),
        PrefixMetadata(type: Tera.self, symbol: "T", exponent: 12),
        PrefixMetadata(type: Giga.self, symbol: "G", exponent: 9),
        PrefixMetadata(type: Mega.self, symbol: "M", exponent: 6),
        PrefixMetadata(type: Kilo.self, symbol: "k", exponent: 3),
        PrefixMetadata(type: Hecto.self, symbol: "h", exponent: 2),
        PrefixMetadata(type: Deca.self, symbol: "da", exponent: 1),
        PrefixMetadata(type: Deci.self, symbol: "d", exponent: -1),
        PrefixMetadata(type: Centi.self, symbol: "c", exponent: -2),
        PrefixMetadata(type: Milli.self, symbol: "m", exponent: -3),
        PrefixMetadata(type: Micro.self, symbol: "μ", exponent: -6),
        PrefixMetadata(type: Nano.self, symbol: "n", exponent: -9),
        PrefixMetadata(type: Pico.self, symbol: "p", exponent: -12),
        PrefixMetadata(type: Femto.self, symbol: "f", exponent: -15),
        PrefixMetadata(type: Atto.self, symbol: "a", exponent: -18),
        PrefixMetadata(type: Zepto.self, symbol: "z", exponent: -21),
        PrefixMetadata(type: Yocto.self, symbol: "y", exponent: -24),
        PrefixMetadata(type: Ronto.self, symbol: "r", exponent: -27),
        PrefixMetadata(type: Quecto.self, symbol: "q", exponent: -30),
    ]
}

private func powerOfTen(_ exponent: Int) -> Decimal {
    if exponent == 0 {
        return 1
    }

    let step = Decimal(10)

    if exponent > 0 {
        return (0..<exponent)
            .reduce(Decimal(1)) { partial, _ in
                partial * step
            }
    }

    return (0..<(-exponent))
        .reduce(Decimal(1)) { partial, _ in
            partial / step
        }
}

private func displayedValue(_ baseValue: Decimal, using prefix: any PrefixProtocol.Type) -> Decimal {
    baseValue / powerOfTen(prefix.scale.exponent)
}

private func prefixedSymbol(_ prefix: any PrefixProtocol.Type, unitSymbol: String) -> String {
    prefix.symbol + unitSymbol
}

struct PrefixesTests {
    @Test
    func allOfficialPrefixesExposeTheExpectedSymbolAndExponent() throws {
        for prefix in officialPrefixes() {
            #expect(prefix.type.symbol == prefix.symbol)
            #expect(prefix.type.scale == PrefixScale(exponent: prefix.exponent))
        }
    }

    @Test
    func prefixScaleStoresExactPowerOfTenMetadata() throws {
        #expect(PrefixScale.identity.exponent == 0)
        #expect(Kilo.scale.exponent == 3)
        #expect(Micro.scale.exponent == -6)
        #expect(Quetta.scale.exponent == 30)
        #expect(Quecto.scale.exponent == -30)
    }

    @Test
    func latestPrefixesAreIncluded() throws {
        #expect(Quetta.symbol == "Q")
        #expect(Ronna.symbol == "R")
        #expect(Ronto.symbol == "r")
        #expect(Quecto.symbol == "q")
    }

    @Test
    func officialPrefixTypesConformToPrefixProtocol() throws {
        let decimalPrefixes = officialPrefixes().map(\.type)

        #expect(decimalPrefixes.count == 24)
        #expect(decimalPrefixes.allSatisfy { !$0.symbol.isEmpty })
    }

    @Test
    func supportedPrefixesCoverTheFullOfficialExponentRangeWithoutZero() throws {
        let exponents = officialPrefixes().map(\.exponent)

        #expect(exponents.max() == 30)
        #expect(exponents.min() == -30)
        #expect(exponents.contains(0) == false)
        #expect(exponents.filter { $0 > 0 }.count == 12)
        #expect(exponents.filter { $0 < 0 }.count == 12)
    }

    @Test
    func officialPrefixSetHasNoDuplicateSymbolsOrExponents() throws {
        let symbols = officialPrefixes().map(\.symbol)
        let exponents = officialPrefixes().map(\.exponent)

        #expect(Set(symbols).count == officialPrefixes().count)
        #expect(Set(exponents).count == officialPrefixes().count)
    }

    @Test
    func prefixesRemainOrderedFromLargestToSmallestScale() throws {
        let exponents = officialPrefixes().map(\.exponent)
        let sorted = exponents.sorted(by: >)

        #expect(exponents == sorted)
        #expect(exponents.first == 30)
        #expect(exponents.last == -30)
    }

    @Test
    func positiveAndNegativePrefixesStaySeparatedAroundTheIdentityGap() throws {
        let positiveExponents = officialPrefixes().map(\.exponent).filter { $0 > 0 }
        let negativeExponents = officialPrefixes().map(\.exponent).filter { $0 < 0 }

        #expect(positiveExponents.last == 1)
        #expect(negativeExponents.first == -1)
        #expect(positiveExponents.allSatisfy { $0 > 0 })
        #expect(negativeExponents.allSatisfy { $0 < 0 })
    }

    @Test
    func prefixScaleSupportsBoundaryAndOutOfBandExponentsWithoutLoss() throws {
        let negativeBoundary = PrefixScale(exponent: -30)
        let positiveBoundary = PrefixScale(exponent: 30)
        let identity = PrefixScale(exponent: 0)
        let outOfBandPositive = PrefixScale(exponent: 31)
        let outOfBandNegative = PrefixScale(exponent: -31)

        #expect(negativeBoundary == Quecto.scale)
        #expect(positiveBoundary == Quetta.scale)
        #expect(identity == .identity)
        #expect(outOfBandPositive.exponent == 31)
        #expect(outOfBandNegative.exponent == -31)
    }

    @Test
    func oneCharacterAndTwoCharacterSymbolsRemainRepresentable() throws {
        let oneCharacterSymbols = officialPrefixes().map(\.symbol).filter { $0.count == 1 }
        let twoCharacterSymbols = officialPrefixes().map(\.symbol).filter { $0.count == 2 }

        #expect(oneCharacterSymbols.count == 23)
        #expect(twoCharacterSymbols == ["da"])
    }

    @Test
    func realWorldRoadDistanceCanBeRenderedInKilometers() throws {
        let distanceInMeters = Decimal(string: "12300")!
        let displayedDistance = displayedValue(distanceInMeters, using: Kilo.self)
        let symbol = prefixedSymbol(Kilo.self, unitSymbol: "m")

        #expect(displayedDistance == Decimal(string: "12.3")!)
        #expect(symbol == "km")
    }

    @Test
    func realWorldLeakageCurrentCanBeRenderedInMicroamperes() throws {
        let currentInAmperes = Decimal(string: "0.000004")!
        let displayedCurrent = displayedValue(currentInAmperes, using: Micro.self)
        let symbol = prefixedSymbol(Micro.self, unitSymbol: "A")

        #expect(displayedCurrent == Decimal(string: "4")!)
        #expect(symbol == "μA")
    }

    @Test
    func realWorldChemicalSampleCanBeRenderedInMillimoles() throws {
        let amountInMoles = Decimal(string: "0.0025")!
        let displayedAmount = displayedValue(amountInMoles, using: Milli.self)
        let symbol = prefixedSymbol(Milli.self, unitSymbol: "mol")

        #expect(displayedAmount == Decimal(string: "2.5")!)
        #expect(symbol == "mmol")
    }

    @Test
    func realWorldLargeFrequencyCanBeRenderedInGigahertz() throws {
        let frequencyInHertz = Decimal(string: "3200000000")!
        let displayedFrequency = displayedValue(frequencyInHertz, using: Giga.self)
        let symbol = prefixedSymbol(Giga.self, unitSymbol: "Hz")

        #expect(displayedFrequency == Decimal(string: "3.2")!)
        #expect(symbol == "GHz")
    }

    @Test
    func realWorldNanometerAndKilopascalMetadataCanBeComposed() throws {
        let thicknessInMeters = Decimal(string: "0.00000008")!
        let displayedThickness = displayedValue(thicknessInMeters, using: Nano.self)
        let thicknessSymbol = prefixedSymbol(Nano.self, unitSymbol: "m")
        let pressureInPascals = Decimal(string: "101300")!
        let displayedPressure = displayedValue(pressureInPascals, using: Kilo.self)
        let pressureSymbol = prefixedSymbol(Kilo.self, unitSymbol: "Pa")

        #expect(displayedThickness == Decimal(string: "80")!)
        #expect(thicknessSymbol == "nm")
        #expect(displayedPressure == Decimal(string: "101.3")!)
        #expect(pressureSymbol == "kPa")
    }
}
