//
//  NotifyCountModel.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-21.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//
/*
 返回值字段	字段类型	字段说明
 status	NSNumber*	新微博未读数
 follower	int	新粉丝数
 cmt	int	新评论数
 dm	int	新私信数
 mention_status	int	新提及我的微博数
 mention_cmt	int	新提及我的评论数
 group	int	微群消息未读数
 private_group	int	私有微群消息未读数
 notice	int	新通知未读数
 invite	int	新邀请未读数
 badge	int	新勋章数
 photo	int	相册消息未读数
 msgbox	int	{{{3}}}
 */
#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface NotifyCountModel :BaseModel 

@property(nonatomic,assign)NSNumber*     status;             //新微博未读数
@property(nonatomic,assign)NSNumber*     follower;           //新粉丝数
@property(nonatomic,assign)NSNumber*     cmt;                //新评论数
@property(nonatomic,assign)NSNumber*     dm;                 //新私信数
@property(nonatomic,assign)NSNumber*     mention_status;     //新提及我的微博数
@property(nonatomic,assign)NSNumber*     mention_cmt;        //新提及我的评论数
@property(nonatomic,assign)NSNumber*     group;              //微群消息未读数
@property(nonatomic,assign)NSNumber*     private_group;      //私有微群消息未读数
@property(nonatomic,assign)NSNumber*     notice;             //新通知未读数
@property(nonatomic,assign)NSNumber*     invite;             //新邀请未读数
@property(nonatomic,assign)NSNumber*     badge;              //新勋章数
@property(nonatomic,assign)NSNumber*     photo;              //相册消息未读数
@end
