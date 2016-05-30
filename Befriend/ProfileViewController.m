//
//  ProfileViewController.m
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "MatchViewController.h"
#import "MeViewController.h"
#import "UIImage-Extensions.h"

@interface ProfileViewController () {
    NSArray *personalityNames;
}

@property (nonatomic, strong) UILabel *textView;

@end

@implementation ProfileViewController

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
    UIImageView *topLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toplogo.png"]];
    self.navigationItem.titleView = topLogo;

    if (self.isViewMe) {
        UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        [menuBtn setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(clickMenu) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        self.navigationItem.leftBarButtonItem = leftItem;

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button setImage:[UIImage imageNamed:@"itemEdit.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    else {
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
        [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.leftBarButtonItem = leftItem;
    }

    self.nameLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:21];
    self.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.distLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:9];
    self.distLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.statusLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:9];
    self.statusLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.lookforLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
    self.lookforLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.aboutLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];
    self.aboutLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.betweenLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];
    self.betweenLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    
    personalityNames = [NSArray arrayWithObjects:@"Adventurous", @"Care Free", @"Confident", @"Easy going", @"Energetic", @"Funny", @"Generous", @"Helpful", @"Quiet", @"Reserved", @"Shy", @"Spontaneous", @"Sensitive", nil];

    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated
{
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

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickEdit
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeViewController *meView = [board instantiateViewControllerWithIdentifier:@"MeView"];
    meView.isFromMenu = YES;
    [self.navigationController pushViewController:meView animated:YES];
}

