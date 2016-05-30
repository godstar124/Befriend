//
//  FriendsViewController.h
//  Befriend
//
//  Created by JinMeng on 1/18/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ProfileCell.h"

@interface FriendsViewController : UIViewController <ProfileCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *friendList;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UILabel *refreshLabel;

@end
