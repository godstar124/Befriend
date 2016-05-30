//
//  MatchViewController.m
//  Befriend
//
//  Created by JinMeng on 1/18/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import "MatchViewController.h"
#import "ChatViewController.h"
#import "UIImage-Extensions.h"

@interface MatchViewController ()

@end

@implementation MatchViewController

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

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.nameLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:24];
    self.nameLabel.textColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.lookforLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];
    self.lookforLabel.textColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    self.friendLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:24];
    self.friendLabel.textColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    if ([self.userInfo[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
        NSString *key = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=640", self.userInfo.username];
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    self.profilePicView.image = image;
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
        self.profilePicView.image = image;
    }

    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.height/2;
    self.profilePicView.layer.borderWidth = 4;
    self.profilePicView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePicView.layer.masksToBounds = YES;

    PFObject *meInfo = self.userInfo[@"MeInfo"];
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %d", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], [meInfo[@"MyAge"] intValue]];

    NSArray *hobby = meInfo[@"Hobby"];
    NSString *lookFor = [NSString string];
    NSArray *namesArray = [NSArray arrayWithObjects:@"Sports", @"Clubbing", @"General", @"Gaming", @"Wingman", @"Shopping", @"Cinema", @"Gigs", @"Playdate", nil];
    for (int i = 0; i < hobby.count; i++) {
        NSNumber *value = [hobby objectAtIndex:i];
        
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
    self.lookforLabel.text = lookFor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickChat:(id)sender
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController *chatView = [board instantiateViewControllerWithIdentifier:@"ChatView"];
    chatView.userInfo = self.userInfo;
    chatView.profilePic = [self.profilePicView.image imageByScalingProportionallyToMinimumSize:CGSizeMake(80, 80)];
    [self.navigationController pushViewController:chatView animated:YES];
}

@end
