//
//  ThemeButton.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//自定义按钮正常和高亮的图片名
@property(nonatomic,strong)NSString *normalName;
@property(nonatomic,strong)NSString *hightlightName;

- (instancetype)initButtonWithImageName:(NSString *)noramlName HighlightImageNmae:(NSString *)hightlightName;

@end
