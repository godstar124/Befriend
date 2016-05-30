//
//  MeViewController.m
//  Befriend
//
//  Created by JinMeng on 1/15/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import "MeViewController.h"
#import "GendreCell.h"
#import "MoneyCell.h"
#import "NetworkCell.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "HobbyViewController.h"
#import "InterestViewController.h"
#import "SportsViewController.h"
#import "FilmsViewController.h"
#import "MusicViewController.h"
#import "GeneralCell.h"
#import "ProfileViewController.h"
#import "UserViewController.h"

@interface MeViewController ()

@end

@implementation MeViewController
@synthesize meInfo, user;

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

	// Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
    titleLabel.text = @"Me";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;

    if (!self.isFromMenu) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [button setImage:[UIImage imageNamed:@"itemDone.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickDone) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
    }

    if (!self.isFromMenu) {
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [button1 setImage:[UIImage imageNamed:@"itemMusicB.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else {
        UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
        [menuBtn setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        self.navigationItem.leftBarButtonItem = leftItem;
    }

    self.user = [AppDelegate sharedAppDelegate].currUser;
    
    meInfo = user[@"MeInfo"];
    
    NSString *temp = @"UK,USA,Australia,South African,French,German,Chinese,Indian,Afghan,Albanian,Algerian,American,Andorran,Angolan,Antiguans,Argentinean,Armenian,Austrian,Azerbaijani,Bahamian,Bahraini,Bangladeshi,Barbadian,Barbudans,Batswana,Belarusian,Belgian,Belizean,Beninese,Bhutanese,Bolivian,Bosnian,Brazilian,British,Bruneian,Bulgarian,Burkinabe,Burmese,Burundian,Cambodian,Cameroonian,Canadian,Cape Verdean,Central African,Chadian,Chilean,Colombian,Comoran,Congolese,Congolese,Costa Rican,Croatian,Cuban,Cypriot,Czech,Danish,Djibouti,Dominican,Dominican,Dutch,Dutchman,Dutchwoman,East Timorese,Ecuadorean,Egyptian,Emirian,Equatorial Guinean,Eritrean,Estonian,Ethiopian,Fijian,Filipino,Finnish,Gabonese,Gambian,Georgian,Ghanaian,Greek,Grenadian,Guatemalan,Guinea-Bissauan,Guinean,Guyanese,Haitian,Herzegovinian,Honduran,Hungarian,I-Kiribati,Icelander,Indonesian,Iranian,Iraqi,Irish,Irish,Israeli,Italian,Ivorian,Jamaican,Japanese,Jordanian,Kazakhstani,Kenyan,Kittian and Nevisian,Kuwaiti,Kyrgyz,Laotian,Latvian,Lebanese,Liberian,Libyan,Liechtensteiner,Lithuanian,Luxembourger,Macedonian,Malagasy,Malawian,Malaysian,Maldivan,Malian,Maltese,Marshallese,Mauritanian,Mauritian,Mexican,Micronesian,Moldovan,Monacan,Mongolian,Moroccan,Mosotho,Motswana,Mozambican,Namibian,Nauruan,Nepalese,Netherlander,New Zealander,Ni-Vanuatu,Nicaraguan,Nigerian,Nigerien,North Korean,Northern Irish,Norwegian,Omani,Pakistani,Palauan,Panamanian,Papua New Guinean,Paraguayan,Peruvian,Polish,Portuguese,Qatari,Romanian,Russian,Rwandan,Saint Lucian,Salvadoran,Samoan,San Marinese,Sao Tomean,Saudi,Scottish,Senegalese,Serbian,Seychellois,Sierra Leonean,Singaporean,Slovakian,Slovenian,Solomon Islander,Somali,South Korean,Spanish,Sri Lankan,Sudanese,Surinamer,Swazi,Swedish,Swiss,Syrian,Taiwanese,Tajik,Tanzanian,Thai,Togolese,Tongan,Trinidadian,Tunisian,Turkish,Tuvaluan,Ugandan,Ukrainian,Uruguayan,Uzbekistani,Venezuelan,Vietnamese,Welsh,Welsh,Yemenite,Zambian,Zimbabwean";
    nationalities = [temp componentsSeparatedByString:@","];
    
    personalities = [NSArray arrayWithObjects:@"Adventurous", @"Care Free", @"Confident", @"Easy going", @"Energetic", @"Funny", @"Generous", @"Helpful", @"Quiet", @"Reserved", @"Shy", @"Spontaneous", @"Sensitive", nil];
    
    religions = [NSArray arrayWithObjects:@"Christian", @"Islamic", @"Secular", @"Nonreligious", @"Agnostic", @"Atheist", @"Hindu", @"Buddhist", @"Sikhi", @"Jewish", nil];
    
    intelligence = [NSArray arrayWithObjects:@"Below Average", @"Average", @"Above Average", @"High", nil];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"university" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *rawString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    universities = [rawString componentsSeparatedByString:@"\r\n"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    user[@"MeInfo"] = meInfo;
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

- (void)clickDone
{
    UIImage *image;
    if ([user[@"fullName"] rangeOfString:@"_local"].location == NSNotFound) {
        NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=640", user.username];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        image = [UIImage imageWithData:data];
        [AppDelegate sharedAppDelegate].profilePic = image;
        [[AppDelegate sharedAppDelegate].menuView.myTableView reloadData];
    }
    else {
        NSData *imgData = user[@"Photo"];
        if (imgData != nil) {
            image = [UIImage imageWithData:imgData];
        }
        else {
            image = [UIImage imageNamed:@"tmpFullPic.png"];
        }
        [AppDelegate sharedAppDelegate].profilePic = image;
        [[AppDelegate sharedAppDelegate].menuView.myTableView reloadData];
    }

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navi = [board instantiateViewControllerWithIdentifier:@"HomeNavi"];
    MainViewController *mainView = (MainViewController*)[navi topViewController];
    mainView.image = image;
    [AppDelegate sharedAppDelegate].window.rootViewController = navi;
}

- (void)clickBack
{
    UINavigationController *navi = (UINavigationController*)[AppDelegate sharedAppDelegate].window.rootViewController;
    [navi popToRootViewControllerAnimated:NO];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserViewController *userView = [board instantiateViewControllerWithIdentifier:@"UserView"];
    userView.userInfo = [AppDelegate sharedAppDelegate].currUser;
    
    [navi pushViewController:userView animated:NO];
}

- (IBAction)clickGendreSegment:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    
    meInfo[@"Gender"] = [NSNumber numberWithInt:segment.selectedSegmentIndex];
}

- (IBAction)clickMoneyToBurnSlider:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    
    meInfo[@"MoneyToBurn"] = [NSNumber numberWithInt:(int)slider.value];
    [self.myTableView reloadData];
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

- (IBAction)clickUniversity:(id)sender
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UniversityViewController *universityView = (UniversityViewController*)[board instantiateViewControllerWithIdentifier:@"UniversityView"];
    universityView.delegate = self;
    [self.navigationController pushViewController:universityView animated:YES];
}

- (IBAction)clickEmployer:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please input Employer Name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *field = [alertView textFieldAtIndex:0];
    meInfo[@"Employer"] = field.text;
    [self.myTableView reloadData];
}

#pragma mark - University Delegate
- (void)didSelectUniversity:(int)index
{
    meInfo[@"University"] = [NSNumber numberWithInt:index];
    [self.myTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        NSString *CellIdentifier = @"GendreCell";
        
        //Configure Cell
        GendreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.iamLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.iamLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        if (meInfo.isDataAvailable) {
            int gender = [meInfo[@"Gender"] integerValue];
            [cell.gendreSegment setSelectedSegmentIndex:gender];
        }
        return cell;
    }
    else if (indexPath.row == 5) {
        NSString *CellIdentifier = @"MoneyCell";
        
        //Configure Cell
        MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.moneyLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.burnLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:17];
        if (meInfo.isDataAvailable) {
            cell.burnSlider.value = [meInfo[@"MoneyToBurn"] intValue];
            if ([meInfo[@"MoneyToBurn"] intValue] > 1000) {
                cell.burnLabel.text = [NSString stringWithFormat:@"£1000+"];
            }
            else {
                cell.burnLabel.text = [NSString stringWithFormat:@"£%d", [meInfo[@"MoneyToBurn"] intValue]];
            }
        }
        
        return cell;
    }
    else if (indexPath.row == 6) {
        NSString *CellIdentifier = @"NetworkCell";
        
        //Configure Cell
        NetworkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.network.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.university.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
        cell.employer.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
        
        cell.nameOfEmployer.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:14];
        cell.nameOfUniversity.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:14];
        if (meInfo.isDataAvailable) {
            cell.nameOfUniversity.text = [[[[universities objectAtIndex:[meInfo[@"University"] intValue]] componentsSeparatedByString:@","] lastObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            cell.nameOfEmployer.text = meInfo[@"Employer"];
        }
        
        return cell;
    }
    else {
        NSString *CellIdentifier = @"GeneralCell";
        
        //Configure Cell
        GeneralCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.mainLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.subLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:17];
        
        switch (indexPath.row) {
            case 0:
                cell.mainLabel.text = @"I'd like a friend for...";
                cell.subLabel.text = @"";
                break;
            case 2:
                cell.mainLabel.text = @"My Age";
                if (meInfo.isDataAvailable) {
                    cell.subLabel.text = [NSString stringWithFormat:@"%d", [meInfo[@"MyAge"] intValue]];
                }
                break;
            case 3:
                cell.mainLabel.text = @"Personality";
                if (meInfo.isDataAvailable) {
                    cell.subLabel.text = [personalities objectAtIndex:[meInfo[@"Personality"] intValue]];
                }
                break;
            case 4:
                cell.mainLabel.text = @"Children";
                if (meInfo.isDataAvailable) {
                    cell.subLabel.text = [NSString stringWithFormat:@"%d", [meInfo[@"Children"] intValue]];
                }
                break;
            case 7:
                cell.mainLabel.text = @"Interests";
                cell.subLabel.text = @"";
                break;
            case 8:
                cell.mainLabel.text = @"Sports";
                cell.subLabel.text = @"";
                break;
            case 9:
                cell.mainLabel.text = @"Films";
                cell.subLabel.text = @"";
                break;
            case 10:
                cell.mainLabel.text = @"Music";
                cell.subLabel.text = @"";
                break;
            case 11:
                cell.mainLabel.text = @"About Me";
                cell.subLabel.text = @"";
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 || indexPath.row == 5) {
        return 100;
    }
    if (indexPath.row == 6) {
        return 142;
    }
    
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HobbyViewController *hobbyView = (HobbyViewController*)[board instantiateViewControllerWithIdentifier:@"HobbyView"];
        hobbyView.meInfo = meInfo;
        [self.navigationController pushViewController:hobbyView animated:YES];
    }
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row > 6 ) {
        self.myAgePicker.hidden = self.nationPicker.hidden = self.religionPicker.hidden = self.personalityPicker.hidden = self.childrenPicker.hidden = self.intelligencePicker.hidden = YES;
        
        if (indexPath.row <= 6) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            CGRect frame = self.pickerContainer.frame;
            frame.origin.y = self.view.frame.size.height-frame.size.height;
            self.pickerContainer.frame = frame;
            [UIView commitAnimations];
        }
        
        switch (indexPath.row) {
            case 2:
                self.myAgePicker.hidden = NO;
                break;
            case 3:
                self.personalityPicker.hidden = NO;
                break;
            case 4:
                self.childrenPicker.hidden = NO;
                break;
            case 7:
            {
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                InterestViewController *interestView = (InterestViewController*)[board instantiateViewControllerWithIdentifier:@"InterestView"];
                interestView.isNotFirst = YES;
                [self.navigationController pushViewController:interestView animated:YES];
                break;
            }
            case 8:
            {
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SportsViewController *sportsView = (SportsViewController*)[board instantiateViewControllerWithIdentifier:@"SportsView"];
                sportsView.isNotFirst = YES;
                [self.navigationController pushViewController:sportsView animated:YES];
                break;
            }
            case 9:
            {
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FilmsViewController *filmsView = (FilmsViewController*)[board instantiateViewControllerWithIdentifier:@"FilmView"];
                filmsView.isNotFirst = YES;
                [self.navigationController pushViewController:filmsView animated:YES];
                break;
            }
            case 10:
            {
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                MusicViewController *musicView = (MusicViewController*)[board instantiateViewControllerWithIdentifier:@"MusicView"];
                musicView.isNotFirst = YES;
                [self.navigationController pushViewController:musicView animated:YES];
                break;
            }
            case 11:
            {
                [self performSegueWithIdentifier:@"ShowAboutMe" sender:nil];
                break;
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.myAgePicker) {
        return 23;
    }
    if (pickerView == self.nationPicker) {
        return nationalities.count;
    }
    if (pickerView == self.personalityPicker) {
        return personalities.count;
    }
    if (pickerView == self.religionPicker) {
        return religions.count;
    }
    if (pickerView == self.childrenPicker) {
        return 11;
    }
    if (pickerView == self.intelligencePicker) {
        return intelligence.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *result;
    
    if (pickerView == self.myAgePicker) {
        if (row < 22) {
            result = [NSString stringWithFormat:@"%d years",row+18];
        }
        else {
            result = [NSString stringWithFormat:@"40+ years"];
        }
    }
    if (pickerView == self.nationPicker) {
        result = [nationalities objectAtIndex:row];
    }
    if (pickerView == self.personalityPicker) {
        result = [personalities objectAtIndex:row];
    }
    if (pickerView == self.religionPicker) {
        result = [religions objectAtIndex:row];
    }
    if (pickerView == self.childrenPicker) {
        result = [NSString stringWithFormat:@"%d", row];
    }
    if (pickerView == self.intelligencePicker) {
        result = [intelligence objectAtIndex:row];
    }
    return result;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.myAgePicker) {
        meInfo[@"MyAge"] = [NSNumber numberWithInt:row+18];
    }
    if (pickerView == self.nationPicker) {
        meInfo[@"Nationality"] = [NSNumber numberWithInt:row];
    }
    if (pickerView == self.religionPicker) {
        meInfo[@"Religion"] = [NSNumber numberWithInt:row];
    }
    if (pickerView == self.personalityPicker) {
        meInfo[@"Personality"] = [NSNumber numberWithInt:row];
    }
    if (pickerView == self.childrenPicker) {
        meInfo[@"Children"] = [NSNumber numberWithInt:row];
    }
    if (pickerView == self.intelligencePicker) {
        meInfo[@"Intelligence"] = [NSNumber numberWithInt:row];
    }
    
    [self.myTableView reloadData];
}
@end
