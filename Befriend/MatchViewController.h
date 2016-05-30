//
//  MatchViewController.h
//  Befriend
//
//  Created by JinMeng on 1/18/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/PFFacebookUtils.h>

@interface MatchViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *profilePicView;
@property (nonatomic, weak) IBOutlet UILabel *friendLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lookforLabel;

@property (nonatomic, strong) PFUser *userInfo;

@end
