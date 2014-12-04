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
    
}

@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // CORE DATA
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Stop" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    myStops = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    for (StopDAO *info in myStops) {
        NSLog(@"Name: %@", info.stopPointName);
        NSLog(@"stopID: %@", info.stopID);
        NSLog(@"Distance: %@", info.distance);
        NSLog(@"-----");
    }

    
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
        
        stopCell.DistanceLabel.text = [NSString stringWithFormat:@"%.0f min walk",([[stop distance] doubleValue]/1.4)/60];
        
        return stopCell;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
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
