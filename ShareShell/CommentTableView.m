//
//  CommentTableView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-22.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "WeiboModel.h"
#import "WeiboUtil.h"

static NSUInteger const repostBtnTag  = 100;
static NSUInteger const commentBtnTag = 101;
static NSUInteger const attitudeBtnTag = 102;

@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code

    }
    return self;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  (self.commmentData != nil) ? self.commmentData.count : self.repostData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.commmentData != nil) {
        self.repostData = nil;
        static NSString *cellIdentifier = @"comment";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        }
        //给评论cell的comments赋值
        cell.comments = self.commmentData[indexPath.row];
        //去除cell的选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        self.commmentData = nil;
        static NSString *cellIdentifier = @"repost";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        }

        //给评论cell的comments赋值
        cell.reposts = self.repostData[indexPath.row];
        //取出cell的选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0 ;
    if (self.commmentData != nil) {
        CommentModel *comment = self.commmentData[indexPath.row];
        height = [CommentCell getCellRowHeightWithComment:comment];
    }else{
        WeiboModel *repost = self.repostData[indexPath.row];
        height = [CommentCell getCellRowHeightWithRepost:repost];
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isCommentMe) {
    UIView *headSection = [[UIView alloc] initWithFrame:CGRectZero];
        headSection.alpha = 0;
        return headSection;
    }else{
    UIView *headSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    
    headSection.backgroundColor = [UIColor whiteColor];
    headSection.alpha = 0.7;
    //  转发微博按钮
    UIButton *retsweetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 90, 30)];
    [retsweetBtn setImage:[UIImage imageNamed:@"timeline_icon_retweet_os7"] forState:UIControlStateNormal];
    NSString *retweetButtonTitle = [WeiboUtil formatCount:_weibo.repostsCount];
    [retsweetBtn setTitle: retweetButtonTitle forState:UIControlStateNormal];
    [retsweetBtn setTitle:retweetButtonTitle forState:UIControlStateHighlighted];
    [retsweetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [retsweetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
    retsweetBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    retsweetBtn.titleLabel.textColor = [UIColor darkGrayColor];
    [retsweetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [retsweetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    retsweetBtn.tag = repostBtnTag;
    [retsweetBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headSection addSubview:retsweetBtn];
    
    //  评论微博按纽
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(retsweetBtn.frame)+10, 0, 90, 30)];
    [commentBtn setImage:[UIImage imageNamed:@"timeline_icon_comment_os7"] forState:UIControlStateNormal];
    NSString *commentButtonTitle = [WeiboUtil formatCount:_weibo.commentsCount];
    [commentBtn setTitle:commentButtonTitle forState:UIControlStateNormal];
    [commentBtn setTitle:commentButtonTitle forState:UIControlStateHighlighted];
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    commentBtn.titleLabel.textColor = [UIColor darkGrayColor];
    [commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    commentBtn.tag = commentBtnTag;
    [commentBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headSection addSubview:commentBtn];
    
    //  赞微博按纽
    UIButton *attitudesBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame) + 10,0,90,30)];
    attitudesBtn.tag = attitudeBtnTag;
    [attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike_os7"] forState:UIControlStateNormal];
    [attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateSelected];
    [attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateHighlighted];
    NSString *attitudesButtonTitle = [WeiboUtil formatCount:_weibo.attitudesCount];
    [attitudesBtn setTitle: attitudesButtonTitle forState:UIControlStateNormal];
    [attitudesBtn setTitle:attitudesButtonTitle forState:UIControlStateHighlighted];
    [attitudesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [attitudesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [attitudesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [attitudesBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [attitudesBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    attitudesBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    attitudesBtn.titleLabel.textColor = [UIColor darkGrayColor];
    [attitudesBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headSection addSubview:attitudesBtn];
    
    return headSection;
    }
}



#pragma delegate
- (void)clickBtn:(UIButton *)button
{
    if ([self.tableDelegate respondsToSelector:@selector(changeRepostOrComment:)]) {
        [self.tableDelegate changeRepostOrComment:button.tag];
    }
}

@end
