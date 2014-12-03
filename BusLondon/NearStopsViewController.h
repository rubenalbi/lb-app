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
#import <CoreData/CoreData.h>
#import "Stop.h"
#import "StopDAO.h"
#import "Constants.h"
#import "StopViewCell.h"
#import "Pin.h"
#import "StopViewController.h"

@interface NearStopsViewController : UITableViewController <CLLocationManagerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate>{
    CLLocationManager * locationManager;
    CLLocation *userLocation;
    CLLocation *mapLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)addFavourites:(id)sender;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
