//
//  ChatViewController.h
//  Befriend
//
//  Created by JinMeng on 1/21/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableView.h"
#import <Parse/PFFacebookUtils.h>

#define MAX_ENTRIES_LOADED 25

@interface ChatViewController : UIViewController <UIBubbleTableViewDataSource, BubbleScrollDelegate>

@property (nonatomic, weak) IBOutlet UIBubbleTableView *bubbleTable;
@property (nonatomic, weak) IBOutlet UIView *textInputView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIView *infoView;

@property (nonatomic, strong) NSMutableArray *bubbleData;

@property (nonatomic, strong) PFUser *userInfo;
@property (nonatomic, strong) UIImage *profilePic;
@property (nonatomic, strong) NSTimer *loadTimer;
@end
