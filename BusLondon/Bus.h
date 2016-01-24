//
//  Bus.h
//  BusLondon
//
//  Created by Rubén Albiach on 3/11/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bus : NSObject

@property NSString *StopPointName;
@property NSString *LineName;
@property NSString *DestinationName;
@property NSString *VehicleID;
@property double EstimatedTime;
@property NSMutableArray *NextBuses;

- (id)initWithDictionary:(NSDictionary*)busJson;

- (NSString*)getEstimatedTimeMinutes;

@end
