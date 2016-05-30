//
//  ShowMeCell.h
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *showMe;
@property (nonatomic, weak) IBOutlet UILabel *men;
@property (nonatomic, weak) IBOutlet UILabel *women;
@property (nonatomic, weak) IBOutlet UISwitch *switchMen;
@property (nonatomic, weak) IBOutlet UISwitch *switchWomen;

@end
