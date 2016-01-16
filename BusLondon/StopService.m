//
//  StopService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "StopService.h"

@implementation StopService

- (NSMutableArray*)getStopsByLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius{
    double timeStart = [[NSDate date] timeIntervalSince1970];
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    NSDictionary *stopPoints = [[super parseJsonFromURL:
                                 [self getURLStopsByLatitutde:lat longitude:lon radius:radius]]
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
    
    return [self insertionStopsSort:stops];
}

- (NSString*)getURLStopsByLatitutde:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius{
    
    // https://api.tfl.gov.uk/StopPoint?lat=51.509980&lon=-0.133700&stopTypes=NaptanPublicBusCoachTram&radius=300&returnLines=True&app_id=b4cfdcd0&app_key=ee2d65d36b4f1881b46dd5d0d7c33c26

    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@%f%@%f%@%@%@%@%@%d%@%@%@%@%@",
                           NEW_URL_TFL_API,
                           TFL_STOP_POINT_PARAM,
                           @"?",
                           @"lat=",
                           lat,
                           @"&lon=",
                           lon,
                           @"&",
                           TFL_STOP_TYPE_PARAM,
                           TFL_STOP_TYPE_PUBLIC_BUS,
                           @"&",
                           TFL_RADIUS_PARAM,
                           radius,
                           @"&",
                           TFL_RETURN_LINES_PARAM,
                           @"True",
                           @"&",
                           TFL_APP_CREDENTIALS];
    NSLog(@"%@", URLString);
    
    return URLString;
}

-(NSMutableArray *)insertionStopsSort:(NSMutableArray *)unsortedDataArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Stop *stop in unsortedDataArray) {
        [tempArray addObject:stop.distance];
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
