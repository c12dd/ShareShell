//
//  MessageViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-2.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboTable;
@class CommentTableView;
@interface MessageViewController : BaseViewController
@property (nonatomic,strong) WeiboTable         *weiboTable;
@property (nonatomic,strong) CommentTableView   *commentTable;
@property (nonatomic,assign) NSUInteger         buttonType;
@end
