//
//  MoneyCell.h
//  Befriend
//
//  Created by JinMeng on 1/15/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;
@property (nonatomic, weak) IBOutlet UILabel *burnLabel;
@property (nonatomic, weak) IBOutlet UISlider *burnSlider;

@end
