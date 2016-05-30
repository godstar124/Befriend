//
//  SignupViewController.m
//  Befriend
//
//  Created by JinMeng on 4/4/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "SignupViewController.h"
#import "MBProgressHUD.h"

@interface SignupViewController () {
    int age;
}

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation SignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.logoLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];

    self.nameField.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:12];
    self.emailField.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:12];
    self.passwordField.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:12];
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0]}];
    self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0]}];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1.0]}];
    self.genderLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:12];
    self.ageLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:12];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDone:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.pickerContainer.frame;
    frame.origin.y = self.view.frame.size.height;
    self.pickerContainer.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)clickAge:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = self.pickerContainer.frame;
    frame.origin.y = self.view.frame.size.height-frame.size.height;
    self.pickerContainer.frame = frame;
    [UIView commitAnimations];
}

- (IBAction)clickGender:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Please select your gender." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Male", @"Female", nil] show];
}

- (IBAction)clickCreate:(id)sender
{
    if (self.nameField.text.length <= 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please input username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if (self.emailField.text.length <= 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please input your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if (self.passwordField.text.length <= 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please create password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if ([self.genderLabel.text isEqualToString:@"Gender"]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select your gender." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if ([self.ageLabel.text isEqualToString:@"Age"]) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please select your age." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Signing up...";
    self.hud.animationType = MBProgressHUDAnimationFade;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    [self createAccountOnParse];
}

- (void)createAccountOnParse {
    PFUser *user = [PFUser user];
    user.username = self.nameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            user[@"fullName"] = [NSString stringWithFormat:@"%@_local", self.nameField.text];
            user[@"Friends"] = [NSArray array];
            user[@"Enemy"] = [NSArray array];
            
            //Create Me info
            PFObject *meInfo = [PFObject objectWithClassName:@"MeClass"];
            if ([self.genderLabel.text isEqualToString:@"Male"]) {
                meInfo[@"Gender"] = [NSNumber numberWithInt:0];
            }
            else {
                meInfo[@"Gender"] = [NSNumber numberWithInt:1];
            }
            meInfo[@"MoneyToBurn"] = [NSNumber numberWithInt:500];
            meInfo[@"MyAge"] = [NSNumber numberWithInt:age];
            meInfo[@"Nationality"] = [NSNumber numberWithInt:0];
            meInfo[@"Religion"] = [NSNumber numberWithInt:0];
            meInfo[@"Personality"] = [NSNumber numberWithInt:0];
            meInfo[@"Children"] = [NSNumber numberWithInt:0];
            meInfo[@"Intelligence"] = [NSNumber numberWithInt:1];
            meInfo[@"University"] = [NSNumber numberWithInt:0];
            meInfo[@"Employer"] = @"";
            meInfo[@"About"] = @"";
            meInfo[@"Parent"] = [NSString stringWithString:user[@"username"]];
            NSMutableArray *selectionArray = [NSMutableArray array];
            for (int i = 0; i < 9; i++) { [selectionArray addObject:[NSNumber numberWithBool:NO]]; }
            meInfo[@"Hobby"] = selectionArray;
            user[@"MeInfo"] = meInfo;
            
            //Create Filter Info
            PFObject *filter = [PFObject objectWithClassName:@"FilterClass"];
            filter[@"Men"] = [NSNumber numberWithBool:YES];
            filter[@"Women"] = [NSNumber numberWithBool:YES];
            filter[@"Within"] = [NSNumber numberWithInt:25];
            filter[@"StartAge"] = [NSNumber numberWithInt:23];
            filter[@"EndAge"] = [NSNumber numberWithInt:38];
            filter[@"StartMoney"] = [NSNumber numberWithInt:200];
            filter[@"EndMoney"] = [NSNumber numberWithInt:600];
            filter[@"Parent"] = [NSString stringWithString:user[@"username"]];
            NSMutableArray *personalityArray = [NSMutableArray array];
            for (int i = 0; i < 13; i++) { [personalityArray addObject:[NSNumber numberWithBool:NO]]; }
            filter[@"Personality"] = personalityArray;
            filter[@"Child"] = [NSNumber numberWithInt:0];
            
            user[@"Filter"] = filter;
            user[@"Status"] = [NSNumber numberWithBool:YES];
            
            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
            [currentInstallation addUniqueObject:[NSString stringWithFormat:@"CH_%@", user.username] forKey:@"channels"];
            [currentInstallation saveInBackground];
            
            [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                user[@"Position"] = geoPoint;
                
                [AppDelegate sharedAppDelegate].currUser = user;
                
                [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"USERNAME"];
                [[NSUserDefaults standardUserDefaults] setObject:user.password forKey:@"PASSWORD"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *mainNavi = (UINavigationController*)[board instantiateViewControllerWithIdentifier:@"MainNavi"];
                [AppDelegate sharedAppDelegate].window.rootViewController = mainNavi;
            }];

        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        [self.hud hide:YES];
    }];
}

#pragma mark - Keyboard events
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGRect frame = self.view.frame;
    frame.origin.y -= kbSize.height;
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 23;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *result;
    if (row < 22) {
        result = [NSString stringWithFormat:@"%d years",row+18];
    }
    else {
        result = [NSString stringWithFormat:@"40+ years"];
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *result;
    if (row < 22) {
        result = [NSString stringWithFormat:@"%d years",row+18];
    }
    else {
        result = [NSString stringWithFormat:@"40+ years"];
    }
    age = row+18;
    self.ageLabel.text = result;
    self.ageLabel.textColor = [UIColor blackColor];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.genderLabel.textColor = [UIColor blackColor];
    if (buttonIndex == 0) {
        self.genderLabel.text = @"Male";
    }
    else {
        self.genderLabel.text = @"Female";
    }
}
@end
