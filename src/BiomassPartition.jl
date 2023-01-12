"""
This system partitions NPP to tree organs and calculates litterfall and root turnover
"""
@system BiomassPartition begin
    m(m0, FR) => m0 + (1 - m0) * FR ~ preserve
    pFS(pfsConst, nounit(avDBH), pfsPower) => pfsConst * (avDBH ^ pfsPower) ~ track # foliage and stem partition
    pR(pRx, pRn, fPhysiology, m) => pRx * pRn / (pRn + ( pRx - pRn) * fPhysiology * m) ~ track # root partition
    pS(pR, pFS) => (1 - pR) / (1 + pFS) ~ track # stem partition
    pF(pR, pS) => 1 - pR - pS ~ track # foliage partition

    # Calculate biomass increment
    growthFoliage(NPP, pF) => NPP * pF ~ track(u"kg/ha/d") # foliage
    growthRoot(NPP, pR) => NPP * pR ~ track(u"kg/ha/d") # root
    growthStem(NPP, pS) => NPP * pS ~ track(u"kg/ha/d") # stem
    
    # Monthly litterfall rate
    gammaF(gammaF1, gammaF0, standAge, tgammaF) => begin
        if tgammaF * gammaF1 == 0
            gammaF1
        else
            kgammaF = 12 * log(1 + gammaF1 / gammaF0) / tgammaF
            gammaF1 * gammaF0 / (gammaF0 + (gammaF1 - gammaF0) * exp(-kgammaF * standAge))
        end
    end ~ track
    
    # Daily litterfall rate
    gammaFday(calendar, gammaF) => begin
        (1 - (1 - gammaF)^(1 / daysinmonth(calendar.date'))) / u"d"
    end ~ track(u"d^-1")
    
    # Daily root turnover rate
    gammaRday(calendar, gammaR) => begin
        (1 - (1 - gammaR)^(1 / daysinmonth(calendar.date'))) / u"d"
    end ~ track(u"d^-1")

    litterfall(gammaFday, WF) => gammaFday * WF ~ track(u"kg/ha/d")
    rootTurnover(gammaRday, WR) => gammaRday * WR ~ track(u"kg/ha/d")
end