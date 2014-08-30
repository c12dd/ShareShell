//
//  FriendView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-5.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@class UserImageView;

@protocol FriendViewDelegate <NSObject>

- (void)didClickFriendViewWithFriendModel:(UserModel *)user;

@end
@interface FriendView : UIView
{
@private
    __weak id _frendiViewDelegate;
}
@property (weak, nonatomic) id<FriendViewDelegate> frendiViewDelegate;
@property (strong, nonatomic) UserImageView *userImage;
@property (strong, nonatomic) UILabel *screenNameLabel;
@property (strong, nonatomic) UserModel *user;


@end
