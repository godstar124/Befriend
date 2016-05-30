//
//  MenuViewController.h
//  Befriend
//
//  Created by JinMeng on 1/16/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchProtocol <NSObject>

- (void)searchFriends;
- (void)seletedFilter;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, retain) id <SearchProtocol> delegate;

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@end
