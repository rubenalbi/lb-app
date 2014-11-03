//
//  TableViewController.h
//  BusLondon
//
//  Created by Rubén Albiach on 07/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Stop.h"
#import "Constants.h"
#import "StopViewCell.h"

@interface NearStopsViewController : UITableViewController <CLLocationManagerDelegate>{
    CLLocationManager * locationManager;
    CLLocation *userLocation;
}

@end
