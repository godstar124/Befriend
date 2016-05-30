//
//  WithinCell.h
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithinCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *withinLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UISlider *distSlider;

@end
