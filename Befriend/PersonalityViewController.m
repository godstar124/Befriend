//
//  InterestViewController.m
//  Befriend
//
//  Created by JinMeng on 1/14/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import "PersonalityViewController.h"
#import "CollectCell.h"

@interface PersonalityViewController () {
    NSMutableArray *currSelection;
}

@end

@implementation PersonalityViewController

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
    titleLabel.text = @"My Friend's Personality";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;

    namesArray = [NSArray arrayWithObjects:@"Adventurous", @"Care Free", @"Confident", @"Easy going", @"Energetic", @"Funny", @"Generous", @"Helpful", @"Quiet", @"Reserved", @"Shy", @"Spontaneous", @"Sensitive", nil];

    currSelection = [NSMutableArray arrayWithArray:self.filter[@"Personality"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (IBAction)clickSkip:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickCheck:(id)sender
{
    self.filter[@"Personality"] = currSelection;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBack
{
    self.filter[@"Personality"] = currSelection;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickCell:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    if (tag >= namesArray.count) return;
    
    NSNumber *number = [currSelection objectAtIndex:tag];
    [currSelection removeObjectAtIndex:tag];
    
    if ([number boolValue]) {
        [currSelection insertObject:[NSNumber numberWithBool:NO] atIndex:tag];
    }
    else {
        [currSelection insertObject:[NSNumber numberWithBool:YES] atIndex:tag];
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
    cell.contentView.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
    cell.contentView.layer.borderWidth = 0.5;
    
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
        cell.firstIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"per%d.png", realIndex]];
        if ([[currSelection objectAtIndex:realIndex] boolValue] == YES) { cell.firstSelectView.hidden = NO; }
    }
    realIndex++;
    if (realIndex < namesArray.count) {
        cell.secondLabel.text = [namesArray objectAtIndex:realIndex];
        cell.secondIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"per%d.png", realIndex]];
        if ([[currSelection objectAtIndex:realIndex] boolValue] == YES) { cell.secondSelectView.hidden = NO; }
    }
    realIndex++;
    if (realIndex < namesArray.count) {
        cell.thirdLabel.text = [namesArray objectAtIndex:realIndex];
        cell.thirdIconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"per%d.png", realIndex]];
        if ([[currSelection objectAtIndex:realIndex] boolValue] == YES) { cell.thirdSelectView.hidden = NO; }
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
