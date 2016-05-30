//
//  ProfileCell.m
//  Befriend
//
//  Created by JinMeng on 1/17/14.
//  Copyright (c) 2014 JinMeng. All rights reserved.
//

#import "ProfileCell.h"

@interface ProfileCell ()
{
    UILabel *noteLabel;
    UILabel *selectLabel;
}
/// the original center of the cell
@property (nonatomic) CGPoint originalCenter;
/// if YES, delete the cell on release
@property (nonatomic) BOOL deleteOnDragRelease;
/// if YES, select the cell on release
@property (nonatomic) BOOL selectOnDragRelease;
@end

@implementation ProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addRecognizer];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)customizeCell
{
    self.backView = [[UIView alloc] initWithFrame:CGRectNull];
    self.backView.backgroundColor = [UIColor clearColor];
    [self addRecognizer];
    self.dislikeView.hidden = YES;
    self.likeView.hidden = YES;
}
/**
 * Adds a gesture recognizer to recognize the swipe action
 */
- (void)addRecognizer
{
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftGesture];

    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightGesture];
}

- (void)leftSwipe
{
    if (self.dislikeView.hidden == YES) {
        self.likeView.hidden = NO;
        [self.dict setObject:[NSNumber numberWithBool:YES] forKey:@"LIKE"];
    }
    [self.dict setObject:[NSNumber numberWithBool:NO] forKey:@"DISLIKE"];
    self.dislikeView.hidden = YES;
}

- (void)rightSwipe
{
    if (self.likeView.hidden == YES) {
        self.dislikeView.hidden = NO;
        [self.dict setObject:[NSNumber numberWithBool:YES] forKey:@"DISLIKE"];
    }
    [self.dict setObject:[NSNumber numberWithBool:NO] forKey:@"LIKE"];
    self.likeView.hidden = YES;
}

- (IBAction)clickAccept:(id)sender
{
    [self.dict setObject:[NSNumber numberWithBool:NO] forKey:@"LIKE"];
    self.likeView.hidden = YES;

    [self.delegate acceptFriend:self.indexPath];
}

- (IBAction)clickDecline:(id)sender
{
    self.dislikeView.hidden = YES;
    [self.dict setObject:[NSNumber numberWithBool:NO] forKey:@"DISLIKE"];

    [self.delegate declineFriend:self.indexPath];
}

@end
