//
//  UniversityViewController.h
//  Befriend
//
//  Created by JinMeng on 1/28/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UniversityDelegate <NSObject>
- (void)didSelectUniversity:(int)index;
@end

@interface UniversityViewController : UIViewController {
    NSArray *universities;
}

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) id <UniversityDelegate> delegate;

@end
