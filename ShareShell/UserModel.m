//
//  UserModel.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-18.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//



/*
 id	int64	用户UID
 idstr	string	字符串型的用户UID
 screen_name	string	用户昵称
 name	string	友好显示名称
 province	int	用户所在省级ID
 city	int	用户所在城市ID
 location	string	用户所在地
 description	string	用户个人描述
 url	string	用户博客地址
 profile_image_url	string	用户头像地址（中图），50×50像素
 profile_url	string	用户的微博统一URL地址
 domain	string	用户的个性化域名
 weihao	string	用户的微号
 gender	string	性别，m：男、f：女、n：未知
 followers_count	int	粉丝数
 friends_count	int	关注数
 statuses_count	int	微博数
 favourites_count	int	收藏数
 created_at	string	用户创建（注册）时间
 following	boolean	暂未支持
 allow_all_act_msg	boolean	是否允许所有人给我发私信，true：是，false：否
 geo_enabled	boolean	是否允许标识用户的地理位置，true：是，false：否
 verified	boolean	是否是微博认证用户，即加V用户，true：是，false：否
 verified_type	int	暂未支持
 remark	string	用户备注信息，只有在查询用户关系时才返回此字段
 status	object	用户的最近一条微博信息字段 详细
 allow_all_comment	boolean	是否允许所有人对我的微博进行评论，true：是，false：否
 avatar_large	string	用户头像地址（大图），180×180像素
 avatar_hd	string	用户头像地址（高清），高清头像原图
 verified_reason	string	认证原因
 follow_me	boolean	该用户是否关注当前登录用户，true：是，false：否
 online_status	int	用户的在线状态，0：不在线、1：在线
 bi_followers_count	int	用户的互粉数
 lang	string	用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
 


@property(nonatomic,strong)NSNumber              *userId;                   //用户UID
@property(nonatomic,strong)NSString              *screenName;               //字符串型的用户UID
@property(nonatomic,strong)NSString              *name;                     //用户UID
@property(nonatomic,strong)NSNumber              *province;                 //友好显示名称
@property(nonatomic,strong)NSNumber              *city;                     //城市
@property(nonatomic,strong)NSString              *location;                 //用户所在地
@property(nonatomic,strong)NSString              *description;              //用户个人描述
@property(nonatomic,strong)NSString              *url;                      //用户博客地址
@property(nonatomic,strong)NSString              *profileImage;             //用户头像地址（中图），50x50
@property(nonatomic,strong)NSString              *gender;                   //性别，m：男、f：女、n：未知
@property(nonatomic,strong)NSNumber              *followersCount;           //粉丝数
@property(nonatomic,strong)NSNumber              *friendsCount;             //好友数
@property(nonatomic,retain)NSNumber              *statusesCount;           //微博数
@property(nonatomic,strong)NSNumber              *favouritesCount;          //收藏数
@property(nonatomic,strong)NSString              *createDate;               //创建日期
@property(nonatomic,strong)WeiboModel            *status;
@property(nonatomic,assign)BOOL                  *allow_all_act_msg;        //是否允许所有人发私信给我
@property(nonatomic,assign)BOOL                  *geo_enabled;              //是否允许标识用户的地理位置
@property(nonatomic,assign)BOOL                  *verified;                 //是否是微博认证用户
@property(nonatomic,strong)NSString              *remark;                   //用户备注信息，只有在查询用户关系时才返回此字段
@property(nonatomic,assign)NSString              *allow_all_comment;        //是否允许所有人对我的微博进行评论
@property(nonatomic,strong)NSString              *avatar_large;             //用户头像地址（大图），180×180像素
*/


#import "UserModel.h"


@implementation UserModel



-(NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapDic = @{
                 @"userId":@"id",
                 @"screenName":@"screen_name",
                 @"name":@"name",
                 @"province":@"province",
                 @"city":@"city",
                 @"location":@"location",
                 @"description":@"description",
                 @"url":@"url",
                 @"profileImage":@"profile_image_url",
                 @"gender":@"gender",
                 @"status":@"status",
                 @"followersCount":@"followers_count",
                 @"friendsCount":@"friends_count",
                 @"statusesCount":@"statuses_count",
                 @"favouritesCount":@"favourites_count",
                 @"createDate":@"created_at",
                 @"allow_all_act_msg":@"allow_all_act_msg",
                 @"geo_enabled":@"geo_enabled",
                 @"verified":@"verified",
                 @"remark":@"remark",
                 @"allow_all_comment":@"allow_all_comment",
                 @"avatar_large":@"avatar_large"
                             };
    
    return mapDic;
}


@end
