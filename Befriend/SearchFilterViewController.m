//
//  SearchFilterViewController.m
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "SearchFilterViewController.h"
#import "WithinCell.h"
#import "ShowMeCell.h"
#import "AgedCell.h"
#import "RangeSlider.h"
#import "HobbyViewController.h"
#import "MoneyBurnCell.h"
#import "PersonalityViewController.h"
#import "InterestViewController.h"
#import "SportsViewController.h"
#import "FilmsViewController.h"
#import "MusicViewController.h"

@interface SearchFilterViewController ()

@end

@implementation SearchFilterViewController

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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
    titleLabel.text = @"Search Filter";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 44)];
    [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBack
{
    [self.delegate seletedFilter];
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
}

- (void)report:(RangeSlider *)sender {
    self.filter[@"StartAge"] = [NSNumber numberWithInt:(int)(sender.min*23+18)];
    self.filter[@"EndAge"] = [NSNumber numberWithInt:(int)(sender.max*23+18)];
    
    [self.myTableView reloadData];
}

- (void)report1:(RangeSlider *)sender {
    self.filter[@"StartMoney"] = [NSNumber numberWithInt:(int)(sender.min*981+20)];
    self.filter[@"EndMoney"] = [NSNumber numberWithInt:(int)(sender.max*981+20)];
    
    [self.myTableView reloadData];
}

- (IBAction)clickSwitch:(id)sender
{
    UISwitch *control = (UISwitch*)sender;
    
    if (control.tag == 0) {
        self.filter[@"Men"] = [NSNumber numberWithBool:control.on];
    }
    else {
        self.filter[@"Women"] = [NSNumber numberWithBool:control.on];
    }
}

- (IBAction)clickDistSlider:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    self.filter[@"Within"] = [NSNumber numberWithInt:(int)slider.value];
    [self.myTableView reloadData];
}

