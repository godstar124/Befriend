//
//  AboutMeViewController.m
//  Befriend
//
//  Created by JinMeng on 2/18/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "AboutMeViewController.h"

@interface AboutMeViewController () {
    int remain;
}

@end

@implementation AboutMeViewController

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
    titleLabel.text = @"About Me";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.aboutMeTextView.placeholder = @"Please write about your self";
    [self.aboutMeTextView becomeFirstResponder];
    self.aboutMeTextView.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:16];
    PFObject *meInfo = [AppDelegate sharedAppDelegate].currUser[@"MeInfo"];
    self.aboutMeTextView.text = meInfo[@"About"];

    remain = 2500 - self.aboutMeTextView.text.length;
    self.remainLabel.text = [NSString stringWithFormat:@"%d characters remaining", remain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBack
{
    PFObject *meInfo = [AppDelegate sharedAppDelegate].currUser[@"MeInfo"];
    meInfo[@"About"] = self.aboutMeTextView.text;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
//        [textView resignFirstResponder];
        return YES;
    }else{
        if (text.length == 0) {
            return YES;
        }
        
        if (remain <= 0) {
            return NO;
        }
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    remain = 2500 - textView.text.length;
    self.remainLabel.text = [NSString stringWithFormat:@"%d characters remaining", remain];
}

@end
