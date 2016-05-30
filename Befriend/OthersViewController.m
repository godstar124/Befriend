//
//  UserViewController.m
//  Befriend
//
//  Created by JinMeng on 12/12/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "OthersViewController.h"
#import "MeViewController.h"
#import "PictureCell.h"
#import "NameCell.h"
#import "AboutCell.h"
#import "UIPlaceHolderTextView.h"
#import "BetweenCell.h"

@interface OthersViewController () {
    NSArray *personalityNames;
    NSString *lookFor;
    NSString *aboutStr;
}

@property (nonatomic, strong) UIImageView *profileView;
@property (nonatomic, strong) UIImage *profilePic;
@property (nonatomic, strong) NSMutableArray *comms;

@end

@implementation OthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *topLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toplogo.png"]];
    self.navigationItem.titleView = topLogo;
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    personalityNames = [NSArray arrayWithObjects:@"Adventurous", @"Care Free", @"Confident", @"Easy going", @"Energetic", @"Funny", @"Generous", @"Helpful", @"Quiet", @"Reserved", @"Shy", @"Spontaneous", @"Sensitive", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFObject *meInfo = self.userInfo[@"MeInfo"];
    [meInfo fetchIfNeeded];
    NSArray *hoppy1 =  meInfo[@"Hobby"];
    PFObject *myMeInfo = [AppDelegate sharedAppDelegate].currUser[@"MeInfo"];
    NSArray *hoppy2 = myMeInfo[@"Hobby"];
    
    self.comms = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        if ([[hoppy1 objectAtIndex:i] boolValue] && [[hoppy2 objectAtIndex:i] boolValue]) {
            [self.comms addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    //Generate string
    lookFor = [NSString string];
    NSArray *namesArray = [NSArray arrayWithObjects:@"Sports", @"Clubbing", @"General", @"Gaming", @"Wingman", @"Shopping", @"Cinema", @"Gigs", @"Playdate", nil];
    for (int i = 0; i < hoppy1.count; i++) {
        NSNumber *value = [hoppy1 objectAtIndex:i];
        
        if ([value boolValue]) {
            if (lookFor.length > 0) {
                lookFor = [NSString stringWithFormat:@"%@, %@", lookFor, [namesArray objectAtIndex:i]];
            }
            else {
                lookFor = [NSString stringWithFormat:@"I’m looking for friends for %@", [namesArray objectAtIndex:i]];
            }
        }
    }
    if (lookFor.length > 0) {
        lookFor = [NSString stringWithFormat:@"%@", lookFor];
        
        NSArray *comps = [lookFor componentsSeparatedByString:@", "];
        if (comps.count > 1) {
            NSMutableArray *newComps = [NSMutableArray arrayWithArray:comps];
            [newComps removeLastObject];
            NSString *a = [newComps componentsJoinedByString:@", "];
            lookFor = [NSString stringWithFormat:@"%@ and %@", a, [comps lastObject]];
        }
    }
    
    NSString *him;
    if ([meInfo[@"Gender"] intValue] == 0) { him = @"he"; }
    else { him = @"she"; }
    int personality = [meInfo[@"Personality"] intValue];
    
    if (lookFor.length > 0) {
        lookFor = [NSString stringWithFormat:@"%@ says %@ is %@ and is %@", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], him, [personalityNames objectAtIndex:personality], [lookFor stringByReplacingOccurrencesOfString:@"I’m " withString:@""]];
    }
    else {
        lookFor = [NSString stringWithFormat:@"%@ says %@ is %@", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], him, [personalityNames objectAtIndex:personality]];
    }
    
    aboutStr = meInfo[@"About"];
    
    if (self.profilePic == nil) {
        NSData *imgData = self.userInfo[@"Photo"];
        if (imgData != nil) {
            self.profilePic = [UIImage imageWithData:imgData];
        }
        else {
            if ([meInfo[@"Gender"] intValue] == 0) { self.profilePic = [UIImage imageNamed:@"male.png"]; }
            else { self.profilePic = [UIImage imageNamed:@"female.png"]; }
            
            if ([self.userInfo[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
                NSString *key = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=640", self.userInfo.username];
                dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
                dispatch_async(downloadQueue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image) {
                            self.profilePic = image;
                            [self.myTableView reloadData];
                        }
                    });
                });
            }
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.myTableView reloadData];
}

- (IBAction)clickLike:(id)sender
{
    [self.delegate acceptFriend:self.indexPath];
}

