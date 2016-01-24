//
//  BusService.m
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "BusService.h"

@implementation BusService{
    BusRepository *busRepository;
}

-(id)init{
    self = [super init];
    busRepository = [[BusRepository alloc] init];
    return self;
}

- (NSMutableArray*)getStopArrivals:(NSString*)stopID{
    
    return [self unifyDuplicatedBuses:
            [self insertionBusSort:
             [busRepository findStopArrivals:stopID]]];
}

- (NSMutableArray*)getLineStops:(NSString*)lineID{

    return [busRepository findLineStops:lineID];
    
}

-(NSMutableArray *)insertionBusSort:(NSMutableArray *)unsortedDataArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Bus *bus in unsortedDataArray) {
        [tempArray addObject:[NSNumber numberWithDouble:[bus EstimatedTime]]];
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

-(NSMutableArray*)unifyDuplicatedBuses:(NSMutableArray*)buses{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    bool exist = false;
    for (int i = 0;[buses count] > i;i++){
        if([temp count] > 0){
            for (int j = 0; [temp count] > j; j++) {
                if ([[buses[i] LineName] isEqualToString:[temp[j] LineName]]) {
                    if (![[buses[i] VehicleID] isEqualToString:[temp[j] VehicleID]]) {
                        [[temp[j] NextBuses] addObject:[[buses objectAtIndex:i] getEstimatedTimeMinutes]];
                        NSLog(@"Break, no copying bus");
                        exist = true;
                        break;
                    }
                }
            }
            if (!exist) {
                NSLog(@"adding component");
                [temp addObject:buses[i]];
                exist = false;
            }
            
        }else{
            [temp addObject:buses[i]];
        }
    }
    return temp;
}

@end
