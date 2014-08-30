//
//  UserImageView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-26.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "UserImageView.h"


@implementation UserImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHeadImageAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}



- (void)touchHeadImageAction:(UITapGestureRecognizer *)tap
{
    if (self.headImageTouchBlock) {
        _headImageTouchBlock();
    }

}


@end
