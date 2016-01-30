//
//  StopService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "StopService.h"

@implementation StopService{
    StopRepository *stopRepository;
}

-(id)init{
    self = [super init];
    stopRepository = [[StopRepository alloc] init];
    return self;
}

- (NSMutableArray*)getNearStops:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon radius:(int)radius{
    return [super insertionStopsSort:[stopRepository findStops:lat longitude:lon radius:radius]];
}

@end
