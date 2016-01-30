//
//  LineSequenceViewController.m
//  BusLondon
//
//  Created by Ruben Albiach on 13/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "LineSequenceViewController.h"

@interface LineSequenceViewController ()

@end

@implementation LineSequenceViewController{
    NSMutableArray *stops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BusService *busService = [[BusService alloc] init];
    stops = [busService getVehicleStops:[self vehicleID]];
    NSLog(@"VEHICLE ID: %@", [self vehicleID]);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([stops count] == 0) {
        return 1;
    }
    return [stops count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    //  If stops are not loaded a loading data row is created by default
    if (stops != nil && stops.count > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SequenceCell" forIndexPath:indexPath];
        Stop *stop = stops[indexPath.row];
        ;
        
        [[NSDate date] timeIntervalSince1970];
        ;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %f",
                               stop.stopPointIndicator,
                               stop.stopPointName,
                               ([stop.distance longValue] - [[NSDate date] timeIntervalSince1970])/60];
        
        NSLog(@"stop %@ - %.f - %f",
              stop.stopPointIndicator,
              ([stop.distance longValue] - [[NSDate date] timeIntervalSince1970])/60,
              ([stop.distance longValue] - [[NSDate date] timeIntervalSince1970])/60);
    
        
        return cell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"SequenceCell" forIndexPath:indexPath];
    cell.textLabel.text = @"Loading data...";
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
