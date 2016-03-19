//
//  StopViewController.h
//  BusLondon
//
//  Created by Rubén Albiach on 30/10/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "BusViewCell.h"
#import "BusService.h"
#import "LineSequenceViewController.h"
@interface StopViewController : UITableViewController

@property Stop *stop;

- (IBAction)refreshEstimatedTime:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *stopIndicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *towardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeToStopLabel;
@property (weak, nonatomic) IBOutlet UILabel *tflInformationLabel;

@end
