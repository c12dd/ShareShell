//
//  ThemeManager.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-15.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "ThemeManager.h"




@implementation ThemeManager

#pragma mark - 
#pragma mark － GCD单例
+ (ThemeManager *)shareInstance
{
    static ThemeManager *_instance = nil;
    static dispatch_once_t oneInstance ;
    dispatch_once(&oneInstance, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
//自身实例化时，加载主题的plist文件
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ThemeInfo" ofType:@"plist"];
        _themPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        
    }
    return self;
}


//获得主题的完整路径
- (NSString *)getThemePath
{
    //获得包的根目录
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    //获得主题包的目录,_themPlist为字典，保存着主题的相对路径
    NSString *themePath = [_themPlist objectForKey:_themeName];
    //获得完整的路径
    NSString *path = [resourcePath stringByAppendingPathComponent:themePath];
    
    
    return path;
}



//获得选中主题的图片
- (UIImage *)getThemeImageWithImageName:(NSString *)imageName
{
    //获得当前主题的根目录
    NSString *themePath = [self getThemePath];
    //获得具体图片的路径
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    //根据图片路径获得图片

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    
    return image;
    
}


@end
