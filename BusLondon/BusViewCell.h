//
//  BusViewCell.h
//  BusLondon
//
//  Created by Rubén Albiach on 30/10/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *busNumber;
@property (weak, nonatomic) IBOutlet UILabel *towards;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTime;

@end
