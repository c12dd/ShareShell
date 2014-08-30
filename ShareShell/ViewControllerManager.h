//
//  ViewControllerManager.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-24.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger,ViewControllerType){
    ViewControllerTypeMain,
    ViewControllerTypeGuide,
    ViewControllerTypeLogin
};

@interface ViewControllerManager : NSObject

+ (void)getViewControllerWithType:(ViewControllerType)type;
@end
