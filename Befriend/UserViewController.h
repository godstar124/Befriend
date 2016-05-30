//
//  UserViewController.h
//  Befriend
//
//  Created by JinMeng on 12/12/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) PFUser *userInfo;

@end
