"""
This system contains all the parameters for d3PG.
"""
@system Parameters begin
    
    #========================================
    Stand initialisation and site factor data
    ========================================#
    
    "Initial age"
    iAge ~ preserve(parameter) # Initial age 
    
    "Initial foliage drymass"
    iWF ~ preserve(parameter, u"kg/ha")
    
    "Initial root drymass"
    iWR ~ preserve(parameter, u"kg/ha")
    
    "Initial stem drymass"
    iWS ~ preserve(parameter, u"kg/ha")
    
    "Initial total drymass"
    iW(iWS, iWF, iWR) => iWS + iWF + iWR ~ preserve(u"kg/ha")
    
    "Initial tree count"
    iStemNo ~ preserve(parameter, u"ha^-1")
    
    "Initial available soil water"
    iASW ~ preserve(parameter, u"mm")
    
    "Latitude"
    lat ~ preserve(parameter)
    
    "Fertility rating"
    FR ~ preserve(parameter)
    
    "Atmospheric CO2"
    CO2 ~ preserve(parameter)
    
    "Maximum available soil water"
    maxASW ~ preserve(parameter, u"mm")
    
    "Minimum available soil water"
    minASW ~ preserve(parameter, u"mm")
    
    "Soil class."
    soilClass ~ preserve(parameter) 
    
    "Irrigation"
    irrigation ~ preserve(parameter, u"mm/d")
    
    "Fraction of excess water pooled"
    poolFractn ~ preserve(parameter)

    
    #===================
    Biomass partitioning
    ====================#
    
    "Foliage:stem partitioning ratio at D=2cm"
    pFS2 ~ preserve(parameter)
    
    "Foliage:stem partitioning ratio at D=20cm"
    pFS20 ~ preserve(parameter)
    
    
    pfsPower(pFS2, pFS20) => log(pFS20 / pFS2) / log(20 / 2) ~ preserve
    
    pfsConst(pFS2, pfsPower) => pFS2 / 2 ^ pfsPower ~ preserve
    
    "Stem mass vs. diameter constant"
    aWs ~ preserve(parameter)
    
    "Stem mass vs. diameter exponent"
    nWs ~ preserve(parameter)
    
    "Maximum fraction of NPP to roots"
    pRx ~ preserve(parameter)
    
    "Minimum fraction of NPP to roots"
    pRn ~ preserve(parameter)
    
    
    #=========================
    Litterfall & root turnover
    =========================#
    
    "Maximum litterfall rate"
    gammaF1 ~ preserve(parameter)
    
    "Literfall rate at t = 0"
    gammaF0 ~ preserve(parameter)
    
    "Age at which litterfall rate has median value"
    tgammaF ~ preserve(parameter)
    
    "Average monthly root turnover rate"
    gammaR  ~ preserve(parameter)
    
    
    #==========================
    NPP & conductance modifiers
    ==========================#
    
    # Temperature
    "Minimum temperature for growth"
    tMin ~ preserve(parameter)
    
    "Optimal temperature for growth"
    Opt ~ preserve(parameter)
    
    "Maximum temperature for growth"
    tMax ~ preserve(parameter)
    
    # Frost modifier
    "Days of production lost per frost day"
    kF ~ preserve(parameter)

    # Soil water modifier
    "Moisture ratio deficit for fTheta = 0.5"
    SWconst0 ~ preserve(parameter)
    
    ""
    SWconst(soilClass, SWconst0) => begin
        ((soilClass > 0) ? (0.8 - 0.1 * soilClass) : (SWconst0)) 
    end ~ preserve
    
    "Power of moisture ratio deficit"
    SWpower0 ~ preserve(parameter)
    
    ""
    SWpower(soilClass, SWpower0) => begin
        ((soilClass > 0) ? (11 - 2 * soilClass) : (SWpower0))
    end ~ preserve
    
    # Atmospheric CO2 modifier
    "Assimilation enhancement factor at 700ppm"
    fCalpha700 ~ preserve(parameter)
    
    "Canopy conductance enhancement factor at 700ppm"
    fCg700 ~ preserve(parameter)
    
    ""
    fCalphax(fCalpha700) => fCalpha700 / (2 - fCalpha700) ~ preserve
    
    ""
    fCg0(fCg700) => fCg700 / (2 * fCg700 - 1) ~ preserve
    
    # Fertility effects
    "Value of 'm' when FR = 0"
    m0 ~ preserve(parameter)
    
    "Value of 'fNutr' when FR = 0"
    fN0 ~ preserve(parameter)
    
    "Power of (1-FR) in 'fNutr'"
    fNn ~ preserve(parameter)
    
    # Age modifier
    "Maximum stand age used in age modifier"
    maxAge ~ preserve(parameter)
    
    "Power of relative age in function for fAge"
    nAge ~ preserve(parameter)
    
    "Relative age to give fAge = 0.5"
    rAge ~ preserve(parameter)
    
    
    #=============================
    Stem mortality & self-thinning
    =============================#
    
    "Mortality rate for large t"
    gammaN1 ~ preserve(parameter)
    
    "Seedling mortality rate (t=0)"
    gammaN0 ~ preserve(parameter)
    
    "Age at which mortality rate has median value"
    tgammaN ~ preserve(parameter)
    
    "Shape of mortality response"
    ngammaN ~ preserve(parameter)
    
    "Max. stem mass per tree at 1000 trees/hectare"
    wSx1000 ~ preserve(parameter, u"kg")
    
    "Power in self-thinning rule"
    thinPower ~ preserve(parameter)
    
    "Fraction mean single-tree foliage biomass lost per dead tree"
    mF ~ preserve(parameter)
    
    "Fraction mean single-tree root biomass lost per dead tree"
    mR ~ preserve(parameter)
    
    "Fraction mean single-tree stem biomass lost per dead tree"
    mS ~ preserve(parameter)
    
    
    #=============================
    Canopy structure and processes
    =============================#
    
    # Specific leaf area
    "Specific leaf area at age 0"
    SLA0 ~ preserve(parameter, u"m^2/kg")
    
    "Specfic leaf area for mature leaves"
    SLA1 ~ preserve(parameter, u"m^2/kg")
    
    "Age at which specific leaf area = (SLA0 + SLA1)/2"
    tSLA ~ preserve(parameter)
    
    # Light intercetion
    "Extinction coefficient for absorption of PAR by canopy"
    k ~ preserve(parameter)
    
    "Age at canopy cover"
    fullCanAge ~ preserve(parameter)
    
    "Maximum propotion of rainfall evaporated from canopy"
    maxIntcptn ~ preserve(parameter)
    
    "LAI for maximum rainfall interception"
    LAImaxIntcptn ~ preserve(parameter)
    
    # Production and respiration
    "Canopy quantum efficiency"
    alphaCx ~ preserve(parameter)
    
    "Ratio NPP/GPP"
    y ~ preserve(parameter)
    
    # Conductance
    
    "Minimum canopy conductance"
    minCond ~ preserve(parameter, u"m/s")
    
    "Maximum canopy conductance"
    maxCond ~ preserve(parameter, u"m/s")
    
    "LAI for maximum canopy conductance"
    LAIgcx ~ preserve(parameter)
    
    "Defines stomatal response to VPD"
    coeffCond ~ preserve(parameter, u"mbar^-1")
    
    "Canopy boundary layer conductance"
    BLcond ~ preserve(parameter, u"m/s")
    
    
    #========================
    Wood and stand properties
    ========================#
    
    ## Branch and bark fraction
    "Branch and bark fraction at age 0"
    fracBB0 ~ preserve(parameter)
    
    "Branch and bark fraction for mature stands"
    racBB1 ~ preserve(parameter)
    
    "Age at which frac BB = (fracBB0 + fracBB1) / 2"
    tBB ~ preserve(parameter)
    
    ## Basic density
    "Minimum basic density (for young trees)"
    rho0 ~ preserve(parameter, u"kg/m^3")
    
    "Maximum basic density (for older trees)"
    rho1 ~ preserve(parameter, u"kg/m^3")
    
    "Age at which rho = (rhoMin + rhoMax) / 2"
    tRho ~ preserve(parameter) # 
    
    ## Stem height
    "Constant in the stem height relationship"
    aH ~ preserve(parameter)
    
    "Power of DBH in the stem height relationship"
    nHB ~ preserve(parameter)
    
    "Power of stocking in the stem height relationship"
    nHN ~ preserve(parameter)
    
    ## Stem volume
    "Constant in the stem volume relationship"
    aV ~ preserve(parameter)
    
    "Power of DBH in the stem volume relationship"
    nVB ~ preserve(parameter)
    
    "Power of stocking in the stem volume relationship"
    nVN ~ preserve(parameter)
    
    
    #=================
    Conversion factors
    =================#
    
    "Intercept of net vs. solar radiation relationship"
    Qa ~ preserve(parameter, u"W/m^2")
    
    "Slope of net vs. solar radiation relationship"
    Qb ~ preserve(parameter)
    
    "Molecular weight of dry matter"
    gDM_mol ~ preserve(parameter, u"g/mol")
    
    "Conversion of solar radiation to PAR"
    molPAR_MJ ~ preserve(parameter, u"mol/MJ")
    
end