//
//  TableViewController.h
//  BusLondon
//
//  Created by Rubén Albiach on 07/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "StopViewCell.h"
#import "Pin.h"
#import "StopService.h"
#import "BusService.h"
#import "MyStopsService.h"
#import "StopViewController.h"

@interface NearStopsViewController : UITableViewController <CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate>{
    CLLocationManager * locationManager;
    CLLocation *userLocation;
    CLLocation *mapLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)addFavourites:(id)sender;

@end