//
//  CommentModel.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (NSDictionary *)attributeMapDictionary
{
    [super attributeMapDictionary];
    NSDictionary *attrDic = @{
                              @"created_at":@"created_at",
                              @"id":@"id",
                              @"text":@"text",
                              @"source":@"source",
                              @"user":@"user",
                              @"mid":@"mid",
                              @"idstr":@"idstr",
                              @"status":@"status",
                              @"reply_comment":@"reply_comment"
                              };

    return attrDic;
}

@end
