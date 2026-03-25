import Testing

@testable import UtiliseesNonSI

private func requireSameDimension<Left: UnitProtocol, Right: UnitProtocol>(
    _: Left.Type,
    _: Right.Type
) where Left.Dimension == Right.Dimension {}

private func requirePrefixable<Unit: SIPrefixableUnitProtocol>(_: Unit.Type) {}

struct AcceptedUnitsTests {
    @Test
    func facadeReexportsSIAlongsideAcceptedUnits() throws {
        #expect(Kilometer.symbol == "km")
        #expect(Minute.symbol == "min")
        #expect(Hour.symbol == "h")
        #expect(Day.symbol == "d")
        #expect(Tonne.symbol == "t")
        #expect(Hectare.symbol == "ha")
        #expect(AstronomicalUnit.symbol == "au")
        #expect(ElectronVolt.symbol == "eV")
        #expect(Dalton.symbol == "Da")
        #expect(Liter.symbol == "L")
        #expect(Degree.symbol == "°")
        #expect(Arcminute.symbol == "′")
        #expect(Arcsecond.symbol == "″")
        #expect(Neper.symbol == "Np")
        #expect(Bel.symbol == "B")
        #expect(Decibel.symbol == "dB")

        requireSameDimension(Minute.self, Second.self)
        requireSameDimension(Tonne.self, Kilogram.self)
        requireSameDimension(AstronomicalUnit.self, Meter.self)
        requireSameDimension(Liter.self, Milliliter.self)
        requireSameDimension(Degree.self, Radian.self)
        requireSameDimension(Arcminute.self, Radian.self)
        requireSameDimension(Arcsecond.self, Radian.self)
        requireSameDimension(Neper.self, Bel.self)
        requireSameDimension(Bel.self, Decibel.self)
    }

    @Test
    func acceptedUnitsExposeExpectedScaleMetadata() throws {
        let minute = try UnitScale(numerator: 60, denominator: 1)
        let hour = try UnitScale(numerator: 3_600, denominator: 1)
        let day = try UnitScale(numerator: 86_400, denominator: 1)
        let tonne = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 3)
        let hectare = try UnitScale(numerator: 1, denominator: 1, decimalExponent: 4)
        let astronomicalUnit = try UnitScale(numerator: 149_597_870_700, denominator: 1)
        let electronVolt = try UnitScale(numerator: 1_602_176_634, denominator: 1, decimalExponent: -28)
        let dalton = try UnitScale(numerator: 16_605_390_666, denominator: 1, decimalExponent: -37)
        let liter = try UnitScale(numerator: 1, denominator: 1, decimalExponent: -3)
        let degree = try UnitScale(numerator: 3_141_592_653_589_793, denominator: 180, decimalExponent: -15)
        let arcminute = try UnitScale(numerator: 3_141_592_653_589_793, denominator: 10_800, decimalExponent: -15)
        let arcsecond = try UnitScale(numerator: 3_141_592_653_589_793, denominator: 648_000, decimalExponent: -15)
        let bel = try UnitScale(numerator: 1_151_292_546_497_023, denominator: 1, decimalExponent: -15)
        let decibel = try UnitScale(numerator: 1_151_292_546_497_023, denominator: 1, decimalExponent: -16)

