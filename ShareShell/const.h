//
//  const.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-24.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#ifndef ShareShell_const_h
#define ShareShell_const_h

//设备的宽高
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height


//---------SinaWeiBo OAuthu 2.0----------
#define kAppKey @"3492901857"
#define kAppSecret @"be97b3a3a5bbdc15d992688835c30c2a"
#define kRedirectURI @"https://api.weibo.com/oauth2/default.html"



//令牌和用户信息ID
#define kAccessToken @"accessToken"
#define kUserID @"userID"


//NSUserDefaults
#define NSUD [NSUserDefaults standardUserDefaults]

//登录选项
#define kEverLaunched @"everLaunched"
#define kFirstLaunch  @"firstLaunch"

//主题键名
#define kDefaultTheme @"蓝色"
#define kThemeName @"kThemeName"
#define kCurrentTheme [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName]


//变更主题通知名称
#define kThemeDidChangeNofication @"kThemeDidChangeNofication"


#define kViewBackGroundImage @"userinfobackground.jpg"






#endif
