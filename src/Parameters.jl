@system Parameters begin
    # Stand initialisation and site factor data
    iAge ~ preserve(parameter) # Initial age
    iWF ~ preserve(parameter, u"kg/ha") # Initial foliage mass
    iWR ~ preserve(parameter, u"kg/ha") # Initial root mass
    iWS ~ preserve(parameter, u"kg/ha") # Initial stem mass
    iStemNo ~ preserve(parameter, u"ha^-1") # Initial stem count
    iASW ~ preserve(parameter, u"mm") # Initial available soil water
    lat ~ preserve(parameter) # Latitude
    FR ~ preserve(parameter) # Fertility rating
    CO2 ~ preserve(parameter) # Atmospheric CO2
    maxASW ~ preserve(parameter, u"mm") # Maximum available soil water
    minASW ~ preserve(parameter, u"mm") # Minimum available soi water
    soilClass ~ preserve(parameter) # Soil class
    irrigation ~ preserve(parameter, u"mm/d")
    poolFractn ~ preserve(parameter)
    
    # Biomass partitioning and turnover
    ## Allometric relationships & partitioning
    pFS2 ~ preserve(parameter) # Foliage:stem partitioning ratio at D=2cm
    pFS20 ~ preserve(parameter) # Foliage:stem partitioning ratio at D=20cm
    aWs ~ preserve(parameter) # Stem mass vs. diameter constant
    nWs ~ preserve(parameter) # Stem mass vs. diameter exponent
    pRx ~ preserve(parameter) # Maximum fraction of NPP to roots
    pRn ~ preserve(parameter) # Minimum fraction of NPP to roots
    ## Litterfall & root turnover
    gammaF1 ~ preserve(parameter) # Maximum litterfall rate
    gammaF0 ~ preserve(parameter) # Literfall rate at t = 0
    tgammaF ~ preserve(parameter) # Age at which litterfall rate has median value
    gammaR  ~ preserve(parameter) # Average monthly root turnover rate
    
    # NPP & conductance modifiers
    ## Temperature modifer
    tMin ~ preserve(parameter) # Minimum temperature for growth
    tOpt ~ preserve(parameter) # Optimal temperature for growth
    tMax ~ preserve(parameter) # Maximum temperature for growth
    ## Frost modifier
    kF ~ preserve(parameter) # Days of production lost per frost day
    ## Soil water modifier
    SWconst0 ~ preserve(parameter) # Moisture ratio deficit for fTheta = 0.5
    SWpower0 ~ preserve(parameter) # Power of moisture ratio deficit
    ## Atmospheric CO2 modifier
    fCalpha700 ~ preserve(parameter) # Assimilation enhancement factor at 700ppm
    fCg700 ~ preserve(parameter) # Canopy conductance enhancement factor at 700ppm
    ## Fertility effects
    m0 ~ preserve(parameter) # Value of 'm' when FR = 0
    fN0 ~ preserve(parameter) # Value of 'fNutr' when FR = 0
    fNn ~ preserve(parameter) # Power of (1-FR) in 'fNutr'
    ## Age modifier
    maxAge ~ preserve(parameter) # Maximum stand age used in age modifier 
    nAge ~ preserve(parameter) # Power of relative age in function for fAge
    rAge ~ preserve(parameter) # Relative age to give fAge = 0.5
    
    # Stem mortality & self-thinning
    gammaN1 ~ preserve(parameter) # Mortality rate for large t
    gammaN0 ~ preserve(parameter) # Seedling mortality rate (t=0)
    tgammaN ~ preserve(parameter) # Age at which mortality rate has median value
    ngammaN ~ preserve(parameter) # Shape of mortality response
    wSx1000 ~ preserve(parameter, u"kg") # Max. stem mass per tree at 1000 trees/hectare
    thinPower ~ preserve(parameter) # Power in self-thinning rule
    mF ~ preserve(parameter) # Fraction mean single-tree foliage biomass lost per dead tree
    mR ~ preserve(parameter) # Fraction mean single-tree root biomass lost per dead tree
    mS ~ preserve(parameter) # # Fraction mean single-tree stem biomass lost per dead tree
    
    # Canopy structure and processes
    ## Specific leaf area
    SLA0 ~ preserve(parameter, u"m^2/kg") # Specific leaf area at age 0
    SLA1 ~ preserve(parameter, u"m^2/kg") # Specfic leaf area for mature leaves
    tSLA ~ preserve(parameter) # Age at which specific leaf area = (SLA0 + SLA1)/2
    ## Light intercetion
    k ~ preserve(parameter) # Extinction coefficient for absorption of PAR by canopy
    fullCanAge ~ preserve(parameter) # Age at canopy cover
    maxIntcptn ~ preserve(parameter) # Maximum propotion of rainfall evaporated from canopy
    LAImaxIntcptn ~ preserve(parameter) # LAI for maximum rainfall interception
    ## Production and respiration
    alphaCx ~ preserve(parameter) # Canopy quantum efficiency
    y ~ preserve(parameter) # Ratio NPP/GPP
    ## Conductance
    minCond ~ preserve(parameter, u"m/s") # Minimum canopy conductance
    maxCond ~ preserve(parameter, u"m/s") # Maximum canopy conductance
    LAIgcx ~ preserve(parameter) # LAI for maximum canopy conductance
    coeffCond ~ preserve(parameter, u"mbar^-1") # Defines stomatal response to VPD
    BLcond ~ preserve(parameter, u"m/s") # Canopy boundary layer conductance
    
    # Wood and stand properties
    ## Branch and bark fraction
    fracBB0 ~ preserve(parameter) # Branch and bark fraction at age 0
    fracBB1 ~ preserve(parameter) # Branch and bark fraction for mature stands
    tBB ~ preserve(parameter) # Age at which frac BB = (fracBB0 + fracBB1) / 2
    ## Basic density
    rho0 ~ preserve(parameter, u"kg/m^3") # Minimum basic density (for young trees)
    rho1 ~ preserve(parameter, u"kg/m^3") # Maximum basic density (for older trees)
    tRho ~ preserve(parameter) # Age at which rho = (rhoMin + rhoMax) / 2
    ## Stem height
    aH ~ preserve(parameter) # Constant in the stem height relationship
    nHB ~ preserve(parameter) # Power of DBH in the stem height relationship
    nHN ~ preserve(parameter) # Power of stocking in the stem height relationship
    ## Stem volume
    aV ~ preserve(parameter) # Constant in the stem volume relationship
    nVB ~ preserve(parameter) # Power of DBH in the stem volume relationship
    nVN ~ preserve(parameter) # Power of stocking in the stem volume relationship
    
    # Conversion factors
    Qa ~ preserve(parameter, u"W/m^2") # Intercept of net vs. solar radiation relationship
    Qb ~ preserve(parameter) # Slope of net vs. solar radiation relationship
    gDM_mol ~ preserve(parameter, u"g/mol") # Molecular weight of dry matter
    molPAR_MJ ~ preserve(parameter, u"mol/MJ") # Conversion of solar radiation to PAR
    
    # Derived parameters
    iW(iWS, iWF, iWR) => iWS + iWF + iWR ~ preserve(u"kg/ha") # Initial total drymass
    SWconst(soilClass, SWconst0) => ((soilClass > 0) ? (0.8 - 0.1 * soilClass) : (SWconst0)) ~ preserve
    SWpower(soilClass, SWpower0) => ((soilClass > 0) ? (11 - 2 * soilClass) : (SWpower0)) ~ preserve
    pfsPower(pFS2, pFS20) => log(pFS20 / pFS2) / log(20 / 2) ~ preserve
    pfsConst(pFS2, pfsPower) => pFS2 / 2 ^ pfsPower ~ preserve
    fCalphax(fCalpha700) => fCalpha700 / (2 - fCalpha700) ~ preserve
    fCg0(fCg700) => fCg700 / (2 * fCg700 - 1) ~ preserve
end