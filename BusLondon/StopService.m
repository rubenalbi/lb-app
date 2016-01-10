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
            
            [stop setBusNumbers:[self getBusNumbers:[stop stopID]]];
            
            if (([stop stopPointType] != nil) && ([[stop stopPointType] isEqualToString:@"STBR"]
                                                  || [[stop stopPointType] isEqualToString:@"STBC"] || [[stop stopPointType] isEqualToString:@"STZZ"]
                                                  || [[stop stopPointType] isEqualToString:@"STBN"] || [[stop stopPointType] isEqualToString:@"STBS"]
                                                  || [[stop stopPointType] isEqualToString:@"STSS"] || [[stop stopPointType] isEqualToString:@"STVA"])){
                
                
                [stops addObject:stop];
            }
        }
    }
    
    NSLog(@"Time LoadLocation - %f", [[NSDate date] timeIntervalSince1970] - timeStart);
    
    return [self insertionStopsSort:stops];
}

- (NSMutableArray*)getStopsByLatitudeJson:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon ratio:(int)ratio{
    double timeStart = [[NSDate date] timeIntervalSince1970];
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    NSURL *responseURL = [NSURL URLWithString:[self getNewURLStopsByLatitutde:lat longitude:lon radius:ratio]];
    NSString *response = [NSString stringWithContentsOfURL:responseURL encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *object = [parser objectWithString:response error:nil];
    
    NSDictionary *stopPoints = [object valueForKey:@"stopPoints"];
    for (NSDictionary *stop in stopPoints) {
        [stops addObject:[[Stop alloc] initWithDictionary:stop]];
    }
    
    NSLog(@"Time JSON - %f", [[NSDate date] timeIntervalSince1970] - timeStart);
    
    return [self insertionStopsSort:stops];
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

- (NSString*)getNewURLStopsByLatitutde:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius{
    
    // https://api.tfl.gov.uk/StopPoint?lat=51.509980&lon=-0.133700&stopTypes=NaptanPublicBusCoachTram&radius=300&returnLines=True&app_id=b4cfdcd0&app_key=ee2d65d36b4f1881b46dd5d0d7c33c26

    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@%f%@%f%@%@%@%@%@%d%@%@%@%@",
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
                           TFL_APP_CREDENTIALS];
    
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
