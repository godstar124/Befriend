//
//  CollectCell.h
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *firstBtn;
@property (nonatomic, weak) IBOutlet UIButton *secondBtn;
@property (nonatomic, weak) IBOutlet UIButton *thirdBtn;

@property (nonatomic, weak) IBOutlet UILabel *firstLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdLabel;

@property (nonatomic, weak) IBOutlet UIImageView *firstIconView;
@property (nonatomic, weak) IBOutlet UIImageView *secondIconView;
@property (nonatomic, weak) IBOutlet UIImageView *thirdIconView;

@property (nonatomic, weak) IBOutlet  UIImageView *firstSelectView;
@property (nonatomic, weak) IBOutlet  UIImageView *secondSelectView;
@property (nonatomic, weak) IBOutlet  UIImageView *thirdSelectView;

@end
