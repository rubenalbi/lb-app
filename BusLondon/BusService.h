//
//  BusService.h
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericService.h"

@interface BusService : GenericService

- (NSMutableArray*)getStopArrivals:(NSString*)stopID unifiedList:(BOOL)unified;

- (NSMutableArray*)getVehicleStops:(NSString*)vehicleID;

@end
