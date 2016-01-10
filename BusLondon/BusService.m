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
    NSMutableArray *buses = [[NSMutableArray alloc] init];
    
    NSDictionary *estimatedTimes = [super parseJsonFromURL: [self getURLBusesByStopID:stopID]];
    for (NSDictionary *estimatedBus in estimatedTimes) {
        [buses addObject:[[Bus alloc] initWithDictionary:estimatedBus]];
    }
    return [self insertionBusSort:buses];
}

- (NSString*)getURLBusesByStopID:(NSString*)stopID{
    
    //https://api.tfl.gov.uk/StopPoint/490011516Y/Arrivals?app_id=&app_key=
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                           NEW_URL_TFL_API,
                           TFL_STOP_POINT_PARAM,
                           @"/",
                           stopID,
                           @"/",
                           TFL_ARRAIVALS_PARAM,
                           @"?",
                           TFL_APP_CREDENTIALS];
    
    NSLog(@"%@", URLString);
    
    return URLString;
}

-(NSMutableArray *)insertionBusSort:(NSMutableArray *)unsortedDataArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Bus *bus in unsortedDataArray) {
        [tempArray addObject:[NSNumber numberWithDouble:bus.EstimatedTime]];
    }
    long count = unsortedDataArray.count;
    int i,j;
    for (i=1; i<count;i++)
    {
        j=i;
        while(j>0 && [[tempArray objectAtIndex:(j-1)] doubleValue] > [[tempArray objectAtIndex:j] doubleValue])
        {
            [tempArray exchangeObjectAtIndex:j withObjectAtIndex:(j-1)];
            [unsortedDataArray exchangeObjectAtIndex:j withObjectAtIndex:(j-1)];
            j=j-1;
        }
    }
    return unsortedDataArray;
}

@end
