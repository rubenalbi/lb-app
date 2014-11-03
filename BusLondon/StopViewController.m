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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBuses];
    
    // UIRefreshControl to update the list
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to update"];
    [refresh addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    Si no hay centros cargados se crea una fila mientras se cargan los datos.
    if (buses.count > 0) {
        busCell = [tableView dequeueReusableCellWithIdentifier:@"BusCell" forIndexPath:indexPath];
        Bus *bus = buses[indexPath.row];
        
        NSLog(@"estimated minutes %f", bus.EstimatedTime);
        
        busCell.busNumber.text = [bus LineName];
        busCell.towards.text = [bus DestinationName];
        if ([bus EstimatedTime] < 1) {
            busCell.estimatedTime.text = @"due" ;
        } else {
            busCell.estimatedTime.text = [NSString stringWithFormat:@"%.0f",[bus EstimatedTime]] ;
        }
        
        return busCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}

- (void)loadBuses{
    
    NSLog(@"LoadBuses");
    
    NSMutableArray *busesJSON = [self parseJSONtoArrayFromURL:[self getURLBusesByStopID:[self stopID]]];
    
    if (buses != nil) {
        [buses removeAllObjects];
    } else {
        buses = [[NSMutableArray alloc] init];
    }
    
    Bus *bus;
    for (NSArray *busArray in busesJSON){
        if ([busArray count] >= 8) {
            bus = [[Bus alloc] init];
            [bus setStopPointName:busArray[1]];
            if ([bus StopPointName] == (id)[NSNull null]) [bus setStopPointName:nil];
            [bus setLineName:busArray[2]];
            if ([bus LineName] == (id)[NSNull null]) [bus setLineName:nil];
            [bus setDestinationName:busArray[3]];
            if ([bus DestinationName] == (id)[NSNull null]) [bus setDestinationName:nil];
            [bus setVehicleID:busArray[4]];
            if ([bus VehicleID] == (id)[NSNull null]) [bus setVehicleID:nil];
            [bus setRegistrationNumber:busArray[5]];
            if ([bus RegistrationNumber] == (id)[NSNull null]) [bus setRegistrationNumber:nil];
            // Getting UTC time in seconds and estimated minutes
            [bus setEstimatedTime:(([busArray[6] doubleValue]/1000.0)-[[NSDate date] timeIntervalSince1970])/60.0];
//            if ([bus EstimatedTime] == (id)[NSNull null]) [bus setEstimatedTime:nil];
            [bus setExpireTime:busArray[7]];
            
            [buses addObject:bus];
        }
    }
    
    buses = [self insertionSort:buses];
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

- (NSString*)getURLBusesByStopID:(NSString*)stopID{
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@%@",
                           URL_TFL_API,
                           URL_BUSES_STOP_ID,
                           stopID,
                           URL_BUSES_RETURN_LIST];
    
    NSLog(@"%@", URLString);
    
    return URLString;
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

-(NSMutableArray *)insertionSort:(NSMutableArray *)unsortedDataArray
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (Bus *bus in unsortedDataArray) {
        [tempArray addObject:[NSNumber numberWithDouble:bus.EstimatedTime]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
