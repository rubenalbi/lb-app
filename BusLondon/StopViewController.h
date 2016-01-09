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

@interface StopViewController : UITableViewController

@property NSString *stopID;
- (IBAction)refreshEstimatedTime:(id)sender;

@end
