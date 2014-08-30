//
//  FriendView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-5.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "FriendView.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UserImageView.h"
#import "UserViewController.h"
@implementation FriendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView
{
    self.userInteractionEnabled = YES;
    _userImage = [[UserImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];

        __weak FriendView *weakSelf = self;
        self.userImage.headImageTouchBlock = ^{
            //当点击头像时响应这个代理
            if ([weakSelf.frendiViewDelegate respondsToSelector:@selector(didClickFriendViewWithFriendModel:)]) {
                [weakSelf.frendiViewDelegate didClickFriendViewWithFriendModel:weakSelf.user];
            }
           UserViewController *userViewCtrl = [[UserViewController alloc] init];
            userViewCtrl.screenName = weakSelf.user.screenName;
            [weakSelf.viewContreller.navigationController pushViewController:userViewCtrl animated:YES];
            
        };
    [self addSubview:self.userImage];
    
    _screenNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.userImage.bottom+5, 80, 20)];
    self.screenNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.screenNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.screenNameLabel];
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.screenNameLabel.text = self.user.screenName;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.user.profileImage]];
}


@end
