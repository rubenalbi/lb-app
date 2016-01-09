//
//  BusService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "BusService.h"

@implementation BusService

- (NSMutableArray*)getEstimatedTimeBusesByStopID:(NSString*)stopID{
    NSMutableArray *buses;
    NSMutableArray *busesJSON = [super parseJSONtoArray:[self getURLBusesByStopID:stopID]];
    
    if (buses != nil) {
        [buses removeAllObjects];
    } else {
        buses = [[NSMutableArray alloc] init];
    }
    
    Bus *bus;
    for (NSArray *busArray in busesJSON){
        if ([busArray count] >= 8) {
            bus = [[Bus alloc] init];
            [bus setStopPointName:busArray[1]];
            if ([bus StopPointName] == (id)[NSNull null]) [bus setStopPointName:nil];
            [bus setLineName:busArray[2]];
            if ([bus LineName] == (id)[NSNull null]) [bus setLineName:nil];
            [bus setDestinationName:busArray[3]];
            if ([bus DestinationName] == (id)[NSNull null]) [bus setDestinationName:nil];
            [bus setVehicleID:busArray[4]];
            if ([bus VehicleID] == (id)[NSNull null]) [bus setVehicleID:nil];
            [bus setRegistrationNumber:busArray[5]];
            if ([bus RegistrationNumber] == (id)[NSNull null]) [bus setRegistrationNumber:nil];
            // Getting UTC time in seconds and estimated minutes
            [bus setEstimatedTime:(([busArray[6] doubleValue]/1000.0)-[[NSDate date] timeIntervalSince1970])/60.0];
            
            [buses addObject:bus];
        }
    }
    return [self insertionSort:buses];
}

- (NSString*)getURLBusesByStopID:(NSString*)stopID{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@",
                           URL_TFL_API,
                           URL_BUSES_STOP_ID,
                           stopID,
                           URL_BUSES_RETURN_LIST];
    
    NSLog(@"%@", URLString);
    
    return URLString;
}

@end