//
//  WeiboImageView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboImageView.h"

@implementation WeiboImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
    }
    return self;
}



- (void)clickImage:(UITapGestureRecognizer *)tap
{
    if ([self.weiboImageDelegate respondsToSelector:@selector(clickTheImageView:)]) {
        [self.weiboImageDelegate clickTheImageView:tap];
    }
}

@end
