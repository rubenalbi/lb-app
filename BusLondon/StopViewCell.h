//
//  StopViewCell.h
//  BusLondon
//
//  Created by Rubén Albiach on 11/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *StopPointIndicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *StopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TowardsLabel;
@property (weak, nonatomic) IBOutlet UILabel *BusesLabel;
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;

@end
