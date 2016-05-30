//
//  ProfileViewController.h
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileCell.h"

@interface ProfileViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *profilePicView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *lookforLabel;
@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;
@property (nonatomic, weak) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, weak) IBOutlet UILabel *betweenLabel;
@property (nonatomic, weak) IBOutlet UIView *bottomView;
@property (nonatomic, weak) IBOutlet UIButton *acceptBtn;
@property (nonatomic, weak) IBOutlet UIButton *declineBtn;

@property (nonatomic, strong) PFUser *userInfo;
@property (nonatomic, assign) BOOL isViewMe;
@property (nonatomic, assign) BOOL isViewProfile;

@property (nonatomic, strong) id <ProfileCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