- (void)configureView
{
    if (self.isViewMe || self.isViewProfile) {
        for (UIView *child in [self.myScrollView subviews]) {
            if ([child superview] != self.myScrollView) {continue;}
            CGRect frame = child.frame;
            if (frame.origin.y == 0) { continue; }
            frame.origin.y -= 45;
            child.frame = frame;
        }
        self.acceptBtn.hidden = YES;
        self.declineBtn.hidden = YES;
        if (!self.isViewProfile) {
            self.bottomView.hidden = YES;
        }
    }
    
    //Show Macth Icons
    PFObject *meInfo = self.userInfo[@"MeInfo"];
    [meInfo fetchIfNeeded];
    NSArray *hoppy1 =  meInfo[@"Hobby"];
    PFObject *myMeInfo = [AppDelegate sharedAppDelegate].currUser[@"MeInfo"];
    NSArray *hoppy2 = myMeInfo[@"Hobby"];
    NSMutableArray *comms = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        if ([[hoppy1 objectAtIndex:i] boolValue] && [[hoppy2 objectAtIndex:i] boolValue]) {
            [comms addObject:[NSNumber numberWithInt:i]];
        }
    }

    for (int i = 0; i < comms.count; i++) {
        NSNumber *num = [comms objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(59*(i%5), (i/5)*51+27, 41, 41)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"iconMatch%d.png", [num intValue]]];
        [self.bottomView addSubview:imgView];
    }

    PFGeoPoint *pos = self.userInfo[@"Position"];
    PFGeoPoint *pos1 = [AppDelegate sharedAppDelegate].currUser[@"Position"];
    self.distLabel.text = [NSString stringWithFormat:@"%.1f Miles Away", [pos1 distanceInMilesTo:pos]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %d", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], [meInfo[@"MyAge"] intValue]];
    self.aboutLabel.text = [NSString stringWithFormat:@"About %@", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];
    self.betweenLabel.text = [NSString stringWithFormat:@"You and %@'s matches", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];
    if ([self.userInfo[@"Status"] boolValue]) {
        self.statusLabel.text = @"Online";
    }
    else {
        self.statusLabel.text = @"Offline";
    }
    
    NSString *lookFor = [NSString string];
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
    self.lookforLabel.text = lookFor;
    
    NSString *string = meInfo[@"About"];
    
    CGSize sz;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        sz = [string boundingRectWithSize:CGSizeMake(294.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:9]} context:nil].size;
    }
    else {
        sz = [string sizeWithFont:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14] constrainedToSize:CGSizeMake(294.0f, CGFLOAT_MAX)];
    }
    
    float rH = 405;
    if (self.isViewMe || self.isViewProfile) {rH = 360;}
    
    if (self.textView) {
        [self.textView removeFromSuperview];
    }
    self.textView = [[UILabel alloc] initWithFrame:CGRectMake(13, rH, 294, sz.height+50)];
    self.textView.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.textView.text = string;
    self.textView.numberOfLines = 0;
    self.textView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = self.bottomView.frame;
    frame.origin.y = rH+sz.height+50;
    if (comms.count <= 5) { frame.size.height -= 41; }
    if (comms.count == 0) { frame.size.height = 27; }
    if (self.isViewMe) {frame.size.height = 0;}
    self.bottomView.frame = frame;
    
    CGFloat contentHeight = rH+sz.height+50+frame.size.height+20;
    
    [self.myScrollView addSubview:self.textView];
    
    if ([self.userInfo[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
        NSString *key = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=640", self.userInfo.username];
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    CGFloat height = image.size.height / (image.size.width / 320);
                    self.profilePicView.frame = CGRectMake(0, 0, 320, height);
                    self.profilePicView.image = [image imageByScalingProportionallyToMinimumSize:CGSizeMake(640, height*2)];
                    CGFloat delta = height-213;
                    for (UIView *child in [self.myScrollView subviews]) {
                        if ([child superview] != self.myScrollView) {continue;}
                        CGRect frame = child.frame;
                        if (frame.origin.y == 0) { continue; }
                        frame.origin.y += delta;
                        child.frame = frame;
                    }
                    
                    [self.myScrollView setContentSize:CGSizeMake(320, contentHeight+delta)];
                }
            });
        });
    }
    else {
        UIImage *image = nil;
        NSData *imgData = self.userInfo[@"Photo"];
        if (imgData != nil) {
            image = [UIImage imageWithData:imgData];
        }
        else {
            image = [UIImage imageNamed:@"tmpFullPic.png"];
        }
        
        CGFloat height = image.size.height / (image.size.width / 320);
        
        self.profilePicView.frame = CGRectMake(0, 0, 320, height);
        self.profilePicView.image = [image imageByScalingProportionallyToMinimumSize:CGSizeMake(640, height*2)];
        CGFloat delta = height-213;
        for (UIView *child in [self.myScrollView subviews]) {
            if ([child superview] != self.myScrollView) {continue;}
            CGRect frame = child.frame;
            if (frame.origin.y == 0) { continue; }
            frame.origin.y += delta;
            child.frame = frame;
        }
        
        if (self.isViewMe) {
            UIButton *uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, (height-30)/2, 100, 30)];
            uploadBtn.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3];
            [uploadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [uploadBtn setTitle:@"Upload" forState:UIControlStateNormal];
            [uploadBtn addTarget:self action:@selector(uploadPhoto) forControlEvents:UIControlEventTouchUpInside];
            [self.myScrollView addSubview:uploadBtn];
        }

        [self.myScrollView setContentSize:CGSizeMake(320, contentHeight+delta)];
    }
}

- (IBAction)clickLike:(id)sender
{
    [self.delegate acceptFriend:self.indexPath];
}

- (IBAction)clickDislike:(id)sender
{
    [self.delegate declineFriend:self.indexPath];
}

- (void)uploadPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"From Library", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't open camera on your phone." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
        case 1:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't open photo album on your phone." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *origImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.userInfo[@"Photo"] = UIImageJPEGRepresentation(origImage, 0.5);
    
    CGFloat height = origImage.size.height / (origImage.size.width / 320);
    CGRect frame = self.profilePicView.frame;
    self.profilePicView.frame = CGRectMake(0, 0, 320, height);
    self.profilePicView.image = [origImage imageByScalingProportionallyToMinimumSize:CGSizeMake(640, height*2)];
    CGFloat delta = height-frame.size.height;
    for (UIView *child in [self.myScrollView subviews]) {
        if ([child superview] != self.myScrollView) {continue;}
        CGRect frame = child.frame;
        if (frame.origin.y == 0) { continue; }
        frame.origin.y += delta;
        child.frame = frame;
    }
    
    CGFloat contentHeight = self.myScrollView.contentSize.height + delta;
    [self.myScrollView setContentSize:CGSizeMake(320, contentHeight)];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
