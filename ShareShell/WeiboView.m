//
//  WeiboView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-18.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboView.h"
#import "UserViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+URLEncoding.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboUtil.h"
#import "RegexKitLite.h"
#import "ZoomScaleViewController.h"

#define LIST_FONT   14.0f           //列表中文本字体
#define LIST_REPOST_FONT  13.0f;    //列表中转发的文本字体
#define DETAIL_FONT  18.0f          //详情的文本字体
#define DETAIL_REPOST_FONT 17.0f    //详情中转发的文本字体

@implementation WeiboView

#pragma mark - initMethod
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
        //初始化解析文本字符串变量
        _parseText = [NSMutableString string];
        _tempText  = [NSMutableString string];
    }
    return self;
}
- (void)initView
{
    
    //微博内容label
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    self.textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"blue" forKey:@"color"];
    self.textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"red" forKey:@"color"];
    self.textLabel.delegate = self;
    [self addSubview:self.textLabel];
    //微博中的图片底视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.bottomView];
    //微博背景图片
    _backgroundImage = [UIFactory initWithImageName:@"selectItem.png"];
    //拉伸微博背景图片
    UIImage *image = [self.backgroundImage.image stretchableImageWithLeftCapWidth:25.0f topCapHeight:22.5f];
    self.backgroundImage.image = image;
    self.backgroundImage.backgroundColor = [UIColor clearColor];
    self.backgroundImage.alpha = 0.1;
    [self insertSubview:self.backgroundImage atIndex:0];

}

#pragma mark - 替换微博中的@用户 超链接 #话题#等字符
- (void)parseLink
{
    //如果不是转发的微博要return
    if (_weibo.text == nil || _weibo.text.length ==0) {
        return;
    }
    [_parseText setString:@""];
    [_tempText setString:@""];
    //获得微博中的文本内容
    NSString *text = _weibo.text;
    /*定义正则表达式   (@\\w+)表示以@开头的任意字符或数字出现一次或多次
                     (#\\w+#)表示以#开头#结尾，中间出现数字或字符一次或多次
                     (http(s)?://([A-Za-z0-9._-]+(/)?)*)
     */
    //判断如果是转发的微博将微博的原作者添加到微博的前面
    if (_isRepost) {
        NSString *screenName = _repostUser.screenName;
        NSString *replaceScreenName = [NSString stringWithFormat:@"@%@ :",screenName];
        [_tempText appendString:replaceScreenName];
    }
    [_tempText appendString:text];
    text = [WeiboUtil parseTextLink:_tempText];
    [_parseText appendString:text];
}

#pragma mark - rewrite setWeibo
- (void)setWeibo:(WeiboModel *)weibo
{
    if (_weibo != weibo ) {
        _weibo = weibo;
    }
    if (self.repostView == nil) {
        _repostView = [[WeiboView alloc] initWithFrame:CGRectZero];
        self.repostView.isRepost = YES;
        [self addSubview:self.repostView];
        if (self.isDetail) {
            self.repostView.isDetail = YES;
        }
    }
    if (self.weibo.relWeibo != nil) {
    self.repostView.repostUser = [[UserModel alloc] initWithDataDic:[self.weibo.relWeibo objectForKey:@"user"]];
    }
}
#pragma mark - WeiboViewLayout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self parseLink];
    //微博内容
    self.textLabel.frame = CGRectMake(0, 0, self.width, 0);
    if (self.isRepost) {
        self.textLabel.frame = CGRectMake(5, 10, self.width - 10, 0);
    }
    CGFloat fontSize = [WeiboView getFontSizeWithisRepost:self.isRepost isDetail:self.isDetail];
    self.textLabel.text = _parseText;
    self.textLabel.font = [UIFont systemFontOfSize:fontSize];
    CGSize textSize = self.textLabel.optimumSize;
    self.textLabel.height = textSize.height;
    
    //微博中的转发微博

    if (self.weibo.relWeibo != nil) {
        self.repostView.weibo = [[WeiboModel alloc] initWithDataDic:self.weibo.relWeibo];
        self.repostView.hidden = NO;
        CGFloat height = [WeiboView getWeiboViewHeight:self.repostView.weibo isRepost:YES isDetail:self.isDetail];
        self.repostView.frame = CGRectMake(0, self.textLabel.bottom, self.width - 10, height);
    }else{
        self.repostView.hidden = YES;
    }
    
    //转发微博的背景
    if (self.isRepost) {
        self.backgroundImage.frame = self.frame;
    }

    //微博中的图片
    while ([[_bottomView subviews] lastObject] != nil) {
        [[[_bottomView subviews] lastObject] removeFromSuperview];
    }
    if (self.isDetail) {
        [self imageLayout:_weibo Width:90 Height:100 LineHeight:120];
    }else{
        [self imageLayout:_weibo Width:75 Height:85 LineHeight:100];
    }
    
}

