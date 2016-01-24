//
//  StopRepository.m
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "StopRepository.h"

@implementation StopRepository

- (NSMutableArray*)findStops:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius{
    double timeStart = [[NSDate date] timeIntervalSince1970];
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    NSDictionary *stopPoints = [[super parseJsonFromURL:
                                 [UrlUtil stopsByLocation:lat longitude:lon radius:radius]]
                                valueForKey:@"stopPoints"];
    
    for (NSDictionary *stop in stopPoints) {
        @try {
            [stops addObject:[[Stop alloc] initWithDictionary:stop]];
        }
        @catch (NSException *exception) {
            // stop is not created if doesn´t have line numbers
        }
    }
    
    NSLog(@"Time JSON - %f", [[NSDate date] timeIntervalSince1970] - timeStart);
    
    return stops;
}

@end
