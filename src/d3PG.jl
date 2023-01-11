module d3PG

using Cropbox
using Dates

include("Parameters.jl")
include("Climate.jl")
include("CanopyProduction.jl")
include("WaterBalance.jl")
include("BiomassPartition.jl")
include("Mortality.jl")

@system Model(Parameters, Climate, CanopyProduction, WaterBalance, BiomassPartition, Mortality, Controller) begin
    # Calendar variable to reference date
    calendar(context) ~ ::Calendar
    
    # Stand age in days and years
    standAgeDay => 1 ~ accumulate::Int64(init=iAge, timeunit=u"d")
    standAge(calendar, standAgeDay) => standAgeDay / daysinyear(calendar.date') ~ track # stand age (years)
    
    # Soil water
    ASW(dASW) ~ accumulate(u"mm", init=iASW, min=minASW, max=maxASW)
    pool(dPool) ~ accumulate(u"mm")
    runoff(dRunoff) ~ accumulate(u"mm")
    
    # Daily drymass of foliage, root, and stem per hectare
    dWF(growthFoliage, litterfall, deathFoliage) => growthFoliage - litterfall - deathFoliage ~ track(u"kg/ha/d")
    dWR(growthRoot, rootTurnover, deathRoot) => growthRoot - rootTurnover - deathRoot ~ track(u"kg/ha/d")
    dWS(growthStem, deathStem) => growthStem - deathStem ~ track(u"kg/ha/d")
    dW(dWF, dWR, dWS) => dWF + dWR + dWS ~ track(u"kg/ha/d")
    
    # Accumulated drymass of foliage, root, and stem per hectare
    WF(dWF) ~ accumulate(u"kg/ha", init=iWF) # foliage drymass
    WR(dWR) ~ accumulate(u"kg/ha", init=iWR) # root drymass
    WS(dWS) ~ accumulate(u"kg/ha", init=iWS) # stem drymass
    W(dW) ~ accumulate(u"kg/ha", init=iW) # total drymass

    # Number of trees per hectare
    stemNo(dStemNo) ~ accumulate(init=iStemNo, u"ha^-1")
    
    # Specific leaf area based on stand age (years)
    SLA(standAge, SLA0, SLA1, tSLA) => begin
        SLA1 + (SLA0 - SLA1) * exp(-log(2) * (standAge / tSLA) ^ 2)
    end ~ track(u"m^2/kg")
    
    # Branch and bark fraction based on stand age (years)
    fracBB(standAge, fracBB0, fracBB1, tBB) => begin
        fracBB1 + (fracBB0 - fracBB1) * exp(-log(2) * (standAge / tBB))
    end ~ track
    
    # Density based on stand age (years)
    density(standAge, rho0, rho1, tRho) => begin
        rho1 + (rho0 - rho1) * exp(-log(2) * (standAge / tRho))
    end ~ track(u"kg/m^3")
    
    # Average tree mass
    avStemMass(WS, stemNo) => WS / stemNo ~ track(u"kg")
    
    # Average diameter at breast height
    avDBH(nounit(avStemMass), aWs, nWs) => begin
        (avStemMass / aWs) ^ (1 / nWs)
    end ~ track(u"cm")
    
    # Base area
    basArea(avDBH, stemNo) => begin
        (((avDBH / 2) ^ 2) * pi) * stemNo
    end ~ track(u"m^2/ha") # base area
    
    # Height
    height(aH, nounit(avDBH), nHB, nHN, stemNo) => begin
        aH * avDBH ^ nHB * stemNo ^ nHN
    end ~ track
    
    # Leaf Area Index
    LAI(WF, SLA) => WF * SLA ~ track
    
    # Stand volume per hectare
    standVol(WS, aV, avDBH, nVB, nVN, fracBB, stemNo, density) => begin
        if aV > 0
            aV * avDBH ^ nVB * stemNo ^ nVN
        else
            WS * (1 - fracBB) / density
        end
    end ~ track(u"m^3/ha")
    
    # Mean volume increment per hectare
    MAI(standVol, standAge) => ((standAge > 0) ? (standVol / standAge) : 0) ~ track(u"m^3/ha")
end

export Model
end
