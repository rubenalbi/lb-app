//
//  Bus.m
//  BusLondon
//
//  Created by Rubén Albiach on 3/11/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import "Bus.h"

@implementation Bus

- (id)initWithDictionary:(NSDictionary*)busJson {
    self = [super init];
    if (self) {
        [self setStopPointName:[busJson valueForKey:@"stationName"]];
        [self setLineName:[busJson valueForKey:@"lineName"]];
        [self setDestinationName:[busJson valueForKey:@"towards"]];
        [self setVehicleID:[busJson valueForKey:@"vehicleId"]];
        [self setEstimatedTime:[[busJson objectForKey:@"timeToStation"] doubleValue]];
    }
    
    return self;
}

- (double)getEstimatedTimeMinutes{
    return [self EstimatedTime]/60;
}

- (NSString*)getStringNextBuses{
    
    return [[self NextBuses] componentsJoinedByString:@", "];
}

@end