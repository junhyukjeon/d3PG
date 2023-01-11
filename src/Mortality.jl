@system Mortality begin
    # Thinning
    
    # Defoliation
    
    # Mortality rate (yearly)
    gammaN(standAge, gammaN0, gammaN1, tgammaN, ngammaN) => begin
        gammaN1 + (gammaN0 - gammaN1) * exp(-log(2) * (standAge / tgammaN) ^ ngammaN)
    end ~ track
    
    # Mortality rate (daily)
    gammaNday(calendar, gammaN) => begin
        (1 - (1 - gammaN)^(1 / daysinyear(calendar.date'))) / u"d"
    end ~ track(u"d^-1")
    
    # Mortality flag
    flagMortal(gammaNday) => gammaNday > 0u"d^-1" ~ flag
    
    # Dead trees per hectare per day
    mortality(gammaNday, stemNo) => gammaNday * stemNo ~ track(u"ha^-1/d", when=flagMortal)
    
    deathFoliage(WF, mF, mortality, stemNo) => begin
        mF * mortality * (WF / stemNo)
    end ~ track(u"kg/ha/d", when=flagMortal)
    
    deathRoot(WR, mR, mortality, stemNo) => begin
        mR * mortality * (WR / stemNo)
    end ~ track(u"kg/ha/d", when=flagMortal)
    
    deathStem(WS, mS, mortality, stemNo) => begin
        mS * mortality * (WS / stemNo)
    end ~ track(u"kg/ha/d", when=flagMortal)
    
    dStemNo(mortality) => -mortality ~ track(u"ha^-1/d")
end