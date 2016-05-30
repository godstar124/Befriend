//
//  GeneralCell.m
//  Befriend
//
//  Created by JinMeng on 3/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import "GeneralCell.h"

@implementation GeneralCell

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
