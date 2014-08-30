//
//  UserView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-25.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "UserInfoView.h"
#import "UserModel.h"
#import "WeiboUtil.h"
#import "BaseLabel.h"
#import "UIImageView+WebCache.h"
@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}


- (void)initView
{
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 330)];
    backgroundImage.image = [UIImage imageNamed:kViewBackGroundImage];
    backgroundImage.layer.cornerRadius = 5.0f;
    backgroundImage.layer.masksToBounds = YES;
    backgroundImage.layer.borderColor = [UIColor whiteColor].CGColor;
    backgroundImage.layer.borderWidth = 1.0f;

    [self addSubview:backgroundImage];
    //用户头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectMake(130, 200, 60, 60)];
    self.userImage.layer.cornerRadius = 3.0f;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 1.0f;
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self addSubview:self.userImage];
    
    //用户昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.userImage.bottom+5, 200, 30)];
    self.nickLabel.textAlignment =NSTextAlignmentCenter;
    self.nickLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nickLabel.backgroundColor = [UIColor clearColor];
    self.nickLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nickLabel];
    
    //关注
    _friendsLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(80, self.nickLabel.bottom+5, 80, 20)];
    self.friendsLabel.clickTheLabel = ^{
    
    };
    self.friendsLabel.textAlignment =NSTextAlignmentLeft;
    self.friendsLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.friendsLabel.backgroundColor = [UIColor clearColor];
    self.friendsLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.friendsLabel];
    
    //粉丝
    _followsLabel = [[BaseLabel alloc] initWithFrame:CGRectMake(self.friendsLabel.right, self.friendsLabel.top, self.friendsLabel.width, self.friendsLabel.height)];
    self.followsLabel.textAlignment =NSTextAlignmentRight;
    self.followsLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.followsLabel.backgroundColor = [UIColor clearColor];
    self.followsLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.followsLabel];
    
    //简介
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, backgroundImage.bottom + 5, 300, 40)];
    self.descriptionLabel.font = [UIFont systemFontOfSize:15.0f];
    self.descriptionLabel.adjustsFontSizeToFitWidth = YES;
    self.descriptionLabel.textColor = [UIColor grayColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.numberOfLines = 0;
    [self addSubview:self.descriptionLabel];
    
    
    

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //用户头像
    NSString *strUrl = self.user.avatar_large;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:strUrl]];
    
    //用户昵称
    self.nickLabel.text = self.user.screenName;
    
    
    //关注数
    long friendsCount = [self.user.friendsCount longValue];
    NSString *friends = nil;
    if (friendsCount >= 10000) {
        friendsCount = friendsCount/10000;
        friends = [NSString stringWithFormat:@"关注 %ld万",friendsCount];
    }else{
        friends = [NSString stringWithFormat:@"关注 %ld",friendsCount];
    }
    self.friendsLabel.text = friends;
    
    
    //粉丝数
    long followsCount = [self.user.followersCount longValue];
    NSString *followers = nil;
    if (followsCount >= 10000) {
        followsCount = followsCount/10000;
        followers = [NSString stringWithFormat:@"粉丝 %ld万",followsCount];
    }else{
        followers = [NSString stringWithFormat:@"粉丝 %ld",followsCount];
    }
    self.followsLabel.text = followers;
    
    //简介
    if (self.user.description == nil) {
        self.descriptionLabel.text = @"这家伙什么也没留下！";
    }
    self.descriptionLabel.text = [NSString stringWithFormat:@"    %@",self.user.description];

    
}


@end
