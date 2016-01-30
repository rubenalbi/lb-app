//
//  GenericRepository.m
//  BusLondon
//
//  Created by Ruben Albiach on 24/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "GenericRepository.h"

@implementation GenericRepository

- (NSDictionary*) parseJsonFromURL:(NSString*)url{
    NSURL *responseURL = [NSURL URLWithString:url];
    NSString *response = [NSString stringWithContentsOfURL:responseURL encoding:NSUTF8StringEncoding error:nil];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    return [parser objectWithString:response error:nil];
}

- (NSArray*) parseJsonArrayFromURL:(NSString*)url{
    
    return [[NSString
             stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil]componentsSeparatedByString:@"\n"];
}

@end
