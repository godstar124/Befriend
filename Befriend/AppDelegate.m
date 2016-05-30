//
//  AppDelegate.m
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MainViewController.h"
#import "SigninViewController.h"
#import "Appirater.h"

@implementation AppDelegate

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
//    [currentInstallation addUniqueObject:[NSString stringWithFormat:@"CH_%@", self.currUser.username] forKey:@"channels"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"naviback.png"] forBarMetrics:UIBarMetricsDefault];

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.menuView = [board instantiateViewControllerWithIdentifier:@"MenuView"];
    
    [Parse setApplicationId:@"JbDvfNRLtTbU7tNPOfbe7TLjJA5A9IKI2xPjRRMo" clientKey:@"JxQFOALK2DO0ABESg0AT3vZTDcb5rOBFEJwZohk9"];
    [PFFacebookUtils initializeFacebook];

    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicWriteAccess:YES];
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        self.locMan = [[CLLocationManager alloc] init];
        [self.locMan requestWhenInUseAuthorization];
        [self.locMan startUpdatingLocation];
    }

    //Custom code segment
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    if (userName != nil) {

        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
        if (password.length <= 0) {
            password = @"kki";
        }
        
        [PFUser logInWithUsernameInBackground:userName password:password
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
                                                    
                                                    self.currUser = user;
                                                    
                                                    UIImage *image;
                                                    NSData *imgData = user[@"Photo"];
                                                    if (imgData != nil) {
                                                        image = [UIImage imageWithData:imgData];
                                                    }
                                                    else {
                                                        if ([user[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
                                                            NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=640", user.username];
                                                            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                                                            image = [UIImage imageWithData:data];
                                                        }
                                                        else {
                                                            image = [UIImage imageNamed:@"tmpFullPic.png"];
                                                        }
                                                    }
                                                    
                                                    UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"HomeNavi"];
                                                    MainViewController *mainView = (MainViewController*)[navi topViewController];
                                                    mainView.image = image;
                                                    self.profilePic = image;
                                                    [AppDelegate sharedAppDelegate].window.rootViewController = navi;
                                                    [[AppDelegate sharedAppDelegate].menuView.myTableView reloadData];
                                                }];
                                                
                                            } else {
                                                
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PASSWORD"];
                                                [[NSUserDefaults standardUserDefaults] synchronize];
                                                
                                                UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"SigninNavi"];
                                                [AppDelegate sharedAppDelegate].window.rootViewController = navi;
                                            }
                                        }];
    }
    else {
        UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"SigninNavi"];
        [AppDelegate sharedAppDelegate].window.rootViewController = navi;
    }


    [Appirater setAppId:@"843457778"];
    [Appirater setDaysUntilPrompt:0];
    [Appirater setUsesUntilPrompt:4];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if (self.currUser) {
        self.currUser[@"Status"] = [NSNumber numberWithBool:NO];
        [self.currUser save];
        PFObject *meInfo = self.currUser[@"MeInfo"];
        [meInfo save];
        PFObject *filter = self.currUser[@"Filter"];
        [filter save];
    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (self.currUser) {
        [self.currUser fetchIfNeeded];
        [self.currUser[@"MeInfo"] fetchIfNeeded];
        [self.currUser[@"Filter"] fetchIfNeeded];

        NSMutableArray *enemies = [NSMutableArray arrayWithArray:self.currUser[@"Enemy"]];
        for (NSString *enemy in enemies) {
            int time = [[[enemy componentsSeparatedByString:@"$$$"] lastObject] intValue];
            int curr = (int)[[NSDate date] timeIntervalSince1970];
            if ((curr-time) > 86400*15) {
                [enemies removeObject:enemy];
            }
        }
        self.currUser[@"Enemy"] = enemies;
        self.currUser[@"Status"] = [NSNumber numberWithBool:YES];
        [self.currUser save];

        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            if (!error) {
                self.currUser[@"Position"] = geoPoint;
            }
        }];
    }

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }

    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)showViewController:(UIViewController*)addView
{
    UINavigationController *navi = (UINavigationController*)self.window.rootViewController;
    [navi popToRootViewControllerAnimated:NO];
    [navi pushViewController:addView animated:YES];
}
@end
