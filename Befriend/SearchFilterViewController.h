//
//  SearchFilterViewController.h
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import <Parse/PFFacebookUtils.h>

@interface SearchFilterViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) id <SearchProtocol> delegate;
@property (nonatomic, strong) PFObject *filter;

@end