        #expect(Minute.scale == minute)
        #expect(Hour.scale == hour)
        #expect(Day.scale == day)
        #expect(Tonne.scale == tonne)
        #expect(Hectare.scale == hectare)
        #expect(AstronomicalUnit.scale == astronomicalUnit)
        #expect(ElectronVolt.scale == electronVolt)
        #expect(Dalton.scale == dalton)
        #expect(Liter.scale == liter)
        #expect(Degree.scale == degree)
        #expect(Arcminute.scale == arcminute)
        #expect(Arcsecond.scale == arcsecond)
        #expect(Neper.scale == .identity)
        #expect(Bel.scale == bel)
        #expect(Decibel.scale == decibel)
    }

    @Test
    func acceptedUnitsRoundTripAgainstCanonicalSIValues() throws {
        let travel = try Quantity<Double, Minute, Linear>(90)
        let travelInHours = travel.converted(to: Hour.self)
        let travelInDays = travel.converted(to: Day.self)
        let cargo = try Quantity<Double, Tonne, Linear>(1.5)
        let field = try Quantity<Double, Hectare, Linear>(2)
        let orbit = try Quantity<Double, AstronomicalUnit, Linear>(1)
        let ionization = try Quantity<Double, ElectronVolt, Linear>(1)
        let atom = try Quantity<Double, Dalton, Linear>(1)
        let volume = try Quantity<Double, Liter, Linear>(2.5)

        let halfTurn = try Quantity<Double, Degree, Linear>(180)
        let fullTurn = try Quantity<Double, Degree, Linear>(360)
        let sixtyArcminutes = try Quantity<Double, Arcminute, Linear>(60)
        let tenThousandEightHundredArcminutes = try Quantity<Double, Arcminute, Linear>(10_800)
        let sixtyArcseconds = try Quantity<Double, Arcsecond, Linear>(60)
        let thirtyNineHundredArcseconds = try Quantity<Double, Arcsecond, Linear>(3_600)

        #expect(abs(travelInHours.value - 1.5) < 0.000_000_1)
        #expect(abs(travelInDays.value - 0.0625) < 0.000_000_1)
        #expect(abs(cargo.converted(to: Kilogram.self).value - 1_500) < 0.000_000_1)
        #expect(
            abs(
                field.converted(to: CanonicalUnit<ProductDimension<LengthDimension, LengthDimension>>.self).value
                    - 20_000
            ) < 0.000_000_1
        )
        #expect(abs(orbit.converted(to: Meter.self).value - 149_597_870_700) < 0.000_000_1)
        #expect(
            abs(ionization.converted(to: Joule.self).value - 0.000_000_000_000_000_000_160_217_663_4)
                < 0.000_000_000_000_000_000_000_000_001
        )
        #expect(
            abs(atom.converted(to: Kilogram.self).value - 0.000_000_000_000_000_000_000_000_001_660_539_066_60)
                < 0.000_000_000_000_000_000_000_000_000_01
        )
        #expect(
            abs(
                volume.converted(
                    to: CanonicalUnit<
                        ProductDimension<ProductDimension<LengthDimension, LengthDimension>, LengthDimension>
                    >
                    .self
                )
                .value
                    - 0.0025
            ) < 0.000_000_1
        )
        #expect(abs(halfTurn.converted(to: Radian.self).value - Double.pi) < 1e-10)
        #expect(abs(fullTurn.converted(to: Radian.self).value - 2 * Double.pi) < 1e-10)
        #expect(abs(sixtyArcminutes.converted(to: Degree.self).value - 1) < 1e-10)
        #expect(abs(tenThousandEightHundredArcminutes.converted(to: Radian.self).value - Double.pi) < 1e-10)
        #expect(abs(sixtyArcseconds.converted(to: Arcminute.self).value - 1) < 1e-10)
        #expect(abs(thirtyNineHundredArcseconds.converted(to: Degree.self).value - 1) < 1e-10)

        let backToDegrees = halfTurn.converted(to: Radian.self).converted(to: Degree.self)
        #expect(abs(backToDegrees.value - 180) < 1e-10)

        let oneNeper = try Quantity<Double, Neper, Linear>(1)
        let oneBel = try Quantity<Double, Bel, Linear>(1)
        let tenDecibels = try Quantity<Double, Decibel, Linear>(10)
        let twentyDecibels = try Quantity<Double, Decibel, Linear>(20)

        // 1 Np = 2/ln(10) B ≈ 0.8686 B
        #expect(abs(oneNeper.converted(to: Bel.self).value - 0.868_588_963_806_504) < 1e-10)
        // 1 B = ln(10)/2 Np ≈ 1.1513 Np
        #expect(abs(oneBel.converted(to: Neper.self).value - 1.151_292_546_497_023) < 1e-10)
        // 1 B = 10 dB
        #expect(abs(oneBel.converted(to: Decibel.self).value - 10) < 1e-10)
        // 10 dB = 1 B
        #expect(abs(tenDecibels.converted(to: Bel.self).value - 1) < 1e-10)
        // 20 dB = 2 B = ln(10) Np ≈ 2.3026 Np
        #expect(abs(twentyDecibels.converted(to: Neper.self).value - 2.302_585_092_994_046) < 1e-10)

        let backToNepers = oneNeper.converted(to: Bel.self).converted(to: Neper.self)
        #expect(abs(backToNepers.value - 1) < 1e-10)
    }

    @Test
    func integerConversionsRemainExactWhenRepresentable() throws {
        let elapsedDay = try Quantity<Int, Day, Linear>(exactly: 1)
        let elapsedHours = try elapsedDay.convertedIfExactly(to: Hour.self)
        let mass = try Quantity<Int, Tonne, Linear>(exactly: 2)
        let kilograms = try mass.convertedIfExactly(to: Kilogram.self)

        #expect(elapsedHours.exactValue == 24)
        #expect(kilograms.exactValue == 2_000)

        let oneKiloliter = try Quantity<Int, Kiloliter, Linear>(exactly: 1)
        let inLiters = try oneKiloliter.convertedIfExactly(to: Liter.self)
        #expect(inLiters.exactValue == 1_000)

        let zeroDegrees = try Quantity<Int, Degree, Linear>(exactly: 0)
        #expect(zeroDegrees.exactValue == 0)

        let oneNeper = try Quantity<Int, Neper, Linear>(exactly: 1)
        #expect(oneNeper.exactValue == 1)
    }

    @Test
    func integerConversionsRejectFractionalResults() throws {
        let oneHour = try Quantity<Int, Hour, Linear>(exactly: 1)
        let oneKilogram = try Quantity<Int, Kilogram, Linear>(exactly: 1)

        #expect(throws: QuantityError.nonIntegralConversion) {
            try oneHour.convertedIfExactly(to: Day.self)
        }

        #expect(throws: QuantityError.nonIntegralConversion) {
            try oneKilogram.convertedIfExactly(to: Dalton.self)
        }

        let oneKiloliter = try Quantity<Int, Kiloliter, Linear>(exactly: 1)
        #expect(throws: QuantityError.nonIntegralConversion) {
            try oneKiloliter.convertedIfExactly(to: Megaliter.self)
        }

        #expect(throws: QuantityError.nonIntegralConversion) {
            try Quantity<Int, Degree, Linear>(exactly: 1)
        }

        #expect(throws: QuantityError.nonIntegralConversion) {
            try Quantity<Int, Bel, Linear>(exactly: 1)
        }
    }

    @Test
    func tonneElectronVoltAndDaltonAreSIPrefixable() {
        requirePrefixable(Tonne.self)
        requirePrefixable(ElectronVolt.self)
        requirePrefixable(Dalton.self)
        requirePrefixable(Bel.self)

        #expect(Kilotonne.symbol == "kt")
        #expect(Kiloelectronvolt.symbol == "keV")
        #expect(Kilodalton.symbol == "kDa")
        #expect(Decibel.symbol == "dB")
    }

    @Test
    func dimensionlessQuantityCanBeInterpretedAsNeper() {
        let canonical = Quantity<Double, CanonicalUnit<Dimensionless>, Linear>(baseValue: 10.0)
        let nepers = canonical.interpreted(as: Neper.self)

        #expect(abs(nepers.value - 10.0) < 0.000_000_1)
    }
}
