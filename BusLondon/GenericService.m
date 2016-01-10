//
//  TflService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "GenericService.h"

@implementation GenericService

- (NSString*)getDistanceMinutesByMeters:(NSNumber*)meters{
    return [NSString stringWithFormat:@"%.0f min walk",([meters doubleValue]/1.4)/60];
}

- (NSDictionary*) parseJsonFromURL:(NSString*)url{
    NSURL *responseURL = [NSURL URLWithString:url];
    NSString *response = [NSString stringWithContentsOfURL:responseURL encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    return [parser objectWithString:response error:nil];
}
@end
