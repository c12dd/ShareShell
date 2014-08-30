//
//  BaseTabBarItemView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-15.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseImageView : UIImageView




@property (nonatomic , copy) NSString *imageName;


- (BaseImageView *)initWithImageName:(NSString *)imageName;

@end
