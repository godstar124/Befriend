//
//  NetworkCell.h
//  Befriend
//
//  Created by JinMeng on 1/15/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *network;
@property (nonatomic, weak) IBOutlet UILabel *university;
@property (nonatomic, weak) IBOutlet UILabel *employer;
@property (nonatomic, weak) IBOutlet UILabel *nameOfUniversity;
@property (nonatomic, weak) IBOutlet UILabel *nameOfEmployer;

@end
