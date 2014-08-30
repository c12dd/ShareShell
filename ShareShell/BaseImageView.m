//
//  BaseTabBarItemView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-15.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseImageView.h"
#import "ThemeManager.h"
@implementation BaseImageView


//根据图片名初始化ImageView
- (BaseImageView *)initWithImageName:(NSString *)imageName
{
    self = [self init];
    if (self != nil) {
        self.imageName = imageName;
    }
    return self;
}

//重写init方法添加监听通知
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

#pragma mark - 
#pragma mark - 监听通知响应的方法
- (void)themeNotification
{
    [self loadThemeImage];
}

//根据图片名获得图片信息并复制给imageView
- (void)loadThemeImage
{
    //获得图片
    UIImage *image = [[ThemeManager shareInstance] getThemeImageWithImageName:_imageName];
    //将图片赋予对应的image
    self.image = image;

}



#pragma mark - 
#pragma mark - 重写setter方法
//重写了settter方法，并在此处调用了loadThemImage方法
- (void)setImageName:(NSString *)imageName
{
    if (_imageName!=imageName) {
        _imageName = imageName;
    }
    //加载设置imageView的方法
    [self loadThemeImage];
}


#pragma mark -
#pragma mark - 在dealloc中移除监听
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
