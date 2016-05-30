//
//  InterestViewController.h
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/PFFacebookUtils.h>

@interface HobbyViewController : UIViewController {
    NSArray *namesArray;
    NSArray *iconsArray;
}

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) PFObject *meInfo;

@end
