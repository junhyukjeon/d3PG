@system CanopyProduction begin
    ## LUE modifier (temperature)
    flagTemp(tAvg, tMin, tMax) => (tAvg >= tMin && tAvg <= tMax) ~ flag
    fTemperature(tAvg, tMin, tMax, tOpt) => begin
        ((tAvg - tMin) / (tOpt - tMin)) * ((tMax - tAvg) / (tMax - tOpt)) ^ ((tMax - tOpt) / (tOpt - tMin))
    end ~ track(when=flagTemp)

    # LUE modifier (VPD)
    fVPD(VPD, coeffCond) => begin
        exp(-coeffCond * VPD)
    end ~ track

    # LUE modifier (available soil water)
    fSW(ASW, maxASW, SWconst, SWpower) => begin
        1 / (1 + ((1 - (ASW / maxASW)) / SWconst) ^ SWpower)
    end ~ track

    # LUE modifier (soil nutrition)
    flagSN(fNn) => fNn != 0 ~ flag
    fSN(FR, fNn, fN0) => begin
        if fNn == 0
            1  
        else
            1 - (1 - fN0) * (1 - FR) ^ fNn
        end
    end ~ track

    # LUE modifier (frost)
    flagFrost(tLow) => (tLow < 0) ~ flag
    fFrost(kF) => 1 - kF ~ track(when=flagFrost, init=1)
    
    # LUE modifier (ambient CO2)
    fCalpha(fCalphax, CO2) => fCalphax * CO2 / (350 * (fCalphax - 1) + CO2) ~ track

    # LUE modifier (age)
    flagAge(nAge) => nAge != 0 ~ flag
    fAge(standAge, maxAge, rAge, nAge) => (1 / (1 + (standAge / maxAge / rAge) ^ nAge)) ~ track(when=flagAge, init=1)

    # LUE modifier (VPD, ASW, age)
    fPhysiology(fVPD, fSW, fAge) => begin
        min(fVPD, fSW) * fAge
    end ~ track

    # Canopy cover and light interception
    canCover(standAge, fullCanAge) => standAge / fullCanAge ~ track(max=1)
    lightIntcptn(k, LAI, canCover) => 1 - (exp(-k * LAI / canCover)) ~ track
    
    # Canopy quantum efficiency after modifiers
    alphaC(alphaCx, fSN, fTemperature, fFrost, fCalpha, fPhysiology) => begin
        alphaCx * fSN * fTemperature * fFrost * fCalpha * fPhysiology
    end ~ track

    # Canopy quantum efficiency in g/MJ
    epsilon(gDM_mol, molPAR_MJ, alphaC) => gDM_mol * molPAR_MJ * alphaC ~ track(u"g/MJ")
    
    # Intercepted radiation
    radInt(rad, lightIntcptn, canCover) => rad * lightIntcptn * canCover ~ track(u"MJ/m^2/d")
    
    # Gross primary production
    GPP(epsilon, radInt, transpScaleFactor) => epsilon * radInt * transpScaleFactor ~ track(u"kg/ha/d")
    
    # Net primary production
    NPP(GPP, y) => GPP * y ~ track(u"kg/ha/d")
end