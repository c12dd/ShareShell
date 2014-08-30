//
//  WeiboView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-18.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "WeiboImageView.h"

@class WeiboModel;
@class UserModel;
@interface WeiboView : UIView<RTLabelDelegate,weiboImageDelegate,UIScrollViewDelegate>
{
@private;
    NSMutableString *_parseText;        //经过@ # 超链接处理的文本内容
    NSMutableString *_tempText;         //临时处理转发文本中
    WeiboImageView  *_image;
    
}
@property(nonatomic,strong)UIImageView  *backgroundImage;   //微博的背景图片
@property(nonatomic,strong)UIView       *bottomView;        //图片的背景视图;
@property(nonatomic,strong)RTLabel      *textLabel;         //微博内容
@property(nonatomic,strong)WeiboView    *repostView;        //转发的微博
@property(nonatomic,strong)WeiboModel   *weibo;             //微博对象
@property(nonatomic,strong)UserModel    *repostUser;
@property(nonatomic,assign)BOOL         isRepost;
@property(nonatomic,assign)BOOL         isDetail;


//通过传入参数获得字体的大小
+(CGFloat)getFontSizeWithisRepost:(BOOL)isRepost isDetail:(BOOL)isDetail;

//通过微博的信息计算行高
+(CGFloat)getWeiboViewHeight:(WeiboModel *)weibo isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail;
@end
