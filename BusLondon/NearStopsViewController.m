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
    BOOL firstLoad;
    Pin *selectedPin;
    NSThread* myThread;
    double timeStart;
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
    
    firstLoad = false;
    
    
    [self loadLocation];
    
    
    self.mapView.delegate = self;
    
    
    // Location map button
    UIButton *myLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myLocationButton.frame = CGRectMake(self.mapView.frame.size.width-40, self.mapView.frame.size.height-40, 30, 30);
    [myLocationButton setImage:[UIImage imageNamed:@"locationArrow.png"] forState:UIControlStateNormal];
    [myLocationButton addTarget:self action:@selector(locateUser) forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.mapView addSubview:myLocationButton];
    
    
    // UIRefreshControl to update the list
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to update"];
    [refresh addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //  Si no hay centros cargados se crea una fila mientras se cargan los datos.
    if (stops.count > 0) {
        stopCell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
        Stop *stop = stops[indexPath.row];
        
        stopCell.StopPointIndicatorLabel.text = [stop StopPointIndicator];
        stopCell.StopNameLabel.text = [stop StopPointName];
        stopCell.TowardsLabel.text = [stop Towards];
        stopCell.BusesLabel.text = [stop BusNumbers];
        
        stopCell.DistanceLabel.text = [NSString stringWithFormat:@"%.0f min",([stop distance]/1.4)/60];
        
        return stopCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}

- (void)loadBusStops{
    timeStart = [[NSDate date] timeIntervalSince1970];
    NSLog(@"LoadBusStops");
    
    NSMutableArray *stopsJSON = [self parseJSONtoArrayFromURL:[self getURLStopsByLatitude:mapLocation.coordinate.latitude longitude:mapLocation.coordinate.longitude]];
    
    NSLog(@"ParseJSON - %f", [[NSDate date] timeIntervalSince1970] - timeStart);
    
    if (stops != nil) {
        [stops removeAllObjects];
    } else {
        stops = [[NSMutableArray alloc] init];
    }
    
    Stop *stop;
    CLLocation *stopLocation;
    for (NSArray *stopArray in stopsJSON) {
        if ([stopArray count] >= 9) {
            stop = [[Stop alloc]init];
            [stop setStopPointName:stopArray[1]];
            if ([stop StopPointName] == (id)[NSNull null]) [stop setStopPointName:nil];
            [stop setStopID:stopArray[2]];
            if ([stop StopID] == (id)[NSNull null]) [stop setStopID:nil];
            [stop setStopPointType:stopArray[3]];
            if ([stop StopPointType] == (id)[NSNull null]) [stop setStopPointType:nil];
            [stop setTowards:stopArray[4]];
            if ([stop Towards] == (id)[NSNull null]) [stop setTowards:nil];
            [stop setBearing:stopArray[5]];
            if ([stop Bearing] == (id)[NSNull null]) [stop setBearing:nil];
            [stop setStopPointIndicator:stopArray[6]];
            if ([stop StopPointIndicator] == (id)[NSNull null]) [stop setStopPointIndicator:nil];
            [stop setLatitude:stopArray[7]];
            if ([stop Latitude] == (id)[NSNull null]) [stop setLatitude:nil];
            [stop setLongitude:stopArray[8]];
            if ([stop Longitude] == (id)[NSNull null]) [stop setLongitude:nil];
            
            stopLocation = [[CLLocation alloc] initWithLatitude:[stopArray[7] doubleValue] longitude:[stopArray[8] doubleValue]];
            
            [stop setStopLocation:stopLocation];
            
//            [stop setBusNumbers:[self getBusNumbersByStopID:[stop StopID]]];
            
            [stop setDistance:[userLocation distanceFromLocation:stopLocation]];
            
            if (([stop StopPointType] != nil) && ([[stop StopPointType] isEqualToString:@"STBR"]
                                                  || [[stop StopPointType] isEqualToString:@"STBC"] || [[stop StopPointType] isEqualToString:@"STZZ"]
                                                  || [[stop StopPointType] isEqualToString:@"STBN"] || [[stop StopPointType] isEqualToString:@"STBS"]
                                                  || [[stop StopPointType] isEqualToString:@"STSS"] || [[stop StopPointType] isEqualToString:@"STVA"])){
//                //  Instanciamos el objeto Pin y se añade los datos a mostrar.
                Pin *pin = [[Pin alloc] init];
                [pin setTitle:[NSString stringWithFormat:@"%@ - %@",[stop StopPointIndicator],[stop StopPointName]]];
                [pin setSubtitle:[stop BusNumbers]];
                [pin setStopPointIndicator:[stop StopPointIndicator]];
                [pin setBearing:[stop Bearing]];
                [pin setStopID:[stop StopID]];
                
                [pin setCoordinate:CLLocationCoordinate2DMake([[stop Latitude] doubleValue], [[stop Longitude] doubleValue])];
                [self.mapView addAnnotation:pin];
                
                [stops addObject:stop];
            }
        }
    }
    
    stops = [self insertionSort:stops];
    [self.tableView reloadData];
    NSLog(@"LoadLocation - %f", [[NSDate date] timeIntervalSince1970] - timeStart);
}

- (NSMutableArray*)parseJSONtoArrayFromURL:(NSString *)url{
    
    NSURL *responseURL = [NSURL URLWithString:url];
    NSString *actualResponse = [NSString stringWithContentsOfURL:responseURL encoding:NSUTF8StringEncoding error:nil];
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

-(float)distanceFromUserLocation:(CLLocation *)stopLocation{
    
    return [userLocation distanceFromLocation:stopLocation];
    
}

-(NSString*)getBusNumbersByStopID:(NSString *)stopID{
    
    NSMutableString *busNumbers = [[NSMutableString alloc] init];
    
    NSMutableArray *busesJSON = [self parseJSONtoArrayFromURL:[self getURLBusNumbersByStopID:stopID]];
    NSMutableArray *busNumbersArray = [[NSMutableArray alloc] init];
    
    BOOL duplicate = false;
    for (NSArray *busArray in busesJSON) {
        if (busArray){
            for (int i = 0; i < [busNumbersArray count]; i++) {
                if ([busArray[1] isEqualToString:busNumbersArray[i]]) {
                    duplicate = true;
                }
            }
            if (!duplicate && ![busArray[1] isEqualToString:@"1.0"]) {
                [busNumbersArray addObject:busArray[1]];
                [busNumbers appendFormat:@", %@",busArray[1]];
            }
            duplicate = false;
        }
    }
    return busNumbers;
}

- (NSString*)getURLStopsByLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%f%@%f%@%@%@",
                           URL_TFL_API,
                           @"?Circle=",
                           lat,@",",
                           lon,
                           @",",
                           RATIO_DISTANCE,
                           URL_FINAL_STOPS];
    
    NSLog(@"%@", URLString);
    
    return URLString;
}

