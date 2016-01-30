//
//  UrlUtil.h
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface UrlUtil : NSObject

+ (NSString*)stopsByLocation:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius;

+ (NSString*)arrivalsByStopID:(NSString*)stopID;

+ (NSString*)vehicleArrivals:(NSString*)vehicleID;

@end
