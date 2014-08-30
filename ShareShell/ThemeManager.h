//
//  ThemeManager.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-15.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject


//主题的plist文件，用于加载plist文件
@property (nonatomic,copy) NSDictionary *themPlist;

//主题的名称，当各个控件获得变更主题通知时，会调用该类设置主题名的方法，并获取对应主题包的文件地址，并返回给各控件的继承类
@property (nonatomic,copy) NSString *themeName;


/*
    GCD方式创建单例

 */
+ (ThemeManager *)shareInstance;

//根据图片名获得图片
- (UIImage *)getThemeImageWithImageName:(NSString *)imageName;
@end
