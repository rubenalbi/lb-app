//
//  TflService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "GenericService.h"

@implementation GenericService

- (NSMutableArray*)parseJSONtoArray:(NSString *)url{
    NSURL *responseURL = [NSURL URLWithString:url];
    NSString *actualResponse = [NSString stringWithContentsOfURL:responseURL encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Actual response: %@",actualResponse);
    NSLog(@"Url stops - %@", responseURL);
    
    NSArray *individualArrays = [actualResponse componentsSeparatedByString:@"\n"];
    
    NSArray *individualJSONArray;
    NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
    for (NSString *actualString in individualArrays) {
        individualJSONArray = [NSJSONSerialization JSONObjectWithData:[actualString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        if (individualJSONArray){
            [jsonArray addObject:individualJSONArray];
        }
    }
    
    return jsonArray;
}

- (NSString*)getDistanceMinutesByMeters:(NSNumber*)meters{
    return [NSString stringWithFormat:@"%.0f min walk",([meters doubleValue]/1.4)/60];
}

@end
