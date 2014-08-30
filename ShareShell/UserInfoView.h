//
//  UserView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-25.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@class BaseLabel;
@interface UserInfoView : UIView


@property (strong, nonatomic) UIImageView   *userImage;
@property (strong, nonatomic) UILabel       *descriptionLabel;
@property (strong, nonatomic) BaseLabel     *followsLabel;
@property (strong, nonatomic) BaseLabel     *friendsLabel;
@property (strong, nonatomic) UILabel       *nickLabel;
@property (strong, nonatomic) UserModel     *user;
@property (strong, nonatomic) NSString      *screenName;

@end
