//
//  UIPlaceHolderTextView.h
//  Scutify
//
//  Created by JinMeng on 2/12/14.
//  Copyright (c) 2014 Scutify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
