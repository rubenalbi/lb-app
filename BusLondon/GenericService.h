//
//  TflService.h
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "Stop.h"
#import "StopDAO.h"
#import "Bus.h"
#import "SBJson.h"

@interface GenericService : NSObject

- (NSDictionary*) parseJsonFromURL:(NSString*)url;

- (NSString*)getDistanceMinutesByMeters:(NSNumber*)meters;

@end
