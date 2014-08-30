//
//  BaseLabel.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-17.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickTheLabel)(void);

@interface BaseLabel : UILabel<UITextFieldDelegate>

@property (nonatomic,strong)ClickTheLabel clickTheLabel;
@end
