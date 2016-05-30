//
//  OthersViewController.h
//  Befriend
//
//  Created by JinMeng on 12/13/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileCell.h"

@interface OthersViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) PFUser *userInfo;
@property (nonatomic, strong) id <ProfileCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isViewProfile;

@end