- (IBAction)clickDislike:(id)sender
{
    [self.delegate declineFriend:self.indexPath];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *meInfo = self.userInfo[@"MeInfo"];
    [meInfo fetchIfNeeded];
    
    if (indexPath.row == 0) {
        NSString *CellIdentifier = @"PictureCell";
        PictureCell *pictureCell;
        
        pictureCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        pictureCell.accountPicture.contentMode = UIViewContentModeScaleAspectFill;
        pictureCell.accountPicture.layer.masksToBounds = YES;
        pictureCell.accountPicture.image = self.profilePic;
        
        self.profileView = pictureCell.accountPicture;
        
        return pictureCell;
    }
    
    if (indexPath.row == 1) {
        NSString *CellIdentifier = @"LikeCell";
        UITableViewCell *likeCell;
        
        likeCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        likeCell.clipsToBounds = YES;
        
        return likeCell;
    }
    
    if (indexPath.row == 2) {
        NSString *CellIdentifier = @"NameCell";
        NameCell *nameCell;
        nameCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        nameCell.nameLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:21];
        nameCell.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        nameCell.distLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:9];
        nameCell.distLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        nameCell.statusLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:9];
        nameCell.statusLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        
        nameCell.nameLabel.text = [NSString stringWithFormat:@"%@, %d", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], [meInfo[@"MyAge"] intValue]];
        
        PFGeoPoint *pos = self.userInfo[@"Position"];
        PFGeoPoint *pos1 = [AppDelegate sharedAppDelegate].currUser[@"Position"];
        nameCell.distLabel.text = [NSString stringWithFormat:@"%.1f Miles Away", [pos1 distanceInMilesTo:pos]];
        
        if ([self.userInfo[@"Status"] boolValue]) {
            nameCell.statusLabel.text = @"Online";
        }
        else {
            nameCell.statusLabel.text = @"Offline";
        }
        
        return nameCell;
    }
    if (indexPath.row == 3) {
        NSString *CellIdentifier = @"SummaryCell";
        UITableViewCell *summaryCell;
        
        summaryCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIView *child = [summaryCell.contentView viewWithTag:101];
        [child removeFromSuperview];
        
        CGSize sz = [lookFor boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, sz.height)];
        label.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        label.numberOfLines = 0;
        label.text = lookFor;
        label.tag = 101;
        [summaryCell.contentView addSubview:label];
        
        return summaryCell;
    }
    
    if (indexPath.row == 4) {
        NSString *CellIdentifier = @"AboutCell";
        AboutCell *aboutCell;
        
        aboutCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        aboutCell.aboutLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];
        aboutCell.aboutLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        aboutCell.aboutLabel.text = [NSString stringWithFormat:@"About %@", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];
        
        [[aboutCell.contentView viewWithTag:101] removeFromSuperview];
        NSString *string = meInfo[@"About"];
        if (string.length > 0) {
            CGSize sz = [string boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
            
            UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 30, 300, sz.height+10)];
            textView.tag = 101;
            textView.editable = NO;
            textView.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
            textView.backgroundColor = [UIColor clearColor];
            textView.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            textView.text = string;
            textView.scrollEnabled = NO;
            
            [aboutCell.contentView addSubview:textView];
        }
        else {
            CGSize sz = [@" " boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
            
            UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 30, 300, sz.height+10)];
            textView.tag = 101;
            textView.editable = NO;
            textView.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
            textView.backgroundColor = [UIColor clearColor];
            textView.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            textView.placeholder = @"No summary";
            textView.scrollEnabled = NO;

            [aboutCell.contentView addSubview:textView];
        }
        
        return aboutCell;
    }
    
    if (indexPath.row == 5) {
        NSString *CellIdentifier = @"BetweenCell";
        BetweenCell *betweenCell;
        
        betweenCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        betweenCell.betweenLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];
        betweenCell.betweenLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        betweenCell.betweenLabel.text = [NSString stringWithFormat:@"You and %@'s matches", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];

        [betweenCell.container.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        for (int i = 0; i < self.comms.count; i++) {
            NSNumber *num = [self.comms objectAtIndex:i];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(27+i*51, 0, 41, 41)];
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iconMatch%d.png", [num intValue]]];
            [betweenCell.container addSubview:imgView];
        }
        [betweenCell.container setContentSize:CGSizeMake(27+self.comms.count*51, 44)];

        return betweenCell;
    }

    return nil;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 320;
    }
    if (indexPath.row == 1) {
        if (self.isViewProfile) {
            return 0;
        }
        return 44;
    }
    if (indexPath.row == 2) {
        return 44;
    }
    if (indexPath.row == 3) {
        CGSize sz = [lookFor boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
        return sz.height;
    }
    if (indexPath.row == 4) {
        NSString *string = aboutStr;
        if ([aboutStr length] == 0) {
            string = @" ";
        }
        CGSize sz = [string boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
        return sz.height+30+10;
    }
    if (indexPath.row == 5) {
        return 66;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        self.profileView.frame = CGRectMake(0, scrollView.contentOffset.y, 320, 320-scrollView.contentOffset.y);
    }
}
@end
