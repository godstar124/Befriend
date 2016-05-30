//
//  MeViewController.h
//  Befriend
//
//  Created by JinMeng on 1/15/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/PFFacebookUtils.h>
#import "UniversityViewController.h"

@interface MeViewController : UIViewController <UniversityDelegate> {
    NSArray *nationalities;
    NSArray *personalities;
    NSArray *religions;
    NSArray *intelligence;
    NSArray *universities;
}

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@property (nonatomic, weak) IBOutlet UIView *pickerContainer;
@property (nonatomic, weak) IBOutlet UIPickerView *myAgePicker;
@property (nonatomic, weak) IBOutlet UIPickerView *nationPicker;
@property (nonatomic, weak) IBOutlet UIPickerView *religionPicker;
@property (nonatomic, weak) IBOutlet UIPickerView *personalityPicker;
@property (nonatomic, weak) IBOutlet UIPickerView *childrenPicker;
@property (nonatomic, weak) IBOutlet UIPickerView *intelligencePicker;

@property (nonatomic, assign) BOOL isFromMenu;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFObject *meInfo;

- (IBAction)clickGendreSegment:(id)sender;
- (IBAction)clickMoneyToBurnSlider:(id)sender;

@end
