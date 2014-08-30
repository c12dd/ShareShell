//
//  UIFactory.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-16.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "UIFactory.h"
#import "ThemeManager.h"
#import "BaseImageView.h"
@implementation UIFactory

//工厂类创建ImageView
+ (BaseImageView *)initWithImageName:(NSString *)imageName
{
    BaseImageView *itemView = [[BaseImageView alloc] initWithImageName:imageName];
    return  itemView;
}



+ (ThemeButton *)initButtonWithName:(NSString *)normalName HighlightName:(NSString *)highlightName
{
    ThemeButton *button = [[ThemeButton alloc] initButtonWithImageName:normalName HighlightImageNmae:highlightName];
    return button;
}

@end
