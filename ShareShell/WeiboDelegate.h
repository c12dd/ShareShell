//
//  WeiboDelegate.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-25.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboDelegate : NSObject<WeiboSDKDelegate>

//用户令牌
@property (nonatomic , strong) NSString *accessToken;
@property (nonatomic , strong) NSString *userID;


+ (void)loginRequest;
@end
