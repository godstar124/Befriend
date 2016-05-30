//
//  MainViewController.m
//  Befriend
//
//  Created by JinMeng on 1/16/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "MainViewController.h"
#import "SearchFilterViewController.h"
#import "UIImage-Extensions.h"
#import <Parse/PFFacebookUtils.h>
#import "ChatViewController.h"
#import "MatchViewController.h"
#import "ProfileViewController.h"
#import "OthersViewController.h"

#define STACK_SIZE 30

@interface MainViewController () {
    PFObject *filter;
    BOOL isSearching;
    int currentPage;
    BOOL isMore;
}

@end

@implementation MainViewController

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
    
    self.bottomLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
    self.profileView.layer.cornerRadius = self.profileView.frame.size.height / 2;
    
    UIImageView *topLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toplogo.png"]];
    self.navigationItem.titleView = topLogo;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [menuBtn setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(clickMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [searchBtn setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickFilter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *menuView = [AppDelegate sharedAppDelegate].menuView.view;
    CGRect frame = menuView.frame;
    frame.origin.x = -320;
    menuView.frame = frame;
    [self.navigationController.view addSubview:[AppDelegate sharedAppDelegate].menuView.view];

    [AppDelegate sharedAppDelegate].menuView.delegate = self;

    if (self.image) {
        self.profileView.image = self.image;
    }
    else {
        self.profileView.image = [UIImage imageNamed:@"tmpProfile.png"];
    }

    //Load Search Filter
    PFUser *user = [AppDelegate sharedAppDelegate].currUser;
    filter = user[@"Filter"];

    self.searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, -30, 202, 20)];
    self.searchLabel.text = @"Pull down to search friends";
    self.searchLabel.textAlignment = NSTextAlignmentCenter;
    self.searchLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0f];
    self.searchLabel.textColor = [UIColor lightGrayColor];
    self.searchLabel.backgroundColor = [UIColor clearColor];
    [self.myTableView addSubview:self.searchLabel];

    [self showLoadingView];
    currentPage = 0;
    self.friends = [NSMutableArray array];
    [self performSelector:@selector(searchFriends) withObject:nil afterDelay:0.2];
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

- (void)clickFilter
{
    if (isSearching) {
        return;
    }
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"FilterNavi"];
    SearchFilterViewController *filterView = (SearchFilterViewController*)[navi topViewController];
    filterView.delegate = self;
    filterView.filter = filter;
    [self presentViewController:navi animated:YES completion:NULL];
}

- (void)updateRequest
{
    [AppDelegate sharedAppDelegate].isExistRequest = NO;
    //Check whether there is incoming request
    PFQuery *queryRequest = [PFQuery queryWithClassName:@"Requests"];
    [queryRequest whereKey:@"Resolve" containedIn:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], nil]];
    NSMutableArray *requests = [NSMutableArray arrayWithArray:[queryRequest findObjects]];
    for (PFObject *element in requests) {
        if (![element[@"Receiver"] isEqualToString:[AppDelegate sharedAppDelegate].currUser.username])
            continue;
        [AppDelegate sharedAppDelegate].isExistRequest = YES;
    }
    [[AppDelegate sharedAppDelegate].menuView.myTableView reloadData];
}

- (void)clickMenu
{
    if (isSearching) {
        return;
    }
    [self performSelector:@selector(updateRequest) withObject:nil afterDelay:0.1];
    
    UIView *menuView = [AppDelegate sharedAppDelegate].menuView.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = menuView.frame;
    frame.origin.x = -100;
    menuView.frame = frame;
    [UIView commitAnimations];
}

- (void)showLoadingView
{
    isSearching = YES;
    
    CALayer *layer = self.backSplashView.layer.presentationLayer;
    [self.backSplashView.layer removeAllAnimations];
    self.backSplashView.frame = layer.frame;
    
    self.backSplashView.frame = CGRectMake(46, 0, 110, 110);
    self.backSplashView.alpha = 1.0;
    self.loadingContainer.alpha = 1.0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatCount:CGFLOAT_MAX];
    CGRect frame = self.backSplashView.frame;
    frame.size.height += 100;
    frame.size.width += 100;
    frame.origin.x -= 50;
    frame.origin.y -= 50;
    self.backSplashView.frame = frame;
    self.backSplashView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)hideLoadingView
{
    isSearching = NO;

    [self.myTableView reloadData];
    
    self.backSplashView.frame = CGRectMake(46, 0, 110, 110);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.loadingContainer.alpha = 0.0;
    [UIView commitAnimations];
}

