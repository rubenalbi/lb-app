//
//  MyStopsViewController.m
//  BusLondon
//
//  Created by Rubén Albiach on 2/12/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import "MyStopsViewController.h"

@interface MyStopsViewController ()

@end

@implementation MyStopsViewController {
    NSMutableArray *myStops;
    MyStopsService *myStopsService;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    myStopsService = [[MyStopsService alloc] init];
    myStops = [myStopsService getMyStops];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([myStops count] == 0) {
        return 1;
    }
    return [myStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    StopViewCell *stopCell;
    
    //  Si no hay centros cargados se crea una fila mientras se cargan los datos.
    if (myStops.count > 0) {
        stopCell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
        Stop *stop = myStops[indexPath.row];
        
        stopCell.StopPointIndicatorLabel.text = [stop stopPointIndicator];
        stopCell.StopNameLabel.text = [stop stopPointName];
        stopCell.TowardsLabel.text = [stop towards];
        stopCell.BusesLabel.text = [stop busNumbers];
        stopCell.addFavouriteButton.tag = indexPath.row;
        
        stopCell.DistanceLabel.text = [myStopsService getDistanceMinutesByMeters:[stop distance]];
        return stopCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showStop"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Stop *stop = myStops[indexPath.row];
        [[segue destinationViewController] setStopID:stop.stopID];
        [[segue destinationViewController] setTitle:stop.stopPointName];
    }
}


@end
