//
//  Bus.m
//  BusLondon
//
//  Created by Rubén Albiach on 3/11/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import "Bus.h"

@implementation Bus

-(id)init{
    self = [super init];
    [self setNextBuses:[[NSMutableArray alloc] init]];
    return self;
}

- (id)initWithDictionary:(NSDictionary*)busJson {
    self = [super init];
    if (self) {
        [self setStopPointName:[busJson valueForKey:@"stationName"]];
        [self setLineName:[busJson valueForKey:@"lineName"]];
        [self setDestinationName:[busJson valueForKey:@"destinationName"]];
        [self setVehicleID:[busJson valueForKey:@"vehicleId"]];
        [self setEstimatedTime:[[busJson objectForKey:@"timeToStation"] doubleValue]];
        [self setNextBuses:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (NSString*)getEstimatedTimeString{
    return [NSString stringWithFormat:@"%.0f",[self EstimatedTime]/60];
}

- (double) getEstimatedTimeMinutes{
    return self.EstimatedTime/60;
}

@end