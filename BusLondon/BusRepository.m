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

- (NSMutableArray*)findLineStops:(NSString*)lineID{
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    NSDictionary *sequences = [super parseJsonFromURL: [UrlUtil lineRoute:lineID]];
    
    if (sequences != nil && [sequences count] > 0) {
        for (NSDictionary *sequence in sequences) {
            [stops addObject:[[Stop alloc] initWithDictionary:sequence]];
        }
    }
    
    return stops;
}

@end
