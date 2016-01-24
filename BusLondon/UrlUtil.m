//
//  UrlUtil.m
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "UrlUtil.h"

@implementation UrlUtil

+ (NSString*)stopsByLocation:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius{
    
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

+ (NSString*)arrivalsByStopID:(NSString*)stopID{
    
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

+ (NSString*)lineRoute:(NSString*)lineId{
    
    //https://api.tfl.gov.uk/Line/12/stoppoints
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                           NEW_URL_TFL_API,
                           TFL_LINE_PARAM,
                           @"/",
                           lineId,
                           @"/",
                           TFL_STOPPOINTS_PARAM,
                           @"?",
                           TFL_APP_CREDENTIALS];
    
    NSLog(@"%@", URLString);
    
    return URLString;
}
@end
