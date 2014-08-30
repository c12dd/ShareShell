//
//  BaseLabel.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-17.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapGesturre =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTheLabel:)];
        [self addGestureRecognizer:tapGesturre];
        self.userInteractionEnabled = YES;

    }
    return self;
}
/*
- (id)initWithFrame:(CGRect)frame andBlock:(ClickTheLabel)clickTheLabel
{
    self = [self initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
*/
- (void)tapTheLabel:(UITapGestureRecognizer *)tapGesture
{
    if (self.clickTheLabel) {
        _clickTheLabel();
    }
}
@end
