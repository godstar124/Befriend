//
//  SignupViewController.h
//  Befriend
//
//  Created by JinMeng on 4/4/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *logoLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UILabel *genderLabel;
@property (nonatomic, weak) IBOutlet UILabel *ageLabel;
@property (nonatomic, weak) IBOutlet UIView *pickerContainer;
@property (nonatomic, weak) IBOutlet UIPickerView *agePicker;
@end
