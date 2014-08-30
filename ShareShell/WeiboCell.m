//
//  WeiboCell.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-18.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboUtil.h"
#import "XMLDictionary.h"
#import "UserImageView.h"
#import "UserViewController.h"
#import "UIView+searchResponse.h"
#import "CommentViewController.h"

typedef enum {
    BottomBtnRepost     = 100,
    BottomBtnComment    = 101,
    BottomBtnAttitude   = 102
}BottomBtnTag;
@implementation WeiboCell
#pragma mark - 初始化子视图
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        
    }
    return self;
}

- (UIButton *)createBottomButton:(CGRect)frame
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 50)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 20)];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    button.titleLabel.textColor = [UIColor darkGrayColor];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    return button;
}


- (void)initView
{
    
    
    //转发 评论 赞 的底层视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bottomView];
    //  转发微博按钮
    _retsweetBtn = [self createBottomButton:CGRectMake(20, 2.5, 90, 30)];
    [_retsweetBtn setImage:[UIImage imageNamed:@"timeline_icon_retweet_os7"] forState:UIControlStateNormal];
    _retsweetBtn.tag = BottomBtnRepost;
    [_retsweetBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_retsweetBtn];
    
    //  评论微博按纽
    _commentBtn = [self createBottomButton:CGRectMake(CGRectGetMaxX(_retsweetBtn.frame)+10, 2.5, 90, 30)];
    [_commentBtn setImage:[UIImage imageNamed:@"timeline_icon_comment_os7"] forState:UIControlStateNormal];
    _commentBtn.tag = BottomBtnComment;
    [_commentBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_commentBtn];
    
    //  赞微博按纽
    _attitudesBtn = [self createBottomButton:CGRectMake(CGRectGetMaxX(_commentBtn.frame) + 10,2.5,90,30)];
    _attitudesBtn.tag = BottomBtnAttitude;
    [_attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike_os7"] forState:UIControlStateNormal];
    [_attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateSelected];
    [_attitudesBtn setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateHighlighted];
    [_attitudesBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [_attitudesBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_attitudesBtn];


    //---------------用户头像---------------
    _userImage = [[UserImageView alloc] initWithFrame:CGRectZero];
    _userImage.layer.cornerRadius = 5.0f;//圆弧半径
    _userImage.layer.borderWidth = 0.5f;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    //点击头像时回调的block

    __weak WeiboCell *weakSelf = self;
    _userImage.headImageTouchBlock = ^{
        UserViewController *userViewController = [[UserViewController alloc] init];
        userViewController.screenName = weakSelf.user.screenName;
        [weakSelf.viewContreller.navigationController pushViewController:userViewController animated:YES];
    };
    
    
    [self.contentView addSubview:_userImage];
    
    //---------------用户昵称---------------
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.font = [UIFont systemFontOfSize:14.0f];
    _nickLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nickLabel];
    
    //---------------发布来源---------------
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0f];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_sourceLabel];

    //---------------发布时间---------------
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:12.0f];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_createLabel];
    
    //---------------微博视图---------------
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];


    
}


- (void)setWeibo:(WeiboModel *)weibo
{   if(self.weibo != weibo){
    _weibo = weibo;
    }
    _user = [[UserModel alloc] initWithDataDic:_weibo.user];
}

- (void)reSetFrame
{
    _userImage.frame = CGRectZero;
    _nickLabel.frame = CGRectZero;
    _createLabel.frame = CGRectZero;
    _sourceLabel.frame = CGRectZero;
    _weiboView.frame = CGRectZero;
    _bottomView.frame = CGRectZero;
}

#pragma mark - 视图布局以及指定数据
-(void)layoutSubviews
{
    [super layoutSubviews];

       //---------------用户头像布局---------------
    _userImage.frame = CGRectMake(5, 5, 35, 35);

    //获得发布该微博的用户信息
    NSString *userImage = _user.profileImage;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:userImage]];
    //---------------用户昵称布局---------------
    _nickLabel.frame = CGRectMake(_userImage.right + 10, 5, 200, 20);
    _nickLabel.text = _user.screenName;
    //---------------发布时间布局---------------
    _createLabel.frame = CGRectMake(_userImage.right + 10, _nickLabel.bottom, 100, 20);
    NSString *dataString = [WeiboUtil resolveSinaWeiboDate:_weibo.createDate];
    _createLabel.text = dataString;
    //---------------发布来源布局---------------
    _sourceLabel.frame = CGRectMake(_createLabel.right + 5, _nickLabel.bottom, 150, 20);
    NSDictionary *sourceDic = [NSDictionary dictionaryWithXMLString:_weibo.source];
    NSString *sourceStr = [sourceDic objectForKey:XMLDictionaryTextKey];
    if (sourceStr != nil) {
        _sourceLabel.text = [NSString stringWithFormat:@"来自%@",sourceStr];
        _sourceLabel.hidden = NO;
    }else{
        _sourceLabel.hidden = YES;
    }
    //---------------微博视图布局---------------
    //调用WeiboView的类方法计算WeiboView的类方法
#pragma mark - 将WeiboCell的WeiboModel对象传值给WeiboView
    _weiboView.weibo = self.weibo;
    CGFloat height = [WeiboView getWeiboViewHeight:_weibo isRepost:NO isDetail:NO];
    _weiboView.frame = CGRectMake(50, _nickLabel.bottom + 25.0f, (320 - 60), height);
    _bottomView.frame = CGRectMake(5, _weiboView.bottom + 5, 310, 30);
    //---------------转发数布局---------------
    NSString *retweetButtonTitle = [WeiboUtil formatCount:_weibo.repostsCount];
    [_retsweetBtn setTitle: retweetButtonTitle forState:UIControlStateNormal];
    [_retsweetBtn setTitle:retweetButtonTitle forState:UIControlStateHighlighted];
    [_bottomView addSubview:_retsweetBtn];
    //---------------评论数布局---------------
    NSString *commentButtonTitle  = [WeiboUtil formatCount:_weibo.commentsCount];
    [_commentBtn setTitle:commentButtonTitle forState:UIControlStateNormal];
    [_commentBtn setTitle:commentButtonTitle forState:UIControlStateHighlighted];
    //---------------赞数布局---------------
    NSString *attitudesButtonTitle = [WeiboUtil formatCount:_weibo.attitudesCount];
    [_attitudesBtn setTitle: attitudesButtonTitle forState:UIControlStateNormal];
    [_attitudesBtn setTitle:attitudesButtonTitle forState:UIControlStateHighlighted];
}


- (void)clickBtn:(UIButton *)button
{
    switch (button.tag) {
        case BottomBtnRepost:
            [self presentToCommentViewController:NO];
            break;
        case BottomBtnComment:
            [self presentToCommentViewController:YES];
            break;
        case BottomBtnAttitude:
            
            break;

            
        default:
            break;
    }
   
    
}

- (void)presentToCommentViewController:(BOOL)isComment;
{
    CommentViewController *commentViewController = [[CommentViewController alloc] init];
    if (isComment) {
        commentViewController.isComment = isComment;
        commentViewController.weiboId = [self.weibo.weiboId stringValue];
    }else{
        commentViewController.weibo = self.weibo;
    }
    BaseNavigationController *navigation =  [[BaseNavigationController alloc] initWithRootViewController:commentViewController];
    [self.viewContreller presentViewController:navigation animated:YES completion:^{
    }];
}

@end