- (NSString*)getURLBusNumbersByStopID:(NSString *)stopID{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@",
                           URL_TFL_API,
                           URL_BUSES_STOP_ID,
                           stopID,
                           URL_BUSES_RETURN_LIST_JUST_NUMBERS];
    
//    NSLog(@"%@", URLString);
    
    return URLString;
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
    
    NSLog(@"Load new location");
    userLocation = newLocation;
    
    if (!firstLoad) {
       
//        NSThread *threadLoadStops = [[NSThread alloc] initWithTarget:self selector:@selector(loadBusStops) object:nil];
//        [threadLoadStops start];
        
        [self loadBusStops];
        
        firstLoad = true;
        
        [self locateUser];
        
        mapLocation = userLocation;
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

-(NSMutableArray *)insertionSort:(NSMutableArray *)unsortedDataArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Stop *stop in unsortedDataArray) {
        [tempArray addObject:[NSNumber numberWithDouble:stop.distance]];
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
    
    NSLog(@"update map");
    
    
    
//    if ([myThread isFinished] || myThread == nil) {
//        [self.mapView removeAnnotations:[self.mapView annotations]];
//        
//        mapLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
//        
//        myThread = [[NSThread alloc] initWithTarget:self
//                                           selector:@selector(loadBusStops)
//                                             object:nil];
//        [myThread start];
//    }
    
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    mapLocation = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    
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
            [[segue destinationViewController] setStopID:stop.StopID];
            [[segue destinationViewController] setTitle:stop.StopPointName];
        }
    }
}

@end
