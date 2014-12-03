//
//  StopDAO.h
//  BusLondon
//
//  Created by Rubén Albiach on 29/11/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Stop.h"


@interface StopDAO : NSManagedObject

@property (nonatomic, retain) NSString * bearing;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * stopID;
@property (nonatomic, retain) NSString * stopPointIndicator;
@property (nonatomic, retain) NSString * stopPointName;
@property (nonatomic, retain) NSString * stopPointType;
@property (nonatomic, retain) NSString * towards;
@property (nonatomic, retain) NSString * busNumbers;

@end
