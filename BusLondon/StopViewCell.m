//
//  StopViewCell.m
//  BusLondon
//
//  Created by Rubén Albiach on 11/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#import "StopViewCell.h"

@implementation StopViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
