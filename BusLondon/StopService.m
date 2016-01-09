//
//  StopService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "StopService.h"

@implementation StopService

- (NSMutableArray*)getStopsByLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon ratio:(int)ratio{
    double timeStart = [[NSDate date] timeIntervalSince1970];
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    NSArray *jsonArray = [super parseJSONtoArray:[self getURLStopsByLatitutde:lat longitude:lon ratio:ratio]];
    
    Stop *stop;
    for (NSArray *stopArray in jsonArray) {
        if ([stopArray count] >= 9) {
            stop = [[Stop alloc]init];
            [stop setStopPointName:stopArray[1]];
            if ([stop stopPointName] == (id)[NSNull null]) [stop setStopPointName:nil];
            [stop setStopID:stopArray[2]];
            if ([stop stopID] == (id)[NSNull null]) [stop setStopID:nil];
            [stop setStopPointType:stopArray[3]];
            if ([stop stopPointType] == (id)[NSNull null]) [stop setStopPointType:nil];
            [stop setTowards:stopArray[4]];
            if ([stop towards] == (id)[NSNull null]) [stop setTowards:nil];
            [stop setBearing:stopArray[5]];
            if ([stop bearing] == (id)[NSNull null]) [stop setBearing:nil];
            [stop setStopPointIndicator:stopArray[6]];
            if ([stop stopPointIndicator] == (id)[NSNull null]) [stop setStopPointIndicator:nil];
            [stop setLatitude:stopArray[7]];
            if ([stop latitude] == (id)[NSNull null]) [stop setLatitude:nil];
            [stop setLongitude:stopArray[8]];
            if ([stop longitude] == (id)[NSNull null]) [stop setLongitude:nil];
            
            //[stop setDistance:[NSNumber numberWithDouble:[self distanceFromUserLocation:stopArray[7] long:stopArray[8]]]];
            [stop setDistance:[[NSNumber alloc] initWithInt:120]];
            
            [stop setBusNumbers:@"Loading..."];
            
            if (([stop stopPointType] != nil) && ([[stop stopPointType] isEqualToString:@"STBR"]
                                                  || [[stop stopPointType] isEqualToString:@"STBC"] || [[stop stopPointType] isEqualToString:@"STZZ"]
                                                  || [[stop stopPointType] isEqualToString:@"STBN"] || [[stop stopPointType] isEqualToString:@"STBS"]
                                                  || [[stop stopPointType] isEqualToString:@"STSS"] || [[stop stopPointType] isEqualToString:@"STVA"])){
                
                
                [stops addObject:stop];
            }
        }
    }
    
    NSLog(@"Time LoadLocation - %f", [[NSDate date] timeIntervalSince1970] - timeStart);
    
    return [super insertionSort:stops];
}

- (NSString*)getBusNumbers:(NSString*)stopId{
    return @"32, 24, 8, N8";
}


- (NSString*)getURLStopsByLatitutde:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon ratio:(int)ratio{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%f%@%f%@%d%@",
                           URL_TFL_API,
                           @"?Circle=",
                           lat,@",",
                           lon,
                           @",",
                           ratio,
                           URL_FINAL_STOPS];
    
    return URLString;
}

@end
