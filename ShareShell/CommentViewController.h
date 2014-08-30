//
//  CommentViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-3.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
@class EmotionsBoard;
@class WeiboModel;
@interface CommentViewController : BaseViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView       *toolBarView;
@property (strong, nonatomic) IBOutlet UITextView   *sendTextView;
@property (strong, nonatomic) EmotionsBoard         *emotionsBoard;
@property (strong, nonatomic) WeiboModel            *weibo;
@property (strong, nonatomic) NSString              *weiboId;
@property (strong, nonatomic) UIView                *repostView;
@property (assign, nonatomic) BOOL                  isComment;
@end
