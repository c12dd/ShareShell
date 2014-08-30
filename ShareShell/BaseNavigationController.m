//
//  BaseNavigationController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"


#define kNavigationBarBackgroundImage @"nav_bg_all_st.png"
@interface BaseNavigationController ()
@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification) name:kThemeDidChangeNofication object:nil];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadThemeImage];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bakcToHomeSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    

}


#pragma mark - 
#pragma mark - 通过主题管理类直接获取navigationbar的背景图片
- (void)loadThemeImage
{
    //更改背景图片
    UIImage *backgroundImaga = [self getNavigationImageWithImageName:kNavigationBarBackgroundImage];
    [self.navigationBar setBackgroundImage:backgroundImaga forBarMetrics:UIBarMetricsDefault];
}

-(UIImage *)getNavigationImageWithImageName:(NSString *)imageName
{
    
    //直接调用ThemeManager类来的方法获得图片信息
    UIImage *image = [[ThemeManager shareInstance] getThemeImageWithImageName:imageName];
    return  image;
    
}


#pragma mark - 
#pragma mark - 监听通知响应的方法
- (void)themeNotification
{
    [self loadThemeImage];
}

#pragma mark - 
#pragma mark - 左划返回手势
- (void)bakcToHomeSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (self.viewControllers.count >1) {
        [self popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 
#pragma mark - 在dealloc中移除监听
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
