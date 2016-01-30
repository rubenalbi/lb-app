//
//  UrlUtil.m
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "UrlUtil.h"

@implementation UrlUtil

+ (NSString*)stopsByLocation:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius{
    
    return [NSString stringWithFormat:TFL_NEAR_STOPS,
            lat,
            lon,
            radius,
            TFL_APP_CREDENTIALS];
}

+ (NSString*)arrivalsByStopID:(NSString*)stopID{
    
    return [NSString stringWithFormat:TFL_STOP_ARRIVALS,
            stopID,
            TFL_APP_CREDENTIALS];
    
}

+ (NSString*)vehicleArrivals:(NSString*)vehicleID{
    
    return [NSString stringWithFormat:TFL_VEHICLE_ARRIVALS, vehicleID];
    
}
@end