#pragma mark - ProfileCellDelegate
- (void)acceptFriend:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.friends objectAtIndex:indexPath.row];
    PFUser *user = dict[@"USERINFO"];

    NSMutableArray *array = [NSMutableArray arrayWithArray:[AppDelegate sharedAppDelegate].currUser[@"Friends"]];
    BOOL isFound = NO;
    for (NSString *element in array) {
        if ([element isEqualToString:user.username]) {
            isFound = YES;
        }
    }
    if (!isFound) {
        [array addObject:user.username];
    }
    [AppDelegate sharedAppDelegate].currUser[@"Friends"] = array;

    NSArray *arr1 = user[@"Friends"];
    isFound = NO;
    for (NSString *element in arr1) {
        if ([element isEqualToString:[AppDelegate sharedAppDelegate].currUser.username]) {
            isFound = YES;
        }
    }
    if (!isFound) {
        PFObject *request = [PFObject objectWithClassName:@"Requests"];
        request[@"Sender"] = [AppDelegate sharedAppDelegate].currUser.username;
        request[@"Receiver"] = user.username;
        request[@"Resolve"] = [NSNumber numberWithBool:NO];
        [request saveInBackground];

        NSString *msg = [NSString stringWithFormat:@"%@ sent you friend request.", [[AppDelegate sharedAppDelegate].currUser[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];
        // Create our Installation query
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:[NSString stringWithFormat:@"CH_%@", user.username]];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              msg, @"alert",
                              @"Increment", @"badge",
                              nil];
        
        [push setData:data];
        [push expireAfterTimeInterval:86400];
        [push sendPushInBackground];
    }
    
    [self.friends removeObjectAtIndex:indexPath.row];
    [self.myTableView reloadData];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MatchViewController *matchView = (MatchViewController*)[board instantiateViewControllerWithIdentifier:@"MatchView"];
    matchView.userInfo = user;
    [[AppDelegate sharedAppDelegate] showViewController:matchView];
}

- (void)declineFriend:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.friends objectAtIndex:indexPath.row];
    PFUser *user = dict[@"USERINFO"];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[AppDelegate sharedAppDelegate].currUser[@"Enemy"]];
    BOOL isFound = NO;
    for (NSString *element in array) {
        if ([[[element componentsSeparatedByString:@"$$$"] firstObject] isEqualToString:user.username]) {
            isFound = YES;
        }
    }
    if (!isFound) {
        NSString *res = [NSString stringWithFormat:@"%@$$$%d", user.username, (int)([[NSDate date] timeIntervalSince1970])];
        [array addObject:res];
    }
    
    [AppDelegate sharedAppDelegate].currUser[@"Enemy"] = array;
    
    [self.friends removeObjectAtIndex:indexPath.row];
    [self.myTableView reloadData];
    
    UINavigationController *navi = (UINavigationController*)[AppDelegate sharedAppDelegate].window.rootViewController;
    [navi popToRootViewControllerAnimated:YES];
}

#pragma mark - SearchProtocol
- (void)seletedFilter
{
    [self performSelector:@selector(showLoadingView) withObject:nil afterDelay:0.2];
    currentPage = 0;
    self.friends = [NSMutableArray array];
    [self performSelector:@selector(searchFriends) withObject:nil afterDelay:0.5];
}

