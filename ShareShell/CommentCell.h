//
//  CommentCell.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@class CommentModel;
@class WeiboModel;
@class UserImageView;
@interface CommentCell : UITableViewCell<RTLabelDelegate>


@property (nonatomic , strong) UserImageView      *userImage;
@property (nonatomic , strong) UILabel          *nickLabel;
@property (nonatomic , strong) UILabel          *createLabel;
@property (nonatomic , strong) RTLabel          *commentLabel;
@property (nonatomic , strong) CommentModel     *comments;
@property (nonatomic , strong) WeiboModel       *reposts;

//通过评论内容获得行高
+ (CGFloat)getCellRowHeightWithComment:(CommentModel *)comment;

+ (CGFloat)getCellRowHeightWithRepost:(WeiboModel *)repost;
@end