- (void)clickSegment:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    self.filter[@"Child"] = [NSNumber numberWithInt:segment.selectedSegmentIndex];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        NSString *CellIdentifier = @"ShowMeCell";
        
        //Configure Cell
        ShowMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.showMe.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.men.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
        cell.women.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
        if ([self.filter isDataAvailable]) {
            cell.switchMen.on = [self.filter[@"Men"] boolValue];
            cell.switchWomen.on = [self.filter[@"Women"] boolValue];
        }
        return cell;
    }
    else if (indexPath.row == 2) {
        NSString *CellIdentifier = @"WithinCell";
        
        //Configure Cell
        WithinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.withinLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.distLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:17];
        if ([self.filter isDataAvailable]) {
            cell.distLabel.text = [NSString stringWithFormat:@"%d Miles", [self.filter[@"Within"] intValue]];
            cell.distSlider.value = [self.filter[@"Within"] intValue];
        }
        
        return cell;
    }
    else if (indexPath.row == 3) {
        NSString *CellIdentifier = @"AgedCell";
        
        //Configure Cell
        AgedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.agedLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.rangeLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:17];
        
        if ([cell viewWithTag:101] == nil) {
            RangeSlider *slider = [[RangeSlider alloc] initWithFrame:CGRectMake(13, 53, 297, 34)];
            slider.tag = 101;
            slider.minimumRangeLength = .03;
            
            [slider setMinThumbImage:[UIImage imageNamed:@"r.png"]];
            [slider setMaxThumbImage:[UIImage imageNamed:@"r.png"]];
            [slider setTrackImage:[[UIImage imageNamed:@"full.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)]];
            [slider setInRangeTrackImage:[UIImage imageNamed:@"fill.png"]];
            
            [slider addTarget:self action:@selector(report:) forControlEvents:UIControlEventValueChanged]; // The slider sends actions when the value of the minimum or maximum changes
            
            [cell addSubview:slider];

            if ([self.filter isDataAvailable]) {
                slider.min = ([self.filter[@"StartAge"] intValue] - 18) / 23.0;
                slider.max = ([self.filter[@"EndAge"] intValue] - 18) / 23.0;
            }
        }
        
        
        if ([self.filter isDataAvailable]) {
            if ([self.filter[@"EndAge"] intValue] > 40) {
                cell.rangeLabel.text = [NSString stringWithFormat:@"Between %d and %d+", [self.filter[@"StartAge"] intValue], [self.filter[@"EndAge"] intValue]-1];
            }
            else {
                cell.rangeLabel.text = [NSString stringWithFormat:@"Between %d and %d", [self.filter[@"StartAge"] intValue], [self.filter[@"EndAge"] intValue]];
            }
        }

        return cell;
    }
    else if (indexPath.row == 4) {
        NSString *CellIdentifier = @"MoneyBurnCell";
        
        //Configure Cell
        MoneyBurnCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.moneyLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.rangeLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:17];
        
        if ([cell viewWithTag:101] == nil) {
            RangeSlider *slider = [[RangeSlider alloc] initWithFrame:CGRectMake(13, 53, 297, 34)];
            slider.tag = 101;
            slider.minimumRangeLength = 0.03;
            
            [slider setMinThumbImage:[UIImage imageNamed:@"r.png"]];
            [slider setMaxThumbImage:[UIImage imageNamed:@"r.png"]];
            [slider setTrackImage:[[UIImage imageNamed:@"full.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)]];
            [slider setInRangeTrackImage:[UIImage imageNamed:@"fill.png"]];
            
            [slider addTarget:self action:@selector(report1:) forControlEvents:UIControlEventValueChanged]; // The slider sends actions when the value of the minimum or maximum changes
            
            [cell addSubview:slider];
            
            if ([self.filter isDataAvailable]) {
                slider.min = ([self.filter[@"StartMoney"] intValue] - 20) / 981.0;
                slider.max = ([self.filter[@"EndMoney"] intValue] - 20) / 981.0;
                if ([self.filter[@"EndMoney"] intValue] > 1000) {
                    cell.rangeLabel.text = [NSString stringWithFormat:@"From £%d To £1000+", [self.filter[@"StartMoney"] intValue]];
                }
                else {
                    cell.rangeLabel.text = [NSString stringWithFormat:@"From £%d To £%d", [self.filter[@"StartMoney"] intValue], [self.filter[@"EndMoney"] intValue]];
                }
            }
        }
        
        if ([self.filter isDataAvailable]) {
            if ([self.filter[@"EndMoney"] intValue] > 1000) {
                cell.rangeLabel.text = [NSString stringWithFormat:@"£From %d To £1000+", [self.filter[@"StartMoney"] intValue]];
            }
            else {
                cell.rangeLabel.text = [NSString stringWithFormat:@"From £%d To £%d", [self.filter[@"StartMoney"] intValue], [self.filter[@"EndMoney"] intValue]];
            }
        }

        return cell;
    }
    else {
        NSString *CellIdentifier = @"GeneralCell";
        
        //Configure Cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:17];
        cell.accessoryView = nil;
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"I'd like a friend for...";
                break;
            case 5:
                cell.textLabel.text = @"Personality";
                break;
            case 6:
            {
                cell.textLabel.text = @"Has children";
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"N/A", @"Yes", @"No", nil]];
                segmentedControl.tintColor = [UIColor colorWithRed:237/255.0 green:138/255.0 blue:0.0 alpha:1.0];
                segmentedControl.selectedSegmentIndex = [self.filter[@"Child"] intValue];
                [segmentedControl addTarget:self action:@selector(clickSegment:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = segmentedControl;
                
                break;
            }
            case 7:
                cell.textLabel.text = @"Interests";
                break;
            case 8:
                cell.textLabel.text = @"Sports";
                break;
            case 9:
                cell.textLabel.text = @"Films";
                break;
            case 10:
                cell.textLabel.text = @"Music";
                break;
        }
        
        return cell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        return 100;
    }
    if (indexPath.row == 1) {
        return 142;
    }
    
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HobbyViewController *hobbyView = (HobbyViewController*)[board instantiateViewControllerWithIdentifier:@"HobbyView"];
        hobbyView.meInfo = [AppDelegate sharedAppDelegate].currUser[@"MeInfo"];
        [self.navigationController pushViewController:hobbyView animated:YES];
    }
    
    if (indexPath.row == 5) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PersonalityViewController *personalityView = [board instantiateViewControllerWithIdentifier:@"PersonalityView"];
        personalityView.filter = self.filter;
        [self.navigationController pushViewController:personalityView animated:YES];
    }

    if (indexPath.row == 7)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InterestViewController *interestView = (InterestViewController*)[board instantiateViewControllerWithIdentifier:@"InterestView"];
        interestView.isNotFirst = YES;
        [self.navigationController pushViewController:interestView animated:YES];
    }
    if (indexPath.row == 8)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SportsViewController *sportsView = (SportsViewController*)[board instantiateViewControllerWithIdentifier:@"SportsView"];
        sportsView.isNotFirst = YES;
        [self.navigationController pushViewController:sportsView animated:YES];
    }
    if (indexPath.row == 9)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FilmsViewController *filmsView = (FilmsViewController*)[board instantiateViewControllerWithIdentifier:@"FilmView"];
        filmsView.isNotFirst = YES;
        [self.navigationController pushViewController:filmsView animated:YES];
    }
    if (indexPath.row == 10)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MusicViewController *musicView = (MusicViewController*)[board instantiateViewControllerWithIdentifier:@"MusicView"];
        musicView.isNotFirst = YES;
        [self.navigationController pushViewController:musicView animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
