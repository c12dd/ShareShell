//
//  FriendCell.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-4.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "FriendCell.h"
#import "UIImageView+WebCache.h"
@implementation FriendCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.screenName.text = self.friend.screenName;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.friend.profileImage]];
}
@end
