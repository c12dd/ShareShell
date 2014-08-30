//
//  UserViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-25.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTable.h"
@class UserModel;
@class WeiboModel;
@class UserInfoView;
@interface UserViewController : BaseViewController<weiboTableDelegate>


@property (strong, nonatomic) UserModel         *user;
@property (strong, nonatomic) WeiboModel        *weibos;
@property (strong, nonatomic) UserInfoView      *userInfoView;
@property (strong, nonatomic) WeiboTable        *weiboTable;    //微博列表对象
@property (strong, nonatomic) NSMutableArray    *weiboArray;    //请求网络时获取的微博数据
@property (strong, nonatomic) NSString          *sinceId;       //sinceid记录最新一条条微博的id
@property (strong, nonatomic) NSString          *maxId;         //记录最后一条微博的id
@property (strong, nonatomic) NSString          *screenName;
@end
