//
//  UserImageView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-26.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//


/*
 所有用户头像继承的imageView创建自定义block能够实现点击头像进入个人详细页面
 */
#import <UIKit/UIKit.h>
typedef void(^HeadImageTouchBlock)(void);

@interface UserImageView : UIImageView


@property (nonatomic,copy) HeadImageTouchBlock headImageTouchBlock;
@end
