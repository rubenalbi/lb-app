//
//  GenericRepository.h
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import <CoreLocation/CoreLocation.h>
#import "Stop.h"
#import "Bus.h"
#import "UrlUtil.h"

@interface GenericRepository : NSObject

- (NSDictionary*) parseJsonFromURL:(NSString*)url;

@end
