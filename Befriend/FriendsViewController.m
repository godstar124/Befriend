//
//  FriendsViewController.m
//  Befriend
//
//  Created by JinMeng on 1/18/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "FriendsViewController.h"
#import "FriendCell.h"
#import "ChatViewController.h"
#import "ProfileViewController.h"
#import "MatchViewController.h"
#import "OthersViewController.h"

@interface FriendsViewController () {
}

@property (nonatomic, strong) NSMutableArray *requestArray;
@property (nonatomic, strong) NSMutableArray *sentRequests;

@end

@implementation FriendsViewController

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
    titleLabel.text = @"Friends";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;

    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [menuBtn setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(clickMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, -30, 202, 20)];
    self.refreshLabel.text = @"Pull down to refresh";
    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0f];
    self.refreshLabel.textColor = [UIColor lightGrayColor];
    self.refreshLabel.backgroundColor = [UIColor clearColor];
    [self.myTableView addSubview:self.refreshLabel];

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Loading...";
    self.hud.animationType = MBProgressHUDAnimationFade;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    [self performSelector:@selector(loadFriends) withObject:nil afterDelay:0.2];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFriends
{
    NSMutableArray *friends = [NSMutableArray array];
    
    PFQuery *queryRequest = [PFQuery queryWithClassName:@"Requests"];
    [queryRequest whereKey:@"Resolve" containedIn:[NSArray arrayWithObjects:[NSNumber numberWithBool:NO], nil]];
    self.requestArray = [NSMutableArray array];
    self.sentRequests = [NSMutableArray array];
    self.friendList = [NSMutableArray array];
    
    NSArray *temp = [NSMutableArray arrayWithArray:[queryRequest findObjects]];
    for (PFObject *element in temp) {
        if ([element[@"Sender"] isEqualToString:[AppDelegate sharedAppDelegate].currUser.username])
        {
            [self.sentRequests addObject:element[@"Receiver"]];
        }
             
        if (![element[@"Receiver"] isEqualToString:[AppDelegate sharedAppDelegate].currUser.username])
            continue;
        
        [self.requestArray addObject:element];

        PFQuery *query = [PFUser query];
        [query whereKey:@"username" containedIn:@[element[@"Sender"]]];
        [self.friendList addObject:[[query findObjects] firstObject]];
    }
    
    [friends addObjectsFromArray:[AppDelegate sharedAppDelegate].currUser[@"Friends"]];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containedIn:friends];
    [self.friendList addObjectsFromArray:[query findObjects]];
    for (PFUser *friend in self.friendList) {
        [friend fetchIfNeeded];
    }
    
    [self.hud hide:YES];
    [self.myTableView reloadData];
}

