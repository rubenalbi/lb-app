//
//  BusStop.h
//  BusLondon
//
//  Created by Rubén Albiach on 07/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Stop : NSObject

@property NSString *StopPointName;
@property NSString *StopID;
@property NSString *StopPointType;
@property NSString *Towards;
@property NSString *Bearing;
@property NSString *StopPointIndicator;
@property CLLocation *StopLocation;
@property NSString *Latitude;
@property NSString *Longitude;
@property NSString *BusNumbers;
@property double distance;

@end
