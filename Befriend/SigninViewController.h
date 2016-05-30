//
//  SigninViewController.h
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SigninViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *logoLabel;
@property (nonatomic, weak) IBOutlet UILabel *facebookLabel;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;

@property (nonatomic, strong) MBProgressHUD *hud;

@end
