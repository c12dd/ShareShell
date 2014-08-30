//
//  AppDelegate.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-10.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "AppDelegate.h"
#import "ThemeManager.h"
#import "WeiboDelegate.h"
#import "ViewControllerManager.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setTheme];
    [self initLaunchOpition];
    /*
     微博SDK测试模式
     */
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    if ([NSUD boolForKey:kFirstLaunch]) {
        [ViewControllerManager getViewControllerWithType:ViewControllerTypeGuide];
    }else{
        if ([NSUD objectForKey:kAccessToken] != nil) {
            [ViewControllerManager getViewControllerWithType:ViewControllerTypeMain];
        }else{
            [ViewControllerManager getViewControllerWithType:ViewControllerTypeGuide];
        }
    
    }
    return YES;
}


//程序启启动时检测使用的主题
- (void)setTheme
{
    if (kCurrentTheme == nil) {
        [ThemeManager shareInstance].themeName = kDefaultTheme;
    }else{
        [ThemeManager shareInstance].themeName = kCurrentTheme;
    }
}


#pragma mark -
#pragma mark - OAuth 2.0授权方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
        WeiboDelegate *weiboDelegate = [[WeiboDelegate alloc] init];
    return [WeiboSDK handleOpenURL:url delegate:weiboDelegate];
}


#pragma mark - initLaunchOption
- (void)initLaunchOpition
{
    if ([NSUD boolForKey:kEverLaunched]) {
        [NSUD setBool:NO forKey:kFirstLaunch];
    }else{
        [NSUD setBool:YES forKey:kEverLaunched];
        [NSUD setBool:YES forKey:kFirstLaunch];
    
    }
    [NSUD synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
