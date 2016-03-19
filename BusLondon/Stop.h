//
//  Stop.h
//  BusLondon
//
//  Created by Rubén Albiach on 29/11/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stop : NSObject

@property NSString *stopPointName;
@property NSString *stopID;
@property NSString *towards;
@property NSString *bearing;
@property NSString *stopPointIndicator;
@property NSString *latitude;
@property NSString *longitude;
@property NSString *busNumbers;
@property NSNumber *distance;

- (id)initWithDictionary:(NSDictionary*)stopJson;

- (id)initWithArray:(NSArray*)stopArray;

- (NSString*) getDistanceString;

@end
