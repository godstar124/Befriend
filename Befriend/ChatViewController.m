//
//  ChatViewController.m
//  Befriend
//
//  Created by JinMeng on 1/21/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "UIImage-Extensions.h"
#import "ProfileViewController.h"
#import "OthersViewController.h"

@interface ChatViewController () {
    BOOL isLoading;
    int nMessageCount;
    int skip;
    int indexPoint;
    BOOL isEmpty;
    BOOL isMore;
    int skipmore;
}

@end

@implementation ChatViewController

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
    titleLabel.text = [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [button setImage:[UIImage imageNamed:@"iconInfo.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.bubbleData = [NSMutableArray array];
    self.bubbleTable.bubbleDataSource = self;
    self.bubbleTable.scrollDelegate = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    self.bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    self.bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    self.bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    // Keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    indexPoint = -1;
    [self loadLocalChat];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loadLocalChat) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.loadTimer) {
        [self.loadTimer invalidate];
    }
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickInfo
{
    CGRect frame = self.infoView.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if (frame.origin.y == 0) {
        frame.origin.y = -64;
    }
    else {
        frame.origin.y = 0;
    }
    self.infoView.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)clickViewProfile:(id)sender
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OthersViewController *othersView = [board instantiateViewControllerWithIdentifier:@"OthersView"];
    othersView.userInfo = self.userInfo;
    othersView.isViewProfile = YES;
    [self.navigationController pushViewController:othersView animated:YES];
}

- (IBAction)clickReport:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"The report has been logged and will be investigated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (IBAction)clickBlock:(id)sender
{
    NSMutableArray *friends = [NSMutableArray arrayWithArray:[AppDelegate sharedAppDelegate].currUser[@"Friends"]];
    for (NSString *friendName in friends) {
        if ([friendName isEqualToString:self.userInfo.username]) {
            [friends removeObject:friendName];
        }
    }
    
    [AppDelegate sharedAppDelegate].currUser[@"Friends"] = friends;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[AppDelegate sharedAppDelegate].currUser[@"Enemy"]];
    BOOL isFound = NO;
    for (NSString *element in array) {
        if ([[[element componentsSeparatedByString:@"$$$"] firstObject] isEqualToString:self.userInfo.username]) {
            isFound = YES;
        }
    }
    if (!isFound) {
        NSString *res = [NSString stringWithFormat:@"%@$$$%d", self.userInfo.username, (int)([[NSDate date] timeIntervalSince1970])];
        [array addObject:res];
    }
    
    [AppDelegate sharedAppDelegate].currUser[@"Enemy"] = array;

    [self.navigationController popToRootViewControllerAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:nil message:@"Successfully removed this friend." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Parse
- (void)loadMoreChat
{
    isMore = YES;
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query orderByDescending:@"createdAt"];
    
    if (indexPoint == 0) {
        return;
    }
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            nMessageCount = number;
            skipmore = nMessageCount - indexPoint;
            [self loadMoreQuery];
        }
        else {
            isMore = NO;
            [self.loadTimer invalidate];
            self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loadLocalChat) userInfo:nil repeats:YES];
        }
    }];
}

- (void)loadMoreQuery;
{
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query.limit = MAX_ENTRIES_LOADED;
    query.skip = skipmore;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count == 0 || !isMore) {
                [self.bubbleTable reloadData];
                isMore = NO;
                [self.loadTimer invalidate];
                self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loadLocalChat) userInfo:nil repeats:YES];
                return;
            }
            
            skipmore += objects.count;
            NSLog(@"%d - %d", skipmore, objects.count);
            
            NSString *myname = [AppDelegate sharedAppDelegate].currUser.username;

            int addedCount = 0;
            for (int i = 0; i < objects.count; i++) {
                PFObject *message = [objects objectAtIndex:i];
                if (!([message[@"sender"] isEqualToString:myname] && [message[@"receiver"] isEqualToString:self.userInfo.username])
                    && !([message[@"receiver"] isEqualToString:myname] && [message[@"sender"] isEqualToString:self.userInfo.username])) {
                    continue;
                }
                
                addedCount++;
                if ([message[@"sender"] isEqualToString:myname]) {
                    NSDate *date = [message createdAt];
                    NSBubbleData *msgBubble = [NSBubbleData dataWithText:message[@"text"] date:date type:BubbleTypeMine];
                    msgBubble.avatar = [[AppDelegate sharedAppDelegate].profilePic imageByScalingProportionallyToMinimumSize:CGSizeMake(80, 80)];
                    msgBubble.oid = message.objectId;
                    [self.bubbleData insertObject:msgBubble atIndex:0];
                }
                else {
                    NSDate *date = [message createdAt];
                    NSBubbleData *msgBubble = [NSBubbleData dataWithText:message[@"text"] date:date type:BubbleTypeSomeoneElse];
                    msgBubble.avatar = self.profilePic;
                    msgBubble.oid = message.objectId;
                    [self.bubbleData insertObject:msgBubble atIndex:0];
                }
            }
            
            if (addedCount == 0) {
                [self loadMoreQuery];
            }
            else {
                indexPoint =  nMessageCount - skipmore;
                [self.bubbleTable reloadData];
                isMore = NO;
                [self.loadTimer invalidate];
                self.loadTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(loadLocalChat) userInfo:nil repeats:YES];
            }
        }
    }];
}

- (void)loadLocalChat
{
    if (isLoading) { return; }
    
    isLoading = YES;
    
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query orderByDescending:@"createdAt"];

    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            nMessageCount = number;
            skip = 0;
            [self loadQuery];
        }
        else {isLoading = NO;}
    }];
}