#pragma mark - ProfileCellDelegate
- (void)acceptFriend:(NSIndexPath *)indexPath
{
    PFUser *user = [self.friendList objectAtIndex:indexPath.row];

    PFObject *element = [self.requestArray objectAtIndex:indexPath.row];
    element[@"Resolve"] = [NSNumber numberWithBool:YES];
    [element saveInBackground];
    [self.requestArray removeObject:element];
    
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
    
    [self.friendList removeObjectAtIndex:indexPath.row];
    [self.myTableView reloadData];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MatchViewController *matchView = (MatchViewController*)[board instantiateViewControllerWithIdentifier:@"MatchView"];
    matchView.userInfo = user;
    [[AppDelegate sharedAppDelegate] showViewController:matchView];
    
    //Send push notification
    NSString *msg = [NSString stringWithFormat:@"%@ accepted your friend request.", [[AppDelegate sharedAppDelegate].currUser[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];
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

- (void)declineFriend:(NSIndexPath *)indexPath
{
    PFUser *user = [self.friendList objectAtIndex:indexPath.row];
    
    PFObject *element = [self.requestArray objectAtIndex:indexPath.row];
    element[@"Resolve"] = [NSNumber numberWithBool:YES];
    [element saveInBackground];
    [self.requestArray removeObject:element];

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
    
    [self.friendList removeObjectAtIndex:indexPath.row];
    [self.myTableView reloadData];
    
    UINavigationController *navi = (UINavigationController*)[AppDelegate sharedAppDelegate].window.rootViewController;
    [navi popViewControllerAnimated:YES];

    //Send push notification
    NSString *msg = [NSString stringWithFormat:@"%@ declined your friend request.", [[AppDelegate sharedAppDelegate].currUser[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"FriendCell";
    
    PFUser *friend = [self.friendList objectAtIndex:indexPath.row];
    
    //Configure Cell
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.nameLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:13];
    cell.nameLabel.text = [friend[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""];
    cell.dateLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:9];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    cell.dateLabel.text = [formatter stringFromDate:[NSDate date]];
    if (indexPath.row < self.requestArray.count) {
        cell.exclaimationView.hidden = NO;
    }
    else {
        cell.exclaimationView.hidden = YES;
    }
    
    if ([friend[@"Status"] boolValue]) {
        cell.nameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        cell.dateLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
        cell.dateLabel.text = @"Online";
    }
    else {
        cell.nameLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        cell.dateLabel.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0];
        cell.dateLabel.text = @"Offline";
    }

    BOOL isSent = NO;
    for (NSString *name in self.sentRequests) {
        if ([friend[@"username"] isEqualToString:name]) {
            isSent = YES;
            break;
        }
    }
    if (isSent) {
        cell.exclaimationView.hidden = NO;
        cell.exclaimationView.image = [UIImage imageNamed:@"iconQuestion.png"];
    }
    
    cell.pictureView.image = nil;
    
    UIImage *image;
    NSData *imgData = friend[@"Photo"];
    if (imgData != nil) {
        image = [UIImage imageWithData:imgData];
        cell.pictureView.image = image;
    }
    else {
        if ([friend[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
            NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", friend.username];
            dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
            dispatch_async(downloadQueue, ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        cell.pictureView.image = image;
                    }
                    else {
                        cell.pictureView.image = [UIImage imageNamed:@"tmpProfile.png"];
                    }
                    cell.pictureView.layer.cornerRadius = 20;
                    cell.pictureView.layer.masksToBounds = YES;
                });
                [cell setNeedsLayout];
            });
        }
        else {
            image = [UIImage imageNamed:@"tmpFullPic.png"];
            cell.pictureView.image = image;
        }

        cell.pictureView.layer.cornerRadius = 20;
        cell.pictureView.layer.masksToBounds = YES;
    }

    return cell;
    
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.requestArray.count) {
        PFUser *friend = [self.friendList objectAtIndex:indexPath.row];
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OthersViewController *othersView = [board instantiateViewControllerWithIdentifier:@"OthersView"];
        othersView.userInfo = friend;
        othersView.delegate = self;
        othersView.indexPath = indexPath;
        [self.navigationController pushViewController:othersView animated:YES];
    }
    else {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChatViewController *chatView = [board instantiateViewControllerWithIdentifier:@"ChatView"];
        chatView.userInfo = [self.friendList objectAtIndex:indexPath.row];
        
        PFUser *friend = [self.friendList objectAtIndex:indexPath.row];
        if ([friend[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
            NSString *key = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", friend.username];
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            UIImage * image = [UIImage imageWithData:data];
            chatView.profilePic = image;
        }
        else {
            UIImage *image = nil;
            NSData *imgData = friend[@"Photo"];
            if (imgData != nil) {
                image = [UIImage imageWithData:imgData];
            }
            else {
                image = [UIImage imageNamed:@"tmpFullPic.png"];
            }
            chatView.profilePic = image;
        }
        
        [self.navigationController pushViewController:chatView animated:YES];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *friend = [self.friendList objectAtIndex:indexPath.row];
    NSMutableArray *friends = [NSMutableArray arrayWithArray:[AppDelegate sharedAppDelegate].currUser[@"Friends"]];
    NSMutableArray *newFriends = [NSMutableArray array];
    for (NSString *friendName in friends) {
        if ([friendName isEqualToString:friend.username]) {
            continue;
        }
        [newFriends addObject:friendName];
    }

    [AppDelegate sharedAppDelegate].currUser[@"Friends"] = newFriends;

    NSMutableArray *array = [NSMutableArray arrayWithArray:[AppDelegate sharedAppDelegate].currUser[@"Enemy"]];
    BOOL isFound = NO;
    for (NSString *element in array) {
        if ([[[element componentsSeparatedByString:@"$$$"] firstObject] isEqualToString:friend.username]) {
            isFound = YES;
        }
    }
    if (!isFound) {
        NSString *res = [NSString stringWithFormat:@"%@$$$%d", friend.username, (int)([[NSDate date] timeIntervalSince1970])];
        [array addObject:res];
    }
    
    [AppDelegate sharedAppDelegate].currUser[@"Enemy"] = array;
    
    if (indexPath.row < self.requestArray.count) {
        [self.requestArray removeObjectAtIndex:indexPath.row];
    }
    [self.friendList removeObjectAtIndex:indexPath.row];
    [self.myTableView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"Dragging Ended: %f", scrollView.contentOffset.y);
	if (scrollView.contentOffset.y < -60) {
        self.friendList = nil;
        [self.myTableView reloadData];
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = @"Loading...";
        self.hud.animationType = MBProgressHUDAnimationFade;
        self.hud.mode = MBProgressHUDModeIndeterminate;
        [self performSelector:@selector(loadFriends) withObject:nil afterDelay:0.2];
 	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > -60) {
        self.refreshLabel.text = @"Pull down to refresh";
        self.refreshLabel.textColor = [UIColor lightGrayColor];
    }
    else {
        self.refreshLabel.text = @"Release to refresh";
        self.refreshLabel.textColor = [UIColor colorWithRed:140.0/255.0 green:196.0/255.0 blue:42.0/255.0 alpha:1.0];
    }
}
@end
