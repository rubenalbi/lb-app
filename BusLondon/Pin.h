//
//  Pin.h
//  BusLondon
//
//  Created by Rubén Albiach on 14/11/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Pin : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *stopPointIndicator;
@property (nonatomic, copy) NSString *bearing;
@property (nonatomic, copy) NSString *stopID;

@end
