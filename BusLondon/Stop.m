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
        [self setBusNumbers:[self getLines:[stopJson valueForKey:@"lineGroup"]]];
        if([self busNumbers] != nil){
            [self setStopPointName:[stopJson valueForKey:@"commonName"]];
            [self setStopID:[stopJson valueForKey:@"naptanId"]];
            [self setTowards:[self getTowards:[stopJson valueForKey:@"additionalProperties"]]];
            //[self setBearing:[stopJson valueForKey:@"commonName"]];
            [self setStopPointIndicator:[stopJson valueForKey:@"stopLetter"]];
            [self setLatitude:[stopJson valueForKey:@"lat"]];
            [self setLongitude:[stopJson valueForKey:@"lon"]];
            [self setDistance:[stopJson valueForKey:@"distance"]];
        } else {
            self = nil;
            return self;
        }
    }
    return self;
}

- (id)initWithLineSequienceDictionary:(NSDictionary*)stopJson {
    self = [super init];
    if (self) {
        [self setStopPointName:[stopJson valueForKey:@"name"]];
        [self setStopID:[stopJson valueForKey:@"id"]];
        [self setLatitude:[stopJson valueForKey:@"lat"]];
        [self setLongitude:[stopJson valueForKey:@"lon"]];
    }
    return self;
}

- (NSString*) getLines:(NSDictionary*)lineGroup{
    NSMutableArray *busNumbers = [lineGroup valueForKey:@"lineIdentifier"];
    if (busNumbers != nil && [busNumbers count] > 0) {
        return [[busNumbers objectAtIndex:0] componentsJoinedByString:@", "];
    }
    return nil;
}

- (NSString*) getTowards:(NSArray*)additionalProperties{
    if (additionalProperties != nil && [additionalProperties count] > 1) {
        NSDictionary *towards = [additionalProperties objectAtIndex:1];
        return [towards valueForKey:@"value"];
    }
    return nil;
}

@end
