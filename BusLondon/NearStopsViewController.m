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
}

@synthesize managedObjectContext;

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
    myLocationButton.frame = CGRectMake(15, 15, 30, 30);
    [myLocationButton setImage:[UIImage imageNamed:@"locationArrow.png"] forState:UIControlStateNormal];
    [myLocationButton addTarget:self action:@selector(locateUser) forControlEvents:UIControlEventTouchUpInside];
    
    //add the button to the view
    [self.mapView addSubview:myLocationButton];
    
//    [self.mapView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[myLocationButton(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(myLocationButton)]];
//    [self.mapView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[myLocationButton(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(myLocationButton)]];
    
    
    // UIRefreshControl to update the list
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to update"];
    [refresh addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // CORE DATA
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];

    [self loadMyStops];
    

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
        
        stopCell.StopPointIndicatorLabel.text = [stop stopPointIndicator];
        stopCell.StopNameLabel.text = [stop stopPointName];
        stopCell.TowardsLabel.text = [stop towards];
        stopCell.BusesLabel.text = [stop busNumbers];
        stopCell.addFavouriteButton.tag = indexPath.row;
        
        if ([self checkDuplicates:stop]) {
            [stopCell.addFavouriteButton setSelected:YES];
        }else{
            [stopCell.addFavouriteButton setSelected:NO];
        }
        
        stopCell.DistanceLabel.text = [NSString stringWithFormat:@"%.0f min walk",([[stop distance] doubleValue]/1.4)/60];
        
        return stopCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}

- (IBAction)addFavourites:(id)sender{
    StopViewCell *cell = (StopViewCell *)[(UITableView *)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForItem:[sender tag] inSection:0]];
    
    if ([self checkDuplicates:stops[[sender tag]]]) {
        
        [self deleteStop:stops[[sender tag]]];
        
        [cell.addFavouriteButton setSelected:NO];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Stop deleted"
                              message: @"The stop has been deleted from your stops."
                              delegate:self
                              cancelButtonTitle:@"Aceptar"
                              otherButtonTitles:nil];
        [alert show];
    } else{
        [myStops addObject:stops[[sender tag]]];
        [self saveStop:stops[[sender tag]]];
        
        [cell.addFavouriteButton setSelected:YES];
    }
    
}

- (void)saveStop:(Stop *)stop{
    StopDAO *stopDAO = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Stop"
                        inManagedObjectContext:[self managedObjectContext]];
    stopDAO.stopPointName = stop.stopPointName;
    stopDAO.stopID = stop.stopID;
    stopDAO.stopPointType = stop.stopPointType;
    stopDAO.towards = stop.towards;
    stopDAO.bearing = [NSString stringWithFormat:@"%@", stop.bearing];
    stopDAO.stopPointIndicator = stop.stopPointIndicator;
    stopDAO.latitude = [NSString stringWithFormat:@"%@", stop.latitude];
    stopDAO.longitude = [NSString stringWithFormat:@"%@", stop.longitude];
    stopDAO.busNumbers = stop.busNumbers;
    stopDAO.distance = stop.distance;
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)deleteStop:(Stop *)stop{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription
                                   entityForName:@"Stop" inManagedObjectContext:managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"stopID == %@", stop.stopID];
    NSError *error;
    NSMutableArray *myStopsToDelete = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for (NSManagedObject *managedObject in myStopsToDelete) {
        [managedObjectContext deleteObject:managedObject];
    }
    
    if (![managedObjectContext save:&error])
    {
        NSLog(@"Error deleting stop, %@", [error userInfo]);
    }
    
    [self loadMyStops];
}

- (BOOL)checkDuplicates:(Stop *)stop {
    if ([[myStops valueForKey:@"stopID"] containsObject:stop.stopID]) {
        return YES;
    }
    return NO;
}

- (void)loadMyStops{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Stop" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    myStops = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
}

- (void)loadBusStops{
    timeStart = [[NSDate date] timeIntervalSince1970];
    
    NSMutableArray *stopsJSON = [self parseJSONtoArrayFromURL:[self getURLStopsByLatitude:mapLocation.coordinate.latitude longitude:mapLocation.coordinate.longitude]];
    
    NSLog(@"ParseJSON - %f", [[NSDate date] timeIntervalSince1970] - timeStart);
    
    if (stops != nil) {
        [stops removeAllObjects];
    } else {
        stops = [[NSMutableArray alloc] init];
    }
    
    Stop *stop;
    for (NSArray *stopArray in stopsJSON) {
        if ([stopArray count] >= 9) {
            stop = [[Stop alloc]init];
            [stop setStopPointName:stopArray[1]];
            if ([stop stopPointName] == (id)[NSNull null]) [stop setStopPointName:nil];
            [stop setStopID:stopArray[2]];
            if ([stop stopID] == (id)[NSNull null]) [stop setStopID:nil];
            [stop setStopPointType:stopArray[3]];
            if ([stop stopPointType] == (id)[NSNull null]) [stop setStopPointType:nil];
            [stop setTowards:stopArray[4]];
            if ([stop towards] == (id)[NSNull null]) [stop setTowards:nil];
            [stop setBearing:stopArray[5]];
            if ([stop bearing] == (id)[NSNull null]) [stop setBearing:nil];
            [stop setStopPointIndicator:stopArray[6]];
            if ([stop stopPointIndicator] == (id)[NSNull null]) [stop setStopPointIndicator:nil];
            [stop setLatitude:stopArray[7]];
            if ([stop latitude] == (id)[NSNull null]) [stop setLatitude:nil];
            [stop setLongitude:stopArray[8]];
            if ([stop longitude] == (id)[NSNull null]) [stop setLongitude:nil];
            
            [stop setDistance:[NSNumber numberWithDouble:[self distanceFromUserLocation:stopArray[7] long:stopArray[8]]]];
            
            if (([stop stopPointType] != nil) && ([[stop stopPointType] isEqualToString:@"STBR"]
                                                  || [[stop stopPointType] isEqualToString:@"STBC"] || [[stop stopPointType] isEqualToString:@"STZZ"]
                                                  || [[stop stopPointType] isEqualToString:@"STBN"] || [[stop stopPointType] isEqualToString:@"STBS"]
                                                  || [[stop stopPointType] isEqualToString:@"STSS"] || [[stop stopPointType] isEqualToString:@"STVA"])){
//                //  Instanciamos el objeto Pin y se añade los datos a mostrar.
                Pin *pin = [[Pin alloc] init];
                [pin setTitle:[NSString stringWithFormat:@"%@ - %@",[stop stopPointIndicator],[stop stopPointName]]];
                [pin setSubtitle:[stop busNumbers]];
                [pin setStopPointIndicator:[stop stopPointIndicator]];
                [pin setBearing:[stop bearing]];
                [pin setStopID:[stop stopID]];
                
                [pin setCoordinate:CLLocationCoordinate2DMake([[stop latitude] doubleValue], [[stop longitude] doubleValue])];
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

-(float)distanceFromUserLocation:(NSString *)latitude long:(NSString *)longitude{
    
    CLLocation *stopLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    
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
    
    
    return URLString;
}

- (NSString*)getURLBusNumbersByStopID:(NSString *)stopID{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@",
                           URL_TFL_API,
                           URL_BUSES_STOP_ID,
                           stopID,
                           URL_BUSES_RETURN_LIST_JUST_NUMBERS];
    
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}


/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */


@end
