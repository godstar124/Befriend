//
//  MainViewController.h
//  Befriend
//
//  Created by JinMeng on 1/16/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <Parse/PFFacebookUtils.h>
#import "ProfileCell.h"

@interface MainViewController : UIViewController <SearchProtocol, ProfileCellDelegate>

@property (nonatomic, weak) IBOutlet UIView *loadingContainer;
@property (nonatomic, weak) IBOutlet UIImageView *profileView;
@property (nonatomic, weak) IBOutlet UIImageView *backSplashView;
@property (nonatomic, weak) IBOutlet UILabel *bottomLabel;
@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UILabel *searchLabel;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableArray *friends;

@end
