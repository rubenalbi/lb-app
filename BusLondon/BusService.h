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

- (NSMutableArray*)getEstimatedTimeBusesByStopID:(NSString*)stopID;

@end
