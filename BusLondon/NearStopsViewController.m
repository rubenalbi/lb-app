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
        
        stopCell.DistanceLabel.text = [NSString stringWithFormat:@"%.0fm",[stop distance]];
        
        return stopCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadBusStops{
    
    NSLog(@"LoadBusStops");
    
    NSMutableArray *stopsJSON = [self parseJSONtoArrayFromURL:[self getURLStopsByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude]];
    
    if (stops != nil) {
        [stops removeAllObjects];
    } else {
        stops = [[NSMutableArray alloc] init];
    }
    
    Stop *stop;
    CLLocation *stopLocation;
    for (NSArray *stopArray in stopsJSON) {
        if ([stopArray count] >= 8) {
            stop = [[Stop alloc]init];
            [stop setStopPointName:stopArray[1]];
            if ([stop StopPointName] == (id)[NSNull null]) [stop setStopPointName:nil];
            [stop setStopID:stopArray[2]];
            if ([stop StopID] == (id)[NSNull null]) [stop setStopID:nil];
            [stop setStopPointType:stopArray[3]];
            if ([stop StopPointType] == (id)[NSNull null]) [stop setStopPointType:nil];
            [stop setTowards:stopArray[4]];
            if ([stop Towards] == (id)[NSNull null]) [stop setTowards:nil];
            [stop setStopPointIndicator:stopArray[5]];
            if ([stop StopPointIndicator] == (id)[NSNull null]) [stop setStopPointIndicator:nil];
            
            [stop setLatitude:stopArray[6]];
            if ([stop Latitude] == (id)[NSNull null]) [stop setLatitude:nil];
            [stop setLongitude:stopArray[7]];
            if ([stop Longitude] == (id)[NSNull null]) [stop setLongitude:nil];
            
            stopLocation = [[CLLocation alloc] initWithLatitude:[stopArray[6] doubleValue] longitude:[stopArray[7] doubleValue]];
            
            [stop setStopLocation:stopLocation];
            
            [stop setBusNumbers:[self getBusNumbersByStopID:[stop StopID]]];
            
            [stop setDistance:[userLocation distanceFromLocation:stopLocation]];
            
            if (([stop StopPointType] != nil) && ([[stop StopPointType] isEqualToString:@"STBR"]
                                                  || [[stop StopPointType] isEqualToString:@"STBC"] || [[stop StopPointType] isEqualToString:@"STZZ"]
                                                  || [[stop StopPointType] isEqualToString:@"STBN"] || [[stop StopPointType] isEqualToString:@"STBS"]
                                                  || [[stop StopPointType] isEqualToString:@"STSS"] || [[stop StopPointType] isEqualToString:@"STVA"])){
                [stops addObject:stop];
            }
        }
    }
    
    stops = [self insertionSort:stops];
    [self.tableView reloadData];
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
    
//    NSLog(@"%@", URLString);
    
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

//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    NSLog(@"locationManager");
//    CLLocation *crnLoc = [locations lastObject];
//    
//    userLocation = crnLoc;
////    latitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
////    longitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
//    
//    [locationManager stopUpdatingLocation];
//    [self loadBusStops];
//    
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSLog(@"Load new location");
    userLocation = newLocation;
    
//    [locationManager stopUpdatingLocation];
    
    if (!firstLoad) {
        [self loadBusStops];
        firstLoad = true;
    }
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

//  Se pasa el objeto Centro que se ha seleccionado de la tabla para mostrar sus detalles
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showStop"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Stop *stop = stops[indexPath.row];
        [[segue destinationViewController] setStopID:stop.StopID];
        [[segue destinationViewController] setTitle:stop.StopPointName];
    }
}

@end