- (void)loadQuery;
{
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    query.limit = MAX_ENTRIES_LOADED;
    query.skip = skip;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if (objects.count == 0) {
                BOOL isEnd = NO;
                CGPoint offset = self.bubbleTable.contentOffset;
                if ((self.bubbleTable.contentSize.height - self.bubbleTable.frame.size.height - offset.y) < 50) {isEnd = YES;}
                [self.bubbleTable reloadData];
                if (isEnd == YES) {
                    CGFloat offset = (self.bubbleTable.contentSize.height - self.bubbleTable.frame.size.height);
                    if (offset > 0) {
                        [self.bubbleTable setContentOffset:CGPointMake(0, offset)];
                    }
                }
                isEmpty = YES;
                isLoading = NO;
                return;
            }
            
            skip += objects.count;
            // The find succeeded.
            NSLog(@"Successfully retrieved %d chats from cache.", objects.count);
            
            NSString *myname = [AppDelegate sharedAppDelegate].currUser.username;
            int start = objects.count;
            NSBubbleData *lastBubble = [self.bubbleData lastObject];
            if (lastBubble) {
                for (start = 0; start < objects.count; start++) {
                    PFObject *message = [objects objectAtIndex:start];
                    if ([message.objectId isEqualToString:lastBubble.oid])
                        break;
                }
            }
            
            for (int i = start-1; i >= 0; i--) {
                PFObject *message = [objects objectAtIndex:i];
                if (!([message[@"sender"] isEqualToString:myname] && [message[@"receiver"] isEqualToString:self.userInfo.username])
                    && !([message[@"receiver"] isEqualToString:myname] && [message[@"sender"] isEqualToString:self.userInfo.username])) {
                    continue;
                }
                
                if ([message[@"sender"] isEqualToString:myname]) {
                    NSDate *date = [message createdAt];
                    NSBubbleData *msgBubble = [NSBubbleData dataWithText:message[@"text"] date:date type:BubbleTypeMine];
                    msgBubble.avatar = [[AppDelegate sharedAppDelegate].profilePic imageByScalingProportionallyToMinimumSize:CGSizeMake(80, 80)];
                    msgBubble.oid = message.objectId;
                    [self.bubbleData addObject:msgBubble];
                }
                else {
                    NSDate *date = [message createdAt];
                    NSBubbleData *msgBubble = [NSBubbleData dataWithText:message[@"text"] date:date type:BubbleTypeSomeoneElse];
                    msgBubble.avatar = self.profilePic;
                    msgBubble.oid = message.objectId;
                    [self.bubbleData addObject:msgBubble];
                }
            }
            
            if (self.bubbleData.count == 0 && isEmpty == NO) {
                [self loadQuery];
            }
            else {
                if (self.bubbleData.count != 0) {
                    isEmpty = NO;
                    
                    if (indexPoint == -1) { indexPoint =  nMessageCount - skip; }
                    if (start != 0) {
                        BOOL isEnd = NO;
                        CGPoint offset = self.bubbleTable.contentOffset;
                        if ((self.bubbleTable.contentSize.height - self.bubbleTable.frame.size.height - offset.y) < 50) {isEnd = YES;}
                        [self.bubbleTable reloadData];
                        if (isEnd == YES) {
                            CGFloat offset = (self.bubbleTable.contentSize.height - self.bubbleTable.frame.size.height);
                            if (offset > 0) {
                                [self.bubbleTable setContentOffset:CGPointMake(0, offset)];
                            }
                        }
                    }
                }
                
                isLoading = NO;
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            isLoading = NO;
        }
    }];
}

#pragma mark - Actions
- (IBAction)sayPressed:(id)sender
{
    if (self.textField.text.length <= 0) { return; }
    
    self.bubbleTable.typingBubble = NSBubbleTypingTypeMe;
    [self.bubbleTable reloadData];
    CGFloat offset = (self.bubbleTable.contentSize.height - self.bubbleTable.frame.size.height);
    if (offset > 0)
        [self.bubbleTable setContentOffset:CGPointMake(0, offset)];
    
    PFObject *newMessage = [PFObject objectWithClassName:@"ChatRoom"];
    [newMessage setObject:self.textField.text forKey:@"text"];
    [newMessage setObject:self.userInfo.username forKey:@"receiver"];
    [newMessage setObject:[AppDelegate sharedAppDelegate].currUser.username forKey:@"sender"];
    [newMessage setObject:[NSDate date] forKey:@"date"];
    [newMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
        [self loadLocalChat];
    }];

    if ([self.userInfo[@"Status"] boolValue] == NO) {
        NSString *msg = [NSString stringWithFormat:@"%@ sent you message \"%@\"", [[AppDelegate sharedAppDelegate].currUser[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], self.textField.text];
        // Create our Installation query
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:[NSString stringWithFormat:@"CH_%@", self.userInfo.username]];

        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              msg, @"alert",
                              @"Increment", @"badge",
                              nil];

        [push setData:data];
        [push expireAfterTimeInterval:86400];
        [push sendPushInBackground];
    }
    
    self.textField.text = @"";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [self.bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [self.bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.textInputView.frame;
        frame.origin.y -= kbSize.height;
        self.textInputView.frame = frame;
        
        frame = self.bubbleTable.frame;
        frame.size.height -= kbSize.height;
        self.bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = self.textInputView.frame;
        frame.origin.y += kbSize.height;
        self.textInputView.frame = frame;
        
        frame = self.bubbleTable.frame;
        frame.size.height += kbSize.height;
        self.bubbleTable.frame = frame;
    }];
}

#pragma mark - BubbleScrollDelegate
- (void)didScrollToTop
{
    if (isMore) {
        return;
    }
    
    [self.loadTimer invalidate];
    [self loadMoreChat];
}

@end
