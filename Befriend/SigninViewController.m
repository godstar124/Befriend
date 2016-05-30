//
//  SigninViewController.m
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "SigninViewController.h"
#import "InterestViewController.h"
#import <Parse/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

@interface SigninViewController ()

@property (nonatomic, strong) CLLocationManager *locMan;

@end

@implementation SigninViewController

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
    self.facebookLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:11];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSignin:(id)sender
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Signing in...";
    self.hud.animationType = MBProgressHUDAnimationFade;
    self.hud.mode = MBProgressHUDModeIndeterminate;

    [PFFacebookUtils logInWithPermissions:@[@"basic_info", @"user_birthday", @"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [self.hud hide:YES];
            
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
            [self requestUserInfo];
            
        } else {
            NSLog(@"User logged in through Facebook!");
            [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"USERNAME"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSMutableArray *enemies = [NSMutableArray arrayWithArray:user[@"Enemy"]];
            for (NSString *enemy in enemies) {
                int time = [[[enemy componentsSeparatedByString:@"$$$"] lastObject] intValue];
                int curr = (int)[[NSDate date] timeIntervalSince1970];
                if ((curr-time) > 86400*15) {
                    [enemies removeObject:enemy];
                }
            }
            user[@"Enemy"] = enemies;
            [user[@"MeInfo"] fetch];
            [user[@"Filter"] fetch];
            user[@"Status"] = [NSNumber numberWithBool:YES];
            [user save];
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:[NSString stringWithFormat:@"CH_%@", user.username] forKey:@"channels"];
            [currentInstallation saveInBackground];

            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                if (!error) {
                    user[@"Position"] = geoPoint;
                }
                
                [AppDelegate sharedAppDelegate].currUser = user;
                
                NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=640", user.username];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                UIImage *image = [UIImage imageWithData:data];
                
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"HomeNavi"];
                MainViewController *mainView = (MainViewController*)[navi topViewController];
                mainView.image = image;
                [AppDelegate sharedAppDelegate].profilePic = image;
                [AppDelegate sharedAppDelegate].window.rootViewController = navi;
                [[AppDelegate sharedAppDelegate].menuView.myTableView reloadData];
            }];

            [self.hud hide:YES];
        }
    }];
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            // Success! Include your code to handle the results here ~~~~~ birthday 02/16/1986
            NSDictionary *dict = (NSDictionary*)result;
            NSLog(@"%@", [NSString stringWithFormat:@"user info: %@", result]);
            
            PFUser *user = [PFUser currentUser];
            user.email = dict[@"email"];
            user.username = dict[@"id"];
            user.password = @"kki";
//            user[@"fullName"] = [NSString stringWithFormat:@"%@ %@", dict[@"first_name"], dict[@"last_name"]];
            user[@"fullName"] = [NSString stringWithFormat:@"%@", dict[@"first_name"]];
            user[@"Friends"] = [NSArray array];
            user[@"Enemy"] = [NSArray array];
            
            int age = 17;
            if (dict[@"birthday"]) {
                int year = [[[dict[@"birthday"] componentsSeparatedByString:@"/"] lastObject] intValue];
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy"];
                int current = [[formatter stringFromDate:date] intValue];
                age = current - year;
            }
            //Create Me info
            PFObject *meInfo = [PFObject objectWithClassName:@"MeClass"];
            meInfo[@"Gender"] = [NSNumber numberWithInt:0];
            meInfo[@"MoneyToBurn"] = [NSNumber numberWithInt:500];
            meInfo[@"MyAge"] = [NSNumber numberWithInt:age];
            meInfo[@"Nationality"] = [NSNumber numberWithInt:0];
            meInfo[@"Religion"] = [NSNumber numberWithInt:0];
            meInfo[@"Personality"] = [NSNumber numberWithInt:0];
            meInfo[@"Children"] = [NSNumber numberWithInt:0];
            meInfo[@"Intelligence"] = [NSNumber numberWithInt:1];
            meInfo[@"University"] = [NSNumber numberWithInt:0];
            meInfo[@"Employer"] = @"";
            meInfo[@"About"] = @"";
            meInfo[@"Parent"] = [NSString stringWithString:user[@"username"]];
            NSMutableArray *selectionArray = [NSMutableArray array];
            for (int i = 0; i < 9; i++) { [selectionArray addObject:[NSNumber numberWithBool:NO]]; }
            meInfo[@"Hobby"] = selectionArray;
            user[@"MeInfo"] = meInfo;
            
            //Create Filter Info
            PFObject *filter = [PFObject objectWithClassName:@"FilterClass"];
            filter[@"Men"] = [NSNumber numberWithBool:YES];
            filter[@"Women"] = [NSNumber numberWithBool:YES];
            filter[@"Within"] = [NSNumber numberWithInt:25];
            filter[@"StartAge"] = [NSNumber numberWithInt:23];
            filter[@"EndAge"] = [NSNumber numberWithInt:38];
            filter[@"StartMoney"] = [NSNumber numberWithInt:200];
            filter[@"EndMoney"] = [NSNumber numberWithInt:600];
            filter[@"Parent"] = [NSString stringWithString:user[@"username"]];
            NSMutableArray *personalityArray = [NSMutableArray array];
            for (int i = 0; i < 13; i++) { [personalityArray addObject:[NSNumber numberWithBool:NO]]; }
            filter[@"Personality"] = personalityArray;
            filter[@"Child"] = [NSNumber numberWithInt:0];
            
            user[@"Filter"] = filter;
            user[@"Status"] = [NSNumber numberWithBool:YES];

            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:[NSString stringWithFormat:@"CH_%@", user.username] forKey:@"channels"];
            [currentInstallation saveInBackground];

            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                user[@"Position"] = geoPoint;

                [AppDelegate sharedAppDelegate].currUser = user;
                
                [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"USERNAME"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainNavi = (UINavigationController*)[board instantiateViewControllerWithIdentifier:@"MainNavi"];
                [AppDelegate sharedAppDelegate].window.rootViewController = mainNavi;
            }];

        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"%@", [NSString stringWithFormat:@"error %@", error.description]);
        }
        
        [self.hud hide:YES];
    }];
}

- (void)requestUserInfo
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"basic_info", @"user_birthday", @"email"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"%@", [NSString stringWithFormat:@"error %@", error.description]);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"%@", [NSString stringWithFormat:@"error %@", error.description]);
                                  [self.hud hide:YES];
                              }
                          }];
    
    
    
}

- (IBAction)clickLogin:(id)sender
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginView = [board instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:loginView animated:YES];
}

- (IBAction)clickSignup:(id)sender
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignupViewController *signupView = [board instantiateViewControllerWithIdentifier:@"SignupView"];
    [self.navigationController pushViewController:signupView animated:YES];
}

@end