- (void)searchFriends
{
    PFUser *userInfo = [AppDelegate sharedAppDelegate].currUser;
    //Filter friends by distance
    PFGeoPoint *userGeoPoint = userInfo[@"Position"];
    // Create a query for places
    PFQuery *query = [PFUser query];
    // Interested in locations near user.
    [query whereKey:@"Position" nearGeoPoint:userGeoPoint withinMiles:[filter[@"Within"] intValue]];
//    [query whereKey:@"Position" nearGeoPoint:userGeoPoint];

    // Limit what could be a lot of points.
    query.skip = currentPage * STACK_SIZE;
    query.limit = STACK_SIZE;
    // Final list of objects
    NSArray *results = [query findObjects];
    if (results.count == STACK_SIZE) { isMore = YES; }
    else {isMore = NO;}
    
    for (PFUser *friend in results) {
        [friend[@"MeInfo"] fetchIfNeeded];
        [friend[@"Filter"] fetchIfNeeded];
    }

    for (int i = 0; i < results.count; i++) {
        PFUser *friend = [results objectAtIndex:i];
        
        if ([friend.username isEqualToString:userInfo.username]) { continue; }
        if ([self isUserFriend:friend.username]) { continue; }
        if ([self isUserEnemy:friend.username]) { continue; }
        
        if([self compareFilters:friend]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"LIKE"];
            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"DISLIKE"];
            [dict setObject:friend forKey:@"USERINFO"];
            [self.friends addObject:dict];
        }
    }
    
    [self.myTableView reloadData];
    [self hideLoadingView];
}

- (BOOL)isUserFriend:(NSString*)userName
{
    PFUser *userInfo = [AppDelegate sharedAppDelegate].currUser;
    NSArray *array = userInfo[@"Friends"];
    
    BOOL result = NO;
    for (NSString *friend in array) {
        if ([userName isEqualToString:friend]) {
            result = YES;
            break;
        }
    }
    
    return result;
}

- (BOOL)isUserEnemy:(NSString*)userName
{
    PFUser *userInfo = [AppDelegate sharedAppDelegate].currUser;
    NSArray *array = userInfo[@"Enemy"];
    
    BOOL result = NO;
    for (NSString *user in array) {
        if ([[[user componentsSeparatedByString:@"$$$"] firstObject] isEqualToString:userName]) {
            result = YES;
            break;
        }
    }
    
    return result;
}

