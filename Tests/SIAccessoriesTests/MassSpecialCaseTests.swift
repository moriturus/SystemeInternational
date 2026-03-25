import Testing

@testable import SIAccessories

struct MassSpecialCaseTests {
    @Test
    func kilogramShorthandUsesPrefixedGramTypeAndMatchesExplicitKilogramConstruction() throws {
        let shorthand = try 1.0.kilo.gram
        let explicit = try Quantity<Double, Kilogram, Linear>(1.0)

        let _: Quantity<Double, SIPrefixedUnit<Gram, Kilo>, Linear> = shorthand

        #expect(shorthand.converted(to: Kilogram.self).value == explicit.value)
    }

    @Test
    func directKilogramShorthandUsesCanonicalKilogramType() throws {
        let shorthand = try 2.0.kilogram

        let _: Quantity<Double, Kilogram, Linear> = shorthand

        #expect(shorthand.value == 2.0)
    }

    @Test
    func directGramShorthandUsesGramRatherThanKilogram() throws {
        let gram: Quantity<Double, Gram, Linear> = try 20.0.gram

        #expect(gram.value == 20.0)
        #expect(abs(gram.converted(to: Kilogram.self).value - 0.02) < 0.000_000_000_1)
    }
}
