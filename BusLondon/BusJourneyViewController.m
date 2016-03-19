//
//  BusJourneyViewController.m
//  BusLondon
//
//  Created by Ruben Albiach on 19/03/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import "BusJourneyViewController.h"

@interface BusJourneyViewController ()

@end

@implementation BusJourneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
//    if ([myStops count] == 0) {
//        return 1;
//    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
//    StopViewCell *stopCell;
//    
//    //  Si no hay centros cargados se crea una fila mientras se cargan los datos.
//    if (myStops.count > 0) {
//        stopCell = [tableView dequeueReusableCellWithIdentifier:@"StopCell" forIndexPath:indexPath];
//        Stop *stop = myStops[indexPath.row];
//        
//        stopCell.StopPointIndicatorLabel.text = [stop stopPointIndicator];
//        stopCell.StopNameLabel.text = [stop stopPointName];
//        stopCell.TowardsLabel.text = [stop towards];
//        stopCell.BusesLabel.text = [stop busNumbers];
//        stopCell.addFavouriteButton.tag = indexPath.row;
//        
//        stopCell.DistanceLabel.text = [myStopsService getDistanceMinutesByMeters:[stop distance]];
//        return stopCell;
//    }
//    
//    cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceHolder" forIndexPath:indexPath];
//    cell.textLabel.text = @"Loading data...";
    
    return cell;
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
