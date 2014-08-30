//
//  ThemeButton.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"
@implementation ThemeButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        //添加主题变更通知监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

//通知响应的方法
- (void)themeNotification:(NSNotification *)notification
{
    [self loadThemeImage];
}

//自定义实例化方法创建button
- (instancetype)initButtonWithImageName:(NSString *)noramlName HighlightImageNmae:(NSString *)hightlightName{
    self = [self init];
    if (self) {
        self.normalName = noramlName;
        self.hightlightName = hightlightName;
    }

    return self;
}


//通过ThemeManager类获得图片

- (void)loadThemeImage
{
    UIImage *normalImage = [[ThemeManager shareInstance] getThemeImageWithImageName:_normalName];
    UIImage *hightlightImage = [[ThemeManager shareInstance] getThemeImageWithImageName:_hightlightName];
    [self setImage:normalImage forState:UIControlStateNormal];
    [self setImage:hightlightImage forState:UIControlStateHighlighted];
}


//重写setNoamalName和setHighlightNormalName
- (void)setNormalName:(NSString *)normalName
{
    if (_normalName != normalName) {
        _normalName = normalName;
    }
    [self loadThemeImage];

}
- (void)setHightlightName:(NSString *)hightlightName
{
    if (_hightlightName != hightlightName) {
        _hightlightName = hightlightName;
    }
    [self loadThemeImage];

}

//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
