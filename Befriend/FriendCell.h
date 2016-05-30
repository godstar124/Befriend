//
//  FriendCell.h
//  Befriend
//
//  Created by JinMeng on 1/18/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *pictureView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *exclaimationView;

@end
