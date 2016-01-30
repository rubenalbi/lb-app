//
//  TflService.h
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Stop.h"
#import "StopDAO.h"
#import "Bus.h"
#import "StopRepository.h"
#import "BusRepository.h"

@interface GenericService : NSObject

- (NSString*)getDistanceMinutesByMeters:(NSNumber*)meters;

- (NSMutableArray *)insertionStopsSort:(NSMutableArray *)unsortedDataArray;

@end
