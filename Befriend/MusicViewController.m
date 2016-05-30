//
//  InterestViewController.m
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//
#import "AppDelegate.h"
#import "MusicViewController.h"
#import "CollectCell.h"
#import <Parse/PFFacebookUtils.h>

@interface MusicViewController ()

@end

@implementation MusicViewController

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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:17];
    titleLabel.text = @"Music";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    
    if (!self.isNotFirst) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [button setImage:[UIImage imageNamed:@"itemMe.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickMe) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = rightItem;
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
        [button1 setImage:[UIImage imageNamed:@"itemFilmB.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    else {
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
        [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.leftBarButtonItem = leftItem;
    }

    namesArray = [NSArray arrayWithObjects:@"Pop", @"Rock", @"R&B", @"Dance & DJ", @"Soul", @"Classical", @"Blues", @"Jazz", @"Country", @"Soundtrack", @"Hard Rock", @"Rap", @"Electronic", @"Techno", @"World Music", @"Indie", @"Hip-Hop", @"Trip-Hop", @"Latino", @"Opera", @"Folk", @"Gospel", @"Reggae", @"Funk", @"Disco", @"House", @"Ambient", @"Punk", @"Metal", @"Alternative", @"I don’t like Music", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    selectionArray = [AppDelegate sharedAppDelegate].currUser[@"MUSIC"];
    if (selectionArray == nil) {
        selectionArray = [NSMutableArray array];
        for (int i = 0; i < namesArray.count; i++) { [selectionArray addObject:[NSNumber numberWithBool:NO]]; }
    }
    
    [self.myTableView reloadData];
}

- (void)clickMe
{
    [AppDelegate sharedAppDelegate].currUser[@"MUSIC"] = selectionArray;
    [self performSegueWithIdentifier:@"ShowMePage" sender:nil];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSkip:(id)sender
{
    if (self.isNotFirst) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self performSegueWithIdentifier:@"ShowMePage" sender:nil];
    }
}

- (IBAction)clickCheck:(id)sender
{
    if (self.isNotFirst) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [AppDelegate sharedAppDelegate].currUser[@"MUSIC"] = selectionArray;
        [self performSegueWithIdentifier:@"ShowMePage" sender:nil];
    }
}

- (IBAction)clickCell:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    if (tag >= namesArray.count) return;
    
    NSNumber *number = [selectionArray objectAtIndex:tag];
    [selectionArray removeObjectAtIndex:tag];
    
    if ([number boolValue]) {
        [selectionArray insertObject:[NSNumber numberWithBool:NO] atIndex:tag];
    }
    else {
        [selectionArray insertObject:[NSNumber numberWithBool:YES] atIndex:tag];
    }

    UIView *parentView = [button superview];
    UIImageView *selectView = (UIImageView*)[parentView viewWithTag:101];
    selectView.hidden = [number boolValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int rowCount;
    rowCount = (int)namesArray.count / 3;
    rowCount++;
    if (namesArray.count % 3 != 0) {
        rowCount++;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"CollectCell";
    
    
    //Configure Cell
    CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.firstBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    cell.firstBtn.layer.borderWidth = 0.25;
    cell.secondBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    cell.secondBtn.layer.borderWidth = 0.25;
    cell.thirdBtn.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    cell.thirdBtn.layer.borderWidth = 0.25;
    cell.firstBtn.tag = indexPath.row * 3;
    cell.secondBtn.tag = indexPath.row * 3 + 1;
    cell.thirdBtn.tag = indexPath.row * 3 + 2;
    
    cell.firstLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:9];
    cell.secondLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:9];
    cell.thirdLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:9];

    cell.firstLabel.text = @"";
    cell.secondLabel.text = @"";
    cell.thirdLabel.text = @"";
    
    cell.firstIconView.image = nil;
    cell.secondIconView.image = nil;
    cell.thirdIconView.image = nil;
    
    cell.firstSelectView.hidden = cell.secondSelectView.hidden = cell.thirdSelectView.hidden = YES;
    
    int realIndex = (int)indexPath.row * 3;
    if (realIndex < namesArray.count) {
        cell.firstLabel.text = [namesArray objectAtIndex:realIndex];
        cell.firstIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"m%d.png", realIndex]];
        if ([[selectionArray objectAtIndex:realIndex] boolValue] == YES) { cell.firstSelectView.hidden = NO; }
    }
    realIndex++;
    if (realIndex < namesArray.count) {
        cell.secondLabel.text = [namesArray objectAtIndex:realIndex];
        cell.secondIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"m%d.png", realIndex]];
        if ([[selectionArray objectAtIndex:realIndex] boolValue] == YES) { cell.secondSelectView.hidden = NO; }
    }
    realIndex++;
    if (realIndex < namesArray.count) {
        cell.thirdLabel.text = [namesArray objectAtIndex:realIndex];
        cell.thirdIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"m%d.png", realIndex]];
        if ([[selectionArray objectAtIndex:realIndex] boolValue] == YES) { cell.thirdSelectView.hidden = NO; }
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
