//
//  Stop.m
//  BusLondon
//
//  Created by Rubén Albiach on 29/11/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import "Stop.h"

@implementation Stop

- (id)initWithDictionary:(NSDictionary*)stopJson {
    self = [super init];
    if (self) {
        
        [self setStopPointName:[stopJson valueForKey:@"commonName"]];
        [self setStopID:[stopJson valueForKey:@"naptanId"]];
        //[self setTowards:[stopJson valueForKey:@"commonName"]];
        //[self setBearing:[stopJson valueForKey:@"commonName"]];
        [self setStopPointIndicator:[stopJson valueForKey:@"stopLetter"]];
        [self setLatitude:[stopJson valueForKey:@"lat"]];
        [self setLongitude:[stopJson valueForKey:@"lon"]];
        [self setBusNumbers:[self getStopLines:[stopJson valueForKey:@"lineGroup"]]];
        NSLog(@"%@",self.busNumbers);
        [self setDistance:[stopJson valueForKey:@"distance"]];
        
    }
    return self;
}

- (NSString*) getStopLines:(NSDictionary*)lineGroup{
    NSString *busnumbers = [lineGroup valueForKey:@"lineIdentifier"];
    
    return [NSString stringWithFormat:@"%@",[lineGroup valueForKey:@"lineIdentifier"]];
}

@end
