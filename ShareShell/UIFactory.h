//
//  UIFactory.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-16.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseImageView.h"
#import "ThemeButton.h"
@interface UIFactory : NSObject

//类方法创建ImageView
+ (BaseImageView *)initWithImageName:(NSString *)imageName;
+ (ThemeButton *)initButtonWithName:(NSString *)normalName HighlightName:(NSString *)highlightName;
@end
