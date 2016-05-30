//
//  LoginViewController.m
//  Befriend
//
//  Created by JinMeng on 4/4/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.logoLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];
    self.emailField.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:12];
    self.passwordField.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:12];
    self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0]}];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0]}];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickLogin:(id)sender
{
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    if (self.emailField.text.length <= 0 || self.passwordField.text.length <= 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please input username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //Parse login
    [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSMutableArray *enemies = [NSMutableArray arrayWithArray:user[@"Enemy"]];
                                            NSMutableArray *newEnemy = [NSMutableArray array];
                                            for (NSString *enemy in enemies) {
                                                int time = [[[enemy componentsSeparatedByString:@"$$$"] lastObject] intValue];
                                                int curr = (int)[[NSDate date] timeIntervalSince1970];
                                                if ((curr-time) > 120) {
                                                    continue;
                                                }
                                                [newEnemy addObject:enemy];
                                            }
                                            user[@"Enemy"] = newEnemy;
                                            [user[@"MeInfo"] fetch];
                                            [user[@"Filter"] fetch];
                                            user[@"Status"] = [NSNumber numberWithBool:YES];
                                            [user save];
                                            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                                                if (!error) {
                                                    user[@"Position"] = geoPoint;
                                                }
                                                
                                                [AppDelegate sharedAppDelegate].currUser = user;
                                                
                                                UIImage *image = [UIImage imageNamed:@"tmpFullPic.png"];
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"USERNAME"];
                                                [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:@"PASSWORD"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];

                                                UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"HomeNavi"];
                                                MainViewController *mainView = (MainViewController*)[navi topViewController];
                                                mainView.image = image;
                                                [AppDelegate sharedAppDelegate].profilePic = image;
                                                [AppDelegate sharedAppDelegate].window.rootViewController = navi;
                                                [[AppDelegate sharedAppDelegate].menuView.myTableView reloadData];
                                            }];
                                            
                                        } else {
                                            [[[UIAlertView alloc] initWithTitle:nil message:@"Username and password are incorrect. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                        }
                                    }];
}

#pragma mark - Keyboard events
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGRect frame = self.view.frame;
    frame.origin.y -= kbSize.height;
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
