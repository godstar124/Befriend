//
//  MenuViewController.m
//  Befriend
//
//  Created by JinMeng on 1/16/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MenuCell.h"
#import "UIImage-Extensions.h"
#import "MeViewController.h"
#import "FriendsViewController.h"
#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "UserViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)swipeView
{
    UIView *menuView = self.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = menuView.frame;
    frame.origin.x = -320;
    menuView.frame = frame;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"MenuCell";
    
    //Configure Cell
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.mainLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:16];
    switch (indexPath.row) {
        case 0:
            cell.mainLabel.text = @"Me";
            if ([AppDelegate sharedAppDelegate].profilePic) {
                cell.iconView.image = [[AppDelegate sharedAppDelegate].profilePic imageByScalingProportionallyToMinimumSize:CGSizeMake(52, 52)];
                cell.iconView.layer.cornerRadius = 13;
            }
            else
            {
                cell.iconView.image = [[UIImage imageNamed:@"tmpProfile.png"] imageByScalingProportionallyToSize:CGSizeMake(52, 52)];
                cell.iconView.layer.cornerRadius = 13;
            }
            break;
        case 1:
            cell.mainLabel.text = @"Home";
            cell.iconView.image = [UIImage imageNamed:@"iconHome.png"];
            cell.iconView.layer.cornerRadius = 0;
            break;
        case 2:
        {
            cell.mainLabel.text = @"Friends";
            cell.iconView.image = [UIImage imageNamed:@"iconFriend.png"];
            cell.iconView.layer.cornerRadius = 0;
            
            UILabel *number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            number.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:13];
            number.textAlignment = NSTextAlignmentCenter;
            number.text = @"1";
            number.backgroundColor = [UIColor whiteColor];
            number.layer.cornerRadius = 2;
//            cell.accessoryView = number;
            if ([AppDelegate sharedAppDelegate].isExistRequest) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                imgView.image = [UIImage imageNamed:@"iconExcaim.png"];
                cell.accessoryView = imgView;
            }
            else {
                cell.accessoryView = nil;
            }
            break;
        }
        case 3:
            cell.mainLabel.text = @"Settings";
            cell.iconView.image = [UIImage imageNamed:@"iconSetting.png"];
            cell.iconView.layer.cornerRadius = 0;
            break;
        case 4:
            cell.mainLabel.text = @"";
            break;
    }
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight;
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
            rowHeight = 60;
            break;
        case 4:
            rowHeight = tableView.frame.size.height - 240;
            break;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 4) {
        return;
    }
    
    if (indexPath.row == 0) { //Me
        UINavigationController *navi = (UINavigationController*)[AppDelegate sharedAppDelegate].window.rootViewController;
        [navi popToRootViewControllerAnimated:NO];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UserViewController *userView = [board instantiateViewControllerWithIdentifier:@"UserView"];
        userView.userInfo = [AppDelegate sharedAppDelegate].currUser;
        
        [navi pushViewController:userView animated:NO];
    }

    if (indexPath.row == 1) { //Home
        UINavigationController *navi = (UINavigationController*)[AppDelegate sharedAppDelegate].window.rootViewController;
        [navi popToRootViewControllerAnimated:NO];
    }
    
    if (indexPath.row == 2) { //Friends
        UINavigationController *navi = (UINavigationController*)[AppDelegate sharedAppDelegate].window.rootViewController;
        [navi popToRootViewControllerAnimated:NO];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FriendsViewController *friendView = [board instantiateViewControllerWithIdentifier:@"FriendView"];
        
        [navi pushViewController:friendView animated:NO];
    }
    
    if (indexPath.row == 3) { //Setting
        UINavigationController *navi = (UINavigationController*)[AppDelegate sharedAppDelegate].window.rootViewController;
        [navi popToRootViewControllerAnimated:NO];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SettingsViewController *settingView = [board instantiateViewControllerWithIdentifier:@"SettingView"];
        
        [navi pushViewController:settingView animated:NO];
    }

    UIView *menuView = self.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = menuView.frame;
    frame.origin.x = -320;
    menuView.frame = frame;
    [UIView commitAnimations];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