#pragma mark - 图片布局和图片缩放
- (void)pushToZoomScaleView:(WeiboModel *)weibo
{
    ZoomScaleViewController *zoomScale = [[ZoomScaleViewController alloc] init];
    zoomScale.url = weibo.originalImage;
    zoomScale.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.viewContreller presentViewController:zoomScale animated:YES completion:nil];
}


- (void)imageLayout:(WeiboModel *)weibo Width:(NSUInteger)width Height:(NSUInteger)height LineHeight:(NSUInteger)lineHeight
{
    _image = nil;
    __weak WeiboView *weakSelf = self;
    if (_weibo.picUrls.count > 1) {
        CGFloat sumHeight = 0;
        for (NSUInteger index = 0; index < _weibo.picUrls.count; index ++) {
            if (_weibo.picUrls.count == 4) {
                _image = [[WeiboImageView alloc] initWithFrame:CGRectMake(5+(index%2)*width, 5+height*(index/2), width, height)];
                _image.weiboImageDelegate = self;
                _image.clickImageBlock = ^(WeiboModel *weibo){
                [weakSelf pushToZoomScaleView:weibo];
                };
                
                _image.contentMode = UIViewContentModeScaleAspectFit;
                [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_weibo.picUrls[index] objectForKey:@"thumbnail_pic"]]]];
                [_bottomView addSubview:_image];
                sumHeight = lineHeight * (_weibo.picUrls.count / 2);
                _bottomView.frame = CGRectMake(0, _textLabel.bottom+10, 300, sumHeight);
            }else{
                _image = [[WeiboImageView alloc] initWithFrame:CGRectMake(5+(index%3)*width, 5+height*ceil(index/3), width, height)];
                _image.weiboImageDelegate = self;
                _image.clickImageBlock = ^(WeiboModel *weibo){
                    [weakSelf pushToZoomScaleView:weibo];
                };
                _image.contentMode = UIViewContentModeScaleToFill;
                [_image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_weibo.picUrls[index] objectForKey:@"thumbnail_pic"]]]];
                [_bottomView addSubview:_image];
                sumHeight = lineHeight * ceilf(_weibo.picUrls.count / 3.0f);
                _bottomView.frame = CGRectMake(0, _textLabel.bottom+10, 260, sumHeight);
            }
        }

    }else{
        NSString *thumbImage = _weibo.thumbnailImage;
        if (thumbImage != nil || [thumbImage isEqualToString:@""]) {
            _image = [[WeiboImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            _image.weiboImageDelegate = self;
            _image.clickImageBlock = ^(WeiboModel *weibo){
                [weakSelf pushToZoomScaleView:weibo];

            };
            //加载网络图片
            [_image sd_setImageWithURL:[NSURL URLWithString:thumbImage]];
            _image.contentMode = UIViewContentModeScaleAspectFit;
            [_bottomView addSubview:_image];
            _bottomView.frame = CGRectMake(10, _textLabel.bottom + 5, width, height);
        }
    }
}




#pragma mark - 根据传入参数判断字体的大小
+(CGFloat)getFontSizeWithisRepost:(BOOL)isRepost isDetail:(BOOL)isDetail
{
    if (isDetail && isRepost) {
        return DETAIL_REPOST_FONT;
    }else if (isDetail && !isRepost){
        return DETAIL_FONT;
    }else if (!isDetail && isRepost){
        return LIST_REPOST_FONT;
    }else{
        return LIST_FONT;
    }
}



#pragma mark - 计算微博视图的行高
+(CGFloat)getWeiboViewHeight:(WeiboModel *)weibo isRepost:(BOOL)isRepost isDetail:(BOOL)isDetail
{
    //计算每个视图的行高然后相加
    CGFloat height = 0;
    //-----------------label的高度-----------------------
    RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectZero];
    //根据字体计算行高
    if (isDetail) {
        label.width = 300;
    }else{
        label.width = (320 - 60);
    }
    CGFloat fontSize = [WeiboView getFontSizeWithisRepost:isRepost isDetail:isDetail];
    //判断WeiboView是否在详细页面来判断宽度
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = weibo.text;
    //如果是转发的微博label的宽度要-
    if (isRepost) {
        label.width -= 10;
    }
    
    height += label.optimumSize.height;
    

    //微博中图片的高度
        if (weibo.picUrls.count > 1) {  //微博中又多张图片时
            if (isDetail) {
                height += (100 *ceilf(weibo.picUrls.count / 3.0f));
            }else{
                height += (100 *ceilf(weibo.picUrls.count / 3.0f));
            }
        }else if(weibo.thumbnailImage == nil || [weibo.thumbnailImage isEqualToString:@""]){//w微博中没有图片
        }else{
            height += 90;//微博中欧有一张图片
        }


#pragma mark - 递归调用getWeiboViewHeight计算转发微博的高度
    //-----------------转发微博的高度-----------------------
    
#pragma mark -  当有一个WeiboMode的对象执行此方法是，首先盘对该对象内的转发微博字典是否为空，如果不为空则说明是转发微博，就再进行转发微博高度的计算，首先去除WeiboModel中转发微博的字典，并且将转发的微博字典变为实体类对象，在对这个对象的内容调用WeiboView的类方法进行高度计算。
    if (weibo.relWeibo != nil) {
        WeiboModel *weibos = [[WeiboModel alloc] initWithDataDic:weibo.relWeibo];
        CGFloat repostHeight = [WeiboView getWeiboViewHeight:weibos isRepost:YES isDetail:isDetail];
        height +=repostHeight;
    }
    //如果是转发微博高度再加30,因为计算是没有减去原创微博比转发微博宽度多出来的部分
    if (isRepost) {
        height+= 30;
    }
    
    
    return height;
}





#pragma mark - weiboImageDelegate点击图片进入这张图片
- (void)clickTheImageView:(UITapGestureRecognizer *)tap
{
    //调用自身的block传入值
    _image.clickImageBlock(_weibo);
}




#pragma mark - RTLabel Delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    //多点击的超链接进行反编码获得中文字符
    NSString *absoluteString = [url absoluteString];
    if ([absoluteString hasPrefix:@"user"]) {
        NSString *urlString = [url host];
        NSLog(@"%@",urlString);
        NSString *screenName = [urlString substringWithRange:NSMakeRange(1, urlString.length-1)];
        UserViewController *userView = [[UserViewController alloc] init];
        userView.screenName = screenName;
        [self.viewContreller.navigationController pushViewController:userView animated:YES];
        
    }else if ([absoluteString hasPrefix:@"topic"]) {
        NSString *urlString = [url host];
        NSLog(@"%@",urlString);
    }else if ([absoluteString hasPrefix:@"http"]) {
        NSLog(@"%@",absoluteString);

    }
}



@end
