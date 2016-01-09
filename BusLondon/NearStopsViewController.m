//
//  TableViewController.m
//  BusLondon
//
//  Created by Rubén Albiach on 07/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import "NearStopsViewController.h"

@interface NearStopsViewController ()

@end

@implementation NearStopsViewController {
    NSMutableArray *stops;
    NSMutableArray *myStops;
    BOOL firstLoad;
    Pin *selectedPin;
    NSThread* myThread;
    double timeStart;
    NSThread *threadLoadRoutes;
    StopService *stopService;
    BusService *busService;
    MyStopsService *myStopsService;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stopService = [[StopService alloc] init];
    busService = [[BusService alloc] init];
    myStopsService = [[MyStopsService alloc] init];
    firstLoad = false;
    
    // [self loadLocation];
    // mapLocation = userLocation;
    CLLocation *manualLoc = [[CLLocation alloc] initWithLatitude:51.508832 longitude:-0.127907];
    mapLocation = manualLoc;
    [self loadBusStops];
    //self.mapView.delegate = self;
    
    // Location map button
    UIButton *myLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myLocationButton.frame = CGRectMake(15, 15, 30, 30);
    [myLocationButton setImage:[UIImage imageNamed:@"locationArrow.png"] forState:UIControlStateNormal];
    [myLocationButton addTarget:self action:@selector(locateUser) forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.mapView addSubview:myLocationButton];
    
    // UIRefreshControl to update the list
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to update"];
    [refresh addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self loadMyStops];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([stops count] == 0) {
        return 1;
    }
    return [stops count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    StopViewCell *stopCell;
    
    //  If stops are not loaded a loading data row is created by default
    if (stops.count > 0) {
        stopCell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
        Stop *stop = stops[indexPath.row];
        
        stopCell.StopPointIndicatorLabel.text = [stop stopPointIndicator];
        stopCell.StopNameLabel.text = [stop stopPointName];
        stopCell.TowardsLabel.text = [stop towards];
        stopCell.BusesLabel.text = [stop busNumbers];
        stopCell.addFavouriteButton.tag = indexPath.row;
        
        if ([self stopExists:stop]) {
            [stopCell.addFavouriteButton setSelected:YES];
        }else{
            [stopCell.addFavouriteButton setSelected:NO];
        }
        
        stopCell.DistanceLabel.text = [stopService getDistanceMinutesByMeters:[stop distance]];
        
        return stopCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}

- (BOOL)stopExists:(Stop *)stop {
    if ([[myStops valueForKey:@"stopID"] containsObject:stop.stopID]) {
        return YES;
    }
    return NO;
}

- (IBAction)addFavourites:(id)sender{
    StopViewCell *cell = (StopViewCell *)[(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForItem:[sender tag] inSection:0]];
    
    if ([self stopExists:stops[[sender tag]]]) {
        NSLog(@"deleting favourites");
        [myStopsService deleteStop:stops[[sender tag]]];
        [myStops removeObject:stops[[sender tag]]];
        
        [cell.addFavouriteButton setSelected:NO];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Stop deleted"
                              message: @"The stop has been deleted from your stops."
                              delegate:self
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil];
        [alert show];
    } else{
        NSLog(@"adding favourites");
        [myStops addObject:stops[[sender tag]]];
        [myStopsService saveStop:stops[[sender tag]]];
        
        [cell.addFavouriteButton setSelected:YES];
    }
    
}

- (void)loadMyStops{
    myStops = [myStopsService getMyStops];
    if (myStops == NULL) {
        NSLog(@"myStops is null, creating empty one...");
        myStops = [[NSMutableArray alloc] init];
    }
}

- (void)loadBusRoutes{
    StopViewCell *cell;
    
    for (int i = 0; i < [stops count]; i++) {
        cell = (StopViewCell *)[(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [[stops objectAtIndex:i] setBusNumbers:[stopService getBusNumbers:[[stops objectAtIndex:i] stopID]]];
        [cell.BusesLabel setText:[[stops objectAtIndex:i] busNumbers]];
        
    }
    
}

- (void)loadAnnotationBusRoutes{
    NSArray *annotations = [self.mapView annotations];
        for (int i = 0; i < [annotations count]; i++) {
            if ([[annotations objectAtIndex:i] class] == [Pin class]) {
                [[annotations objectAtIndex:i] setSubtitle:[stopService getBusNumbers:[[annotations objectAtIndex:i] stopID]]];
            }
        }
}



- (void)loadBusStops{
    
    stops = [stopService getStopsByLatitude:mapLocation.coordinate.latitude longitude:mapLocation.coordinate.longitude ratio:RATIO_DISTANCE];
    //[self loadMyStops];
    [self.tableView reloadData];
    
    for (Stop *stop in stops) {
        //              Instanciamos el objeto Pin y se añade los datos a mostrar.
        Pin *pin = [[Pin alloc] init];
        [pin setTitle:[NSString stringWithFormat:@"%@ - %@",[stop stopPointIndicator],[stop stopPointName]]];
        [pin setSubtitle:[stop busNumbers]];
        [pin setStopPointIndicator:[stop stopPointIndicator]];
        [pin setBearing:[stop bearing]];
        [pin setStopID:[stop stopID]];
        
        [pin setCoordinate:CLLocationCoordinate2DMake([[stop latitude] doubleValue], [[stop longitude] doubleValue])];
        [self.mapView addAnnotation:pin];
    }
    
    threadLoadRoutes = [[NSThread alloc] initWithTarget:self selector:@selector(loadBusRoutes) object:nil];
    [threadLoadRoutes start];
    
}

- (void)loadLocation{
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    
    [locationManager startUpdatingLocation];  //requesting location updates
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    userLocation = newLocation;
    
    if (!firstLoad) {
       
//        NSThread *threadLoadStops = [[NSThread alloc] initWithTarget:self selector:@selector(loadBusStops) object:nil];
//        [threadLoadStops start];
        
        [self loadBusStops];
        
        firstLoad = true;
        
        [self locateUser];
        
        // mapLocation = userLocation;
        CLLocation *manualLoc = [[CLLocation alloc] initWithLatitude:51.508832 longitude:-0.127907];
        mapLocation = manualLoc;
        
        NSLog(@"Location loaded.");
    }
    
    
}

- (void)locateUser{
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = userLocation.coordinate.latitude;
    mapRegion.center.longitude = userLocation.coordinate.longitude;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated: YES];
}

- (void)updateTable:(UIRefreshControl *)refreshControl{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    
    [self loadBusStops];
    
    //  Once table is updated, set last update time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, HH:mm"];
    NSString *updated = [NSString stringWithFormat:@"Última vez: %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:updated];
    [refreshControl endRefreshing];
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    mapLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    
//    NSThread *threadLoadStops = [[NSThread alloc] initWithTarget:self selector:@selector(loadBusStops) object:nil];
//    [threadLoadStops start];
    
    [self loadBusStops];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *identifier = @"Pin";
    
    Pin *pin = (Pin*)annotation;
    
    if ([annotation isKindOfClass:[Pin class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,35,22)];
        [label setText:[pin stopPointIndicator]];
        [label setFont:[UIFont fontWithName:@"Helvetica Neue" size:9.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setHighlighted:YES];
        [annotationView addSubview:label];
        annotationView.image = [UIImage imageNamed:@"pinStopMap.png"];//here we use a nice image instead of the default pins
        annotationView.centerOffset = CGPointMake(0.0, -17.0);
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [detailBtn addTarget:self action:@selector(calloutButton) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = detailBtn;
        
        // Image and two labels
        UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRed.png"]];
        
        // Image rotation to point bus direction
        image.transform = CGAffineTransformMakeRotation(([[pin bearing] intValue]-270) * M_PI/180);
        [leftCAV addSubview : image];
        annotationView.leftCalloutAccessoryView = leftCAV;
        
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    id <MKAnnotation> annotation = [view annotation];
    selectedPin = (Pin*)annotation;
}

- (void)calloutButton{
    [self performSegueWithIdentifier:@"showStop" sender:selectedPin];
}

//  Se pasa el objeto Centro que se ha seleccionado de la tabla para mostrar sus detalles
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showStop"]) {
        if ([sender class] == [Pin class]) {
            [[segue destinationViewController] setStopID:[selectedPin stopID]];
            [[segue destinationViewController] setTitle:[selectedPin title]];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Stop *stop = stops[indexPath.row];
            [[segue destinationViewController] setStopID:stop.stopID];
            [[segue destinationViewController] setTitle:stop.stopPointName];
        }
    }
}

@end
