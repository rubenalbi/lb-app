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

-(NSMutableArray *)insertionStopsSort:(NSMutableArray *)unsortedDataArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Stop *stop in unsortedDataArray) {
        [tempArray addObject:stop.distance];
    }
    long count = unsortedDataArray.count;
    int i,j;
    for (i=1; i<count;i++)
    {
        j=i;
        while(j>0 && [[tempArray objectAtIndex:(j-1)] doubleValue] > [[tempArray objectAtIndex:j] doubleValue])
        {
            [tempArray exchangeObjectAtIndex:j withObjectAtIndex:(j-1)];
            [unsortedDataArray exchangeObjectAtIndex:j withObjectAtIndex:(j-1)];
            j=j-1;
        }
    }
    
    return unsortedDataArray;
}


@end
