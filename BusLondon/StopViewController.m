//
//  StopViewController.m
//  BusLondon
//
//  Created by Rubén Albiach on 30/10/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import "StopViewController.h"

@interface StopViewController ()

@end

@implementation StopViewController{
    NSMutableArray *buses;
    NSTimer* timer;
    BusService *busService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    busService = [[BusService alloc] init];
    [self loadBuses];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                      target:self selector:@selector(loadBuses)
                                                    userInfo:nil repeats:YES];
    [timer fire];
    
    // UIRefreshControl to update the list
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to update"];
    [refresh addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    self.stopIndicatorLabel.text = self.stop.stopPointIndicator;
    self.stopNameLabel.text = self.stop.stopPointName;
    self.towardsLabel.text = self.stop.towards;
    self.timeToStopLabel.text = [NSString stringWithFormat:@"%@ meters", self.stop.getDistanceString];
    self.tflInformationLabel.text = @"TFL real time information.";
}

- (void)viewDidDisappear:(BOOL)animated{
    [timer invalidate];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([buses count] == 0) {
        return 1;
    }
    return [buses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    BusViewCell *busCell;
    
    // Default cell when no stops are loaded
    if (buses.count > 0) {
        busCell = [tableView dequeueReusableCellWithIdentifier:@"BusCell" forIndexPath:indexPath];
        Bus *bus = buses[indexPath.row];
        
        busCell.busNumber.text = [bus LineName];
        busCell.towards.text = [bus DestinationName];
        if (bus.getEstimatedTimeMinutes < 1) {
            busCell.estimatedTime.text = @"due";
        } else {
            busCell.estimatedTime.text = [NSString stringWithFormat:@"%@ min", bus.getEstimatedTimeString];
            busCell.nextBuses.text = [NSString stringWithFormat:@"and in %@ min", [bus.NextBuses componentsJoinedByString:@", "]];
        }
        return busCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}

- (void)loadBuses{
    buses = [busService getStopArrivals:self.stop.stopID unifiedList:true];
    [self.tableView reloadData];
    
}

- (void)updateTable:(UIRefreshControl *)refreshControl{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    
    [self loadBuses];
    
    //  Once table is updated, set last update time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, HH:mm"];
    NSString *updated = [NSString stringWithFormat:@"Última vez: %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:updated];
    [refreshControl endRefreshing];
}

- (IBAction)refreshEstimatedTime:(id)sender {
    [self loadBuses];
}

//  Se pasa el objeto Centro que se ha seleccionado de la tabla para mostrar sus detalles
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"lineSequence"]) {
//        [[segue destinationViewController] setVehicleID: [buses[[[self.tableView indexPathForSelectedRow] row]] VehicleID]];
    }
}
@end
