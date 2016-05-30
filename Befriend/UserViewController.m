//
//  UserViewController.m
//  Befriend
//
//  Created by JinMeng on 12/12/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "UserViewController.h"
#import "MeViewController.h"
#import "PictureCell.h"
#import "NameCell.h"
#import "AboutCell.h"
#import "UIPlaceHolderTextView.h"

@interface UserViewController () {
    NSArray *personalityNames;
    NSString *lookFor;
    NSString *aboutStr;
}

@property (nonatomic, strong) UIImageView *profileView;
@property (nonatomic, strong) UIImage *profilePic;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *topLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toplogo.png"]];
    self.navigationItem.titleView = topLogo;
    
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [menuBtn setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(clickMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [button setImage:[UIImage imageNamed:@"itemEdit.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;

    personalityNames = [NSArray arrayWithObjects:@"Adventurous", @"Care Free", @"Confident", @"Easy going", @"Energetic", @"Funny", @"Generous", @"Helpful", @"Quiet", @"Reserved", @"Shy", @"Spontaneous", @"Sensitive", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickMenu
{
    UIView *menuView = [AppDelegate sharedAppDelegate].menuView.view;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect frame = menuView.frame;
    frame.origin.x = -100;
    menuView.frame = frame;
    [UIView commitAnimations];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickEdit
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MeViewController *meView = [board instantiateViewControllerWithIdentifier:@"MeView"];
    meView.isFromMenu = YES;
    [self.navigationController pushViewController:meView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    PFObject *meInfo = self.userInfo[@"MeInfo"];
    [meInfo fetchIfNeeded];
    NSArray *hoppy1 =  meInfo[@"Hobby"];

    //Generate string
    lookFor = [NSString string];
    NSArray *namesArray = [NSArray arrayWithObjects:@"Sports", @"Clubbing", @"General", @"Gaming", @"Wingman", @"Shopping", @"Cinema", @"Gigs", @"Playdate", nil];
    for (int i = 0; i < hoppy1.count; i++) {
        NSNumber *value = [hoppy1 objectAtIndex:i];
        
        if ([value boolValue]) {
            if (lookFor.length > 0) {
                lookFor = [NSString stringWithFormat:@"%@, %@", lookFor, [namesArray objectAtIndex:i]];
            }
            else {
                lookFor = [NSString stringWithFormat:@"I’m looking for friends for %@", [namesArray objectAtIndex:i]];
            }
        }
    }
    if (lookFor.length > 0) {
        lookFor = [NSString stringWithFormat:@"%@", lookFor];
        
        NSArray *comps = [lookFor componentsSeparatedByString:@", "];
        if (comps.count > 1) {
            NSMutableArray *newComps = [NSMutableArray arrayWithArray:comps];
            [newComps removeLastObject];
            NSString *a = [newComps componentsJoinedByString:@", "];
            lookFor = [NSString stringWithFormat:@"%@ and %@", a, [comps lastObject]];
        }
    }
    
    NSString *him;
    if ([meInfo[@"Gender"] intValue] == 0) { him = @"he"; }
    else { him = @"she"; }
    int personality = [meInfo[@"Personality"] intValue];
    
    if (lookFor.length > 0) {
        lookFor = [NSString stringWithFormat:@"%@ says %@ is %@ and is %@", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], him, [personalityNames objectAtIndex:personality], [lookFor stringByReplacingOccurrencesOfString:@"I’m " withString:@""]];
    }
    else {
        lookFor = [NSString stringWithFormat:@"%@ says %@ is %@", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], him, [personalityNames objectAtIndex:personality]];
    }

    aboutStr = meInfo[@"About"];

    if (self.profilePic == nil) {
        if ([AppDelegate sharedAppDelegate].profilePic) {
            self.profilePic = [AppDelegate sharedAppDelegate].profilePic;
        }
        else {
            if ([meInfo[@"Gender"] intValue] == 0) { self.profilePic = [UIImage imageNamed:@"male.png"]; }
            else { self.profilePic = [UIImage imageNamed:@"female.png"]; }
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.myTableView reloadData];
}

- (IBAction)uploadPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"From Library", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *meInfo = self.userInfo[@"MeInfo"];
    [meInfo fetchIfNeeded];

    if (indexPath.row == 0) {
        NSString *CellIdentifier = @"PictureCell";
        PictureCell *pictureCell;
        
        pictureCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        pictureCell.accountPicture.contentMode = UIViewContentModeScaleAspectFill;
        pictureCell.accountPicture.layer.masksToBounds = YES;
        pictureCell.accountPicture.image = self.profilePic;
        
//        pictureCell.uploadBtn.hidden = ([self.userInfo[@"fullName"] rangeOfString:@"_local"].location == NSNotFound);
        
        self.profileView = pictureCell.accountPicture;
        
        return pictureCell;
    }

    if (indexPath.row == 1) {
        NSString *CellIdentifier = @"NameCell";
        NameCell *nameCell;
        nameCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        nameCell.nameLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:21];
        nameCell.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        nameCell.distLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:9];
        nameCell.distLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        nameCell.statusLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:9];
        nameCell.statusLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];

        nameCell.nameLabel.text = [NSString stringWithFormat:@"%@, %d", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""], [meInfo[@"MyAge"] intValue]];

        nameCell.distLabel.hidden = YES;
        nameCell.statusLabel.hidden = YES;
        
        return nameCell;
    }
    if (indexPath.row == 2) {
        NSString *CellIdentifier = @"SummaryCell";
        UITableViewCell *summaryCell;
        
        summaryCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIView *child = [summaryCell.contentView viewWithTag:101];
        [child removeFromSuperview];
        
        CGSize sz = [lookFor boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, sz.height)];
        label.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
        label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        label.numberOfLines = 0;
        label.text = lookFor;
        label.tag = 101;
        [summaryCell.contentView addSubview:label];

        return summaryCell;
    }
    
    if (indexPath.row == 3) {
        NSString *CellIdentifier = @"AboutCell";
        AboutCell *aboutCell;
        
        aboutCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        aboutCell.aboutLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:15];
        aboutCell.aboutLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        aboutCell.aboutLabel.text = [NSString stringWithFormat:@"About %@", [self.userInfo[@"fullName"] stringByReplacingOccurrencesOfString:@"_local" withString:@""]];
        
        [[aboutCell.contentView viewWithTag:101] removeFromSuperview];
        NSString *string = meInfo[@"About"];
        if (string.length > 0) {
            CGSize sz = [string boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;

            UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 30, 300, sz.height+10)];
            textView.tag = 101;
            textView.editable = NO;
            textView.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
            textView.backgroundColor = [UIColor clearColor];
            textView.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            textView.text = string;
            textView.scrollEnabled = NO;
            
            [aboutCell.contentView addSubview:textView];
        }
        else {
            CGSize sz = [@" " boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
            
            UIPlaceHolderTextView *textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 30, 300, sz.height+10)];
            textView.tag = 101;
            textView.editable = NO;
            textView.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
            textView.backgroundColor = [UIColor clearColor];
            textView.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            textView.placeholder = @"No summary";
            textView.scrollEnabled = NO;

            [aboutCell.contentView addSubview:textView];
        }
        
        return aboutCell;
    }
    
    return nil;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 320;
    }
    if (indexPath.row == 1) {
        return 44;
    }
    if (indexPath.row == 2) {
        CGSize sz = [lookFor boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
        return sz.height;
    }
    if (indexPath.row == 3) {
        NSString *string;
        if ([aboutStr length] == 0) {
            string = @" ";
        }
        CGSize sz = [string boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;
        return sz.height+30+10;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        self.profileView.frame = CGRectMake(0, scrollView.contentOffset.y, 320, 320-scrollView.contentOffset.y);
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't open camera on your phone." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
        case 1:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't open photo album on your phone." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *origImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.userInfo[@"Photo"] = UIImageJPEGRepresentation(origImage, 0.5);

    self.profilePic = origImage;
    [self.myTableView reloadData];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
