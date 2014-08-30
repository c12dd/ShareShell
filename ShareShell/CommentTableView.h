//
//  CommentTableView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseTableView.h"



@class WeiboModel;
@protocol repostOrCommentDelegate <NSObject>

- (void)changeRepostOrComment:(NSUInteger)ButtonTag;

@end
@interface CommentTableView : BaseTableView
{
    __weak id<repostOrCommentDelegate> _tableDelegate;
}

@property (nonatomic , strong) NSArray *repostData;
@property (nonatomic , strong) NSArray *commmentData;
@property (nonatomic , strong) WeiboModel *weibo;
@property (assign, nonatomic) BOOL              isCommentMe;
@property (nonatomic , weak) id<repostOrCommentDelegate> tableDelegate;
@end
