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
    
    buses = [self unifyDuplicatedBuses:[self insertionBusSort:buses]];
    return buses;
}

- (NSMutableArray*)getRouteSequence:(NSString*)lineID{
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    NSDictionary *sequences = [super parseJsonFromURL: [self getURLRouteSequence:lineID]];
    NSMutableArray *stations = [sequences valueForKey:@"stations"];
    
    if (stations != nil && [stations count] > 0) {
        for (NSDictionary *station in stations) {
            [stops addObject:[[Stop alloc] initWithLineSequienceDictionary:station]];
        }
    }

    return stops;
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

- (NSString*)getURLRouteSequence:(NSString*)lineId{
    
    //https://api.tfl.gov.uk/Line/12/Route/Sequence/inbound
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                           NEW_URL_TFL_API,
                           TFL_LINE_PARAM,
                           @"/",
                           lineId,
                           TFL_ROUTE_SEQUENCE_INBOUND_PARAM,
                           @"?",
                           TFL_APP_CREDENTIALS];
    
    NSLog(@"%@", URLString);
    
    return URLString;
}

-(NSMutableArray *)insertionBusSort:(NSMutableArray *)unsortedDataArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Bus *bus in unsortedDataArray) {
        [tempArray addObject:[NSNumber numberWithDouble:[bus EstimatedTime]]];
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

-(NSMutableArray*)unifyDuplicatedBuses:(NSMutableArray*)buses{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    bool exist = false;
    for (int i = 0;[buses count] > i;i++){
        if([temp count] > 0){
            for (int j = 0; [temp count] > j; j++) {
                if ([[buses[i] LineName] isEqualToString:[temp[j] LineName]]) {
                    if (![[buses[i] VehicleID] isEqualToString:[temp[j] VehicleID]]) {
                        if ([temp[j] NextBuses] == nil) {
                            [temp[j] setNextBuses:@""];
                        }
                        
                        [temp[j] setNextBuses:[[temp[j] NextBuses] stringByAppendingString:[NSString stringWithFormat:@"%@, ",[[buses objectAtIndex:i] getEstimatedTimeMinutes]]]]                   ;
                        NSLog(@"Break, no copying bus");
                        exist = true;
                        break;
                    }
                }
            }
            if (!exist) {
                NSLog(@"adding component");
                [temp addObject:buses[i]];
                exist = false;
            }
            
        }else{
            [temp addObject:buses[i]];
        }
    }
    return temp;
}

@end
