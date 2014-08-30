//
//  NotifyCountModel.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-21.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//
/*
 status;             //新微博未读数
 follower;           //新粉丝数
 cmt;                //新评论数
 dm;                 //新私信数
 mention_status;     //新提及我的微博数
 mention_cmt;        //新提及我的评论数
 group;              //微群消息未读数
 private_group;      //私有微群消息未读数
 notice;             //新通知未读数
 invite;             //新邀请未读数
 badge;              //新勋章数
 photo;              //相册消息未读数
 */
#import "NotifyCountModel.h"

@implementation NotifyCountModel

- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAttr = nil;
    mapAttr = @{
                @"status":@"status",
                @"follower":@"follower",
                @"cmt":@"cmt",
                @"dm":@"dm",
                @"mention_status":@"mention_status",
                @"mention_cmt":@"mention_cmt",
                @"group":@"group",
                @"private_group":@"private_group",
                @"notice":@"notice",
                @"invite":@"invite",
                @"badge":@"badge",
                @"photo":@"photo"
                };
    
    
    return mapAttr;

}


@end
