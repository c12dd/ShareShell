//
//  FriendGridCell.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "FriendGridCell.h"
#import "FriendView.h"
@implementation FriendGridCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)initView
{
    for (NSUInteger index = 0; index < 3; index ++) {
        _friendView = [[FriendView alloc] initWithFrame:CGRectMake(13.5+(index*106.7), 2.5, 80, 80)];
        self.friendView.tag = (2013+index);
        self.friendView.hidden = YES;
        [self addSubview:self.friendView];
    }


}
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (NSUInteger index = 0; index < self.friendArray.count; index++) {
        UserModel *user = self.friendArray[index];
        FriendView *friendView = (FriendView *)[self viewWithTag:(2013+index)];
        friendView.hidden = NO;
        friendView.user = user;
    }

}


@end
