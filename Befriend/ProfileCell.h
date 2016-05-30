//
//  ProfileCell.h
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileCellDelegate <NSObject>
- (void)acceptFriend:(NSIndexPath*)indexPath;
- (void)declineFriend:(NSIndexPath*)indexPath;
@end

@interface ProfileCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *profileImgView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UIView *dislikeView;
@property (nonatomic, weak) IBOutlet UIView *likeView;
@property (nonatomic, weak) IBOutlet UIView *matchView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) id <ProfileCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableDictionary *dict;

- (void)customizeCell;

@end
