//
//  TflService.h
//  BusLondon
//
//  Created by Ruben Albiach on 09/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "Stop.h"
#import "StopDAO.h"
#import "Bus.h"

@interface GenericService : NSObject

- (NSMutableArray*)parseJSONtoArray:(NSString *)url;

- (NSMutableArray *)insertionSort:(NSMutableArray *)unsortedDataArray;

- (NSString*)getDistanceMinutesByMeters:(NSNumber*)meters;

@end
