//
//  CommentModel.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

/*
 返回值字段	字段类型	字段说明
 created_at	string	评论创建时间
 id	int64	评论的ID
 text	string	评论的内容
 source	string	评论的来源
 user	object	评论作者的用户信息字段 详细
 mid	string	评论的MID
 idstr	string	字符串型的评论ID
 status	object	评论的微博信息字段 详细
 reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段
*/

#import "BaseModel.h"

@interface CommentModel : BaseModel



@property (nonatomic , strong)NSString      *created_at;
@property (nonatomic , strong)NSNumber      *id;
@property (nonatomic , strong)NSString      *text;
@property (nonatomic , strong)NSString      *source;
@property (nonatomic , strong)NSDictionary  *user;
@property (nonatomic , strong)NSString      *mid;
@property (nonatomic , strong)NSString      *idstr;
@property (nonatomic , strong)NSDictionary  *status;
@property (nonatomic , strong)NSString      *reply_comment;
@end
