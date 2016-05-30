//
//  UniversityViewController.m
//  Befriend
//
//  Created by JinMeng on 1/28/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import "UniversityViewController.h"

@interface UniversityViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation UniversityViewController

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
    titleLabel.text = @"University";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [button1 setImage:[UIImage imageNamed:@"itemBack.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"university" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *rawString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    universities = [rawString componentsSeparatedByString:@"\r\n"];
    self.dataArray = [NSMutableArray arrayWithArray:universities];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"UniversityCell";
    
    
    //Configure Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaLTStd-Light" size:14];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[[[self.dataArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] lastObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *temp = [[[[self.dataArray objectAtIndex:indexPath.row] componentsSeparatedByString:@","] lastObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    CGSize sz = [temp boundingRectWithSize:CGSizeMake(300.0f, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaLTStd-Light" size:14]} context:nil].size;

    return ((sz.height < 48)?48:sz.height);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray == universities) {
        [self.delegate didSelectUniversity:indexPath.row];
    }
    else {
        NSString *name = [self.dataArray objectAtIndex:indexPath.row];
        for (int i = 0; i < universities.count; i++) {
            if ([[universities objectAtIndex:i] isEqualToString:name]) {
                [self.delegate didSelectUniversity:i];
                break;
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        return;
    }
    
    self.dataArray = [NSMutableArray array];
    
    for (NSString *name in universities) {
        NSString *temp = [[[[name lowercaseString] componentsSeparatedByString:@","] lastObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if ([temp rangeOfString:[searchBar.text lowercaseString]].location != NSNotFound) {
            [self.dataArray addObject:name];
        }
    }
    
    [self.myTableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    self.dataArray = [NSMutableArray arrayWithArray:universities];
    [self.myTableView reloadData];
}

@end
