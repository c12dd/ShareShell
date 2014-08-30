//
//  DetailViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableView.h"
@class WeiboModel;
@class WeiboView;
@class UserImageView;
@interface DetailViewController : BaseViewController<repostOrCommentDelegate>
{
@private
    WeiboView *_weiboView;
}
@property (strong, nonatomic) UserImageView     *userImageView;
@property (strong, nonatomic) CommentTableView  *tableView;
@property (strong, nonatomic) WeiboModel        *weibo;
@property (strong, nonatomic) IBOutlet UIView            *userView;
@property (strong, nonatomic) IBOutlet UILabel           *nickLabel;
@property (strong, nonatomic) IBOutlet UILabel           *createAtLabel;
@property (strong, nonatomic) IBOutlet UILabel           *sourceLabel;
@property (strong, nonatomic) NSMutableArray    *commData;
@property (strong, nonatomic) NSMutableArray    *repostData;
@property (strong, nonatomic) NSString          *max_id;
@property (strong, nonatomic) NSString          *since_id;
@property (strong, nonatomic) NSString          *comment_max_id;
@property (strong, nonatomic) NSString          *comment_since_id;
@property (strong, nonatomic) NSString          *repost_max_id;
@property (strong, nonatomic) NSString          *repost_since_id;
@property (assign, nonatomic) BOOL              isComment;
@property (assign, nonatomic) BOOL              isNearby;

@end
