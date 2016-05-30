//
//  AppDelegate.h
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import <Parse/PFFacebookUtils.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MenuViewController *menuView;
@property (nonatomic, strong) UIImage *profilePic;
@property (nonatomic, strong) PFUser *currUser;
@property (nonatomic, assign) BOOL isExistRequest;

@property (nonatomic, strong) CLLocationManager *locMan;

+ (AppDelegate *)sharedAppDelegate;
- (NSString *)applicationDocumentsDirectory;
- (void)showViewController:(UIViewController*)addView;

@end
