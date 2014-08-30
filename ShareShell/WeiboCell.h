//
//  WeiboCell.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-18.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboView.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboImageView.h"
@class UserImageView;
@interface WeiboCell : UITableViewCell
{
@private
    UserImageView   *_userImage;        //用户头像视图
    UILabel         *_nickLabel;        //昵称
    UIButton        *_attitudesBtn;
    UIButton        *_commentBtn;
    UIView          *_bottomView;
    UIButton        *_retsweetBtn;
    UILabel         *_sourceLabel;      //发布来源
    UILabel         *_createLabel;      //发布时间
}
//微博视图
@property(nonatomic,strong)WeiboView  *weiboView;
//微博模型
@property(nonatomic,strong)WeiboModel *weibo;
//用户模型
@property(nonatomic,strong)UserModel  *user;



@end
