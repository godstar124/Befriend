//
//  InterestViewController.h
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsViewController : UIViewController {
    NSArray *namesArray;
    NSArray *iconsArray;
    NSMutableArray *selectionArray;
}

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, assign) BOOL isNotFirst;

@end
