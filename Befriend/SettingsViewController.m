//
//  SettingsViewController.m
//  Befriend
//
//  Created by JinMeng on 1/18/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "SigninViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
    titleLabel.text = @"Settings";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [menuBtn setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(clickMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickMenu
{
    UIView *menuView = [AppDelegate sharedAppDelegate].menuView.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = menuView.frame;
    frame.origin.x = -100;
    menuView.frame = frame;
    [UIView commitAnimations];
}

- (void)clickSwitch:(id)sender
{
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"SettingCell";
    
    //Configure Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
    cell.textLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
    
    
    switch (indexPath.row) {
//        case 0:
//        {
//            cell.textLabel.text = @"Vibrate on Notification";
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UISwitch *vibrate = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
//            vibrate.onTintColor = [UIColor colorWithRed:237/255.0 green:138/255.0 blue:0.0 alpha:1.0];
//            [vibrate addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
//            cell.accessoryView = vibrate;
//            break;
//        }
        case 0:
        {
            cell.textLabel.text = @"Contact Us";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Log out";
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
    }
    
    return cell;
    
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
//        case 0:
//            break;
        case 0://Contact us
        {
            if ([MFMailComposeViewController canSendMail]) {
                
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                mailer.modalPresentationStyle = UIModalPresentationPageSheet;
                [mailer setSubject:@"Contact Us"];
                
                NSString *emailBody = @"";
                [mailer setMessageBody:emailBody isHTML:NO];
                [mailer setToRecipients:@[@"help@be-friend.co.uk"]];
                [self presentViewController:mailer animated:YES completion:^{
                    mailer.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
                    mailer.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
                }];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Email composition failure. Please try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        }
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure want to log out?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Log out", @"Cancel", nil];
            alert.tag = 101;
            [alert show];
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"SigninNavi"];
        [AppDelegate sharedAppDelegate].window.rootViewController = navi;
    }
}

#pragma mark - MFMailComposerViewController
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
