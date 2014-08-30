//
//  HomeViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboTable.h"
@class WeiboTable;
@interface HomeViewController : BaseViewController<weiboTableDelegate>
{
@private
    UIImageView *_countView;
    NSString    *_url;
}

@property (strong,nonatomic)NSString        *accessToken;   //令牌
@property (strong,nonatomic)NSMutableArray  *weiboArray;    //请求网络时获取的微博数据
@property (strong,nonatomic)NSString        *sinceId;       //sinceid记录最新一条条微博的id
@property (strong,nonatomic)NSString        *maxId;         //记录最后一条微博的id
@property (assign,nonatomic)NSUInteger       count;         //新微薄的计数
@property (strong,nonatomic)WeiboTable      *weiboTable;    //微博列表对象


@end
