//
//  BusRepository.m
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "BusRepository.h"

@implementation BusRepository

- (NSMutableArray*)findStopArrivals:(NSString*)stopID{
    NSMutableArray *buses = [[NSMutableArray alloc] init];
    NSDictionary *estimatedTimes = [super parseJsonFromURL: [UrlUtil arrivalsByStopID:stopID]];
    for (NSDictionary *estimatedBus in estimatedTimes) {
        [buses addObject:[[Bus alloc] initWithDictionary:estimatedBus]];
    }
    
    return buses;
}

- (NSMutableArray*)findVehicleArrivals:(NSString*)vehicleID{
    
    NSArray *stopArrays = [super parseJsonArrayFromURL:[UrlUtil vehicleArrivals:vehicleID]];
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    NSArray *individualJSONArray;
    for (NSString *actualString in stopArrays) {
        individualJSONArray = [NSJSONSerialization
                               JSONObjectWithData:[actualString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        if (individualJSONArray.count >= 6){
            [stops addObject:[[Stop alloc] initWithArray:individualJSONArray]];
        }
    }
    
    return stops;
}

@end
