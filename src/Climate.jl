@system Climate begin
    # Data
    data ~ provide(parameter, index=:Date, init=calendar.date) # Dataframe with data
    tHigh ~ drive(from=data, by=:Tmax) # Highest temperature of the day
    tLow ~ drive(from=data, by=:Tmin) # Lowest temperature of the day
    rain ~ drive(from=data, by=:Rain, u"mm/d") # Rain
    rad ~ drive(from=data, by=:Rad, u"MJ/m^2/d") # Solar radiation
    
    # Calculate daylength fraction using latitude and day of year
    sLat(lat) => sin(pi * lat / 180) ~ preserve 
    cLat(lat) => cos(pi * lat / 180) ~ preserve
    sinDec(calendar) => 0.4 * sin(0.0172 * (dayofyear(calendar.date') - 80)) ~ track
    cosH0(sLat, cLat, sinDec) => -sinDec * sLat / (cLat * sqrt(1 - sinDec ^ 2)) ~ track
    daylength(cosH0) => acos(cosH0) / pi ~ track
    
    # Average(midrange) temperature
    tAvg(tHigh, tLow) => (tHigh + tLow) / 2 ~ track
    
    # VPD calculation using temperature
    VPD(tLow, tHigh) => begin
        VPDx = 6.1078 * exp(17.269 * tHigh / (237.3 + tHigh))
        VPDn = 6.1078 * exp(17.269 * tLow / (237.3 + tLow))
        (VPDx - VPDn) / 2
    end ~ track(u"mbar")
end