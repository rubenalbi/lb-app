//
//  BusRepository.h
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericRepository.h"

@interface BusRepository : GenericRepository

- (NSMutableArray*)findStopArrivals:(NSString*)stopID;

- (NSMutableArray*)findVehicleArrivals:(NSString*)vehicleID;

@end