- (BOOL)compareFilters:(PFUser*)resultUser
{
    PFObject *meInfo = resultUser[@"MeInfo"];
    
    PFObject *myMeInfo = [AppDelegate sharedAppDelegate].currUser[@"MeInfo"];
    PFObject *myFilter = [AppDelegate sharedAppDelegate].currUser[@"Filter"];
    
    //Age filter
    int startAge = [myFilter[@"StartAge"] intValue];
    int endAge = [myFilter[@"EndAge"] intValue];
    if ([meInfo[@"MyAge"] intValue] <= startAge) { return NO; }
    if ([meInfo[@"MyAge"] intValue] > endAge && endAge < 41) { return NO; }
    
    //Gender filter
    if (![myFilter[@"Men"] boolValue] && [meInfo[@"Gender"] intValue] == 0) { return NO; }
    if (![myFilter[@"Women"] boolValue] && [meInfo[@"Gender"] intValue] == 1) { return NO; }

    //Child filter
    if (([myFilter[@"Child"] intValue] == 1) && ([meInfo[@"Children"] intValue] == 0)) {return NO;}
    if (([myFilter[@"Child"] intValue] == 2) && ([meInfo[@"Children"] intValue] != 0)) {return NO;}
    
    //MoneyToBurn
    int startMoney = [myFilter[@"StartMoney"] intValue];
    int endMoney = [myFilter[@"EndMoney"] intValue];
    if (endMoney > 1000) {
        if ([meInfo[@"MoneyToBurn"] intValue] < startMoney) {return NO;}
    }
    else {
        if (([meInfo[@"MoneyToBurn"] intValue] < startMoney) || ([meInfo[@"MoneyToBurn"] intValue] > endMoney)) {return NO;}
    }
    
    //Interests
    {
        NSArray *interests = [AppDelegate sharedAppDelegate].currUser[@"INTEREST"];
        BOOL set = NO;
        for (NSNumber *number in interests) { set = set || [number boolValue]; }
        if (set) {
            BOOL set1 = NO;
            NSArray *interests1 = resultUser[@"INTEREST"];
            for (NSNumber *number in interests1) { set1 = set1 || [number boolValue]; }
            if (set1) {
                BOOL result = NO;
                for (int i = 0; i < 40; i++) {
                    NSNumber *num1, *num2;
                    num1 = [interests objectAtIndex:i];
                    num2 = [interests1 objectAtIndex:i];
                    if (([num1 boolValue] == [num2 boolValue]) && [num1 boolValue] && [num2 boolValue]) {
                        result = YES;
                        break;
                    }
                }
                
                if (result == NO) {
                    return NO;
                }
            }
        }
    }
    
    //Sports
    {
        NSArray *interests = [AppDelegate sharedAppDelegate].currUser[@"SPORTS"];
        BOOL set = NO;
        for (NSNumber *number in interests) { set = set || [number boolValue]; }
        if (set) {
            BOOL set1 = NO;
            NSArray *interests1 = resultUser[@"SPORTS"];
            for (NSNumber *number in interests1) { set1 = set1 || [number boolValue]; }
            if (set1) {
                BOOL result = NO;
                for (int i = 0; i < 48; i++) {
                    NSNumber *num1, *num2;
                    num1 = [interests objectAtIndex:i];
                    num2 = [interests1 objectAtIndex:i];
                    if (([num1 boolValue] == [num2 boolValue]) && [num1 boolValue] && [num2 boolValue]) {
                        result = YES;
                        break;
                    }
                }
                
                if (result == NO) {
                    return NO;
                }
            }
        }
    }

    //film
    {
        NSArray *interests = [AppDelegate sharedAppDelegate].currUser[@"FILMS"];
        BOOL set = NO;
        for (NSNumber *number in interests) { set = set || [number boolValue]; }
        if (set) {
            BOOL set1 = NO;
            NSArray *interests1 = resultUser[@"FILMS"];
            for (NSNumber *number in interests1) { set1 = set1 || [number boolValue]; }
            if (set1) {
                BOOL result = NO;
                for (int i = 0; i < 25; i++) {
                    NSNumber *num1, *num2;
                    num1 = [interests objectAtIndex:i];
                    num2 = [interests1 objectAtIndex:i];
                    if (([num1 boolValue] == [num2 boolValue]) && [num1 boolValue] && [num2 boolValue]) {
                        result = YES;
                        break;
                    }
                }
                
                if (result == NO) {
                    return NO;
                }
            }
        }
    }

    //music
    {
        NSArray *interests = [AppDelegate sharedAppDelegate].currUser[@"MUSIC"];
        BOOL set = NO;
        for (NSNumber *number in interests) { set = set || [number boolValue]; }
        if (set) {
            BOOL set1 = NO;
            NSArray *interests1 = resultUser[@"MUSIC"];
            for (NSNumber *number in interests1) { set1 = set1 || [number boolValue]; }
            if (set1) {
                BOOL result = NO;
                for (int i = 0; i < 31; i++) {
                    NSNumber *num1, *num2;
                    num1 = [interests objectAtIndex:i];
                    num2 = [interests1 objectAtIndex:i];
                    if (([num1 boolValue] == [num2 boolValue]) && [num1 boolValue] && [num2 boolValue]) {
                        result = YES;
                        break;
                    }
                }
                
                if (result == NO) {
                    return NO;
                }
            }
        }
    }

    //Personality
    NSArray *personality = myFilter[@"Personality"];
    BOOL set1 = NO;
    for (NSNumber *number in personality) { set1 = set1 || [number boolValue]; }
    if (set1) {
        NSNumber *real = [personality objectAtIndex:[meInfo[@"Personality"] intValue]];
        if ([real boolValue] == NO) {return NO;}
    }

    NSArray *hobby = myMeInfo[@"Hobby"];
    BOOL set = NO;
    for (NSNumber *number in hobby) { set = set || [number boolValue]; }
    if (set) {
        BOOL set1 = NO;
        NSArray *hobby1 = meInfo[@"Hobby"];
        for (NSNumber *number in hobby1) { set1 = set1 || [number boolValue]; }
        if (set1) {
            BOOL result = NO;
            for (int i = 0; i < 9; i++) {
                NSNumber *num1, *num2;
                num1 = [hobby objectAtIndex:i];
                num2 = [hobby1 objectAtIndex:i];
                if (([num1 boolValue] == [num2 boolValue]) && [num1 boolValue] && [num2 boolValue]) {
                    result = YES;
                }
            }
            
            return result;
        }
    }
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"ProfileCell";
    
    NSMutableDictionary *dict = [self.friends objectAtIndex:indexPath.row];
    
    //Configure Cell
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell.backView == nil) {
        [cell customizeCell];
    }
    
    cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    cell.dict = dict;
    cell.delegate = self;
    cell.nameLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:13];
    cell.distLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:9];
    cell.likeView.hidden = ![dict[@"LIKE"] boolValue];
    cell.dislikeView.hidden = ![dict[@"DISLIKE"] boolValue];

    PFUser *user = dict[@"USERINFO"];
    
    cell.profileImgView.image = nil;
    if ([user[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
        NSString *key = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", user.username];
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
            UIImage *image = [UIImage imageWithData:data];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    cell.profileImgView.image = image;
                    cell.profileImgView.layer.cornerRadius = roundf(cell.profileImgView.frame.size.width/2.0);
                    cell.profileImgView.layer.masksToBounds = YES;
                }
            });
            [cell setNeedsLayout];
        });
    }
    else {
        UIImage *image = nil;
        NSData *imgData = user[@"Photo"];
        if (imgData != nil) {
            image = [[UIImage imageWithData:imgData] imageByScalingProportionallyToSize:CGSizeMake(80, 80)];
        }
        else {
            image = [[UIImage imageNamed:@"tmpFullPic.png"] imageByScalingProportionallyToSize:CGSizeMake(80, 80)];
        }
        cell.profileImgView.image = image;
        cell.profileImgView.layer.cornerRadius = roundf(cell.profileImgView.frame.size.width/2.0);
        cell.profileImgView.layer.masksToBounds = YES;
    }
    
    [[cell.matchView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    PFObject *meInfo = user[@"MeInfo"];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@, %d", [user[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], [meInfo[@"MyAge"] intValue]];

    PFGeoPoint *pos = user[@"Position"];
    PFGeoPoint *pos1 = [AppDelegate sharedAppDelegate].currUser[@"Position"];
    cell.distLabel.text = [NSString stringWithFormat:@"%d Miles Away", (int)[pos1 distanceInMilesTo:pos]];

    NSArray *hoppy1 =  meInfo[@"Hobby"];
    PFObject *myMeInfo = [AppDelegate sharedAppDelegate].currUser[@"MeInfo"];
    NSArray *hoppy2 = myMeInfo[@"Hobby"];
    NSMutableArray *comms = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        if (comms.count >= 4) { break; }
        if ([[hoppy1 objectAtIndex:i] boolValue] && [[hoppy2 objectAtIndex:i] boolValue]) {
            [comms addObject:[NSNumber numberWithInt:i]];
        }
    }
    UIView *accessView = [[UIView alloc] initWithFrame:CGRectMake(120-30*comms.count, 0, 30*comms.count, 25)];
    for (int i = 0; i < comms.count; i++) {
        NSNumber *num = [comms objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(30*i, 0, 25, 25)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iconMatch%d.png", [num intValue]]];
        [accessView addSubview:imgView];
    }
    [cell.matchView addSubview:accessView];
    
    return cell;

}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isSearching) {
        return;
    }

    NSMutableDictionary *dict = [self.friends objectAtIndex:indexPath.row];
    PFUser *user = dict[@"USERINFO"];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OthersViewController *othersView = [board instantiateViewControllerWithIdentifier:@"OthersView"];
    othersView.userInfo = user;
    othersView.delegate = self;
    othersView.indexPath = indexPath;
    [self.navigationController pushViewController:othersView animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"Dragging Ended: %f", scrollView.contentOffset.y);
	if (scrollView.contentOffset.y < -60) {
        [self showLoadingView];
        currentPage = 0;
        self.friends = [NSMutableArray array];
        [self.myTableView reloadData];
        [self performSelector:@selector(searchFriends) withObject:nil afterDelay:0.2];
 	}
    else {
        if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height+50 && scrollView.contentOffset.y > 0) {
            if (isMore) {
                [self showLoadingView];
                currentPage++;
                [self performSelector:@selector(searchFriends) withObject:nil afterDelay:0.2];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > -60) {
        self.searchLabel.text = @"Pull down to search friends";
        self.searchLabel.textColor = [UIColor lightGrayColor];
    }
    else {
        self.searchLabel.text = @"Release to search friends";
        self.searchLabel.textColor = [UIColor colorWithRed:140.0/255.0 green:196.0/255.0 blue:42.0/255.0 alpha:1.0];
    }
}
@end
