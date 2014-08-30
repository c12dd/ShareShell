//
//  WeiboDelegate.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-25.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboDelegate.h"
#import "ViewControllerManager.h"
@implementation WeiboDelegate

+ (void)loginRequest
{
    WBAuthorizeRequest *request =[WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}



//OAuth2.0授权登录后响应的结果

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败"
                                                        message:@"登录失败！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        
        [alert show];
        
    }else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
                //获取accessToken
        self.accessToken = [(WBAuthorizeResponse *)response accessToken];
        if (self.accessToken != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功"
                                                            message:@"欢迎回来！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];

                [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败"
                                                            message:@"登录失败！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            
            [alert show];

        }
        //获取userID
        self.userID = [(WBAuthorizeResponse *)response userID];
        //轻量级保存令牌和用户信息
        [NSUD setObject:_accessToken forKey:kAccessToken];
        [NSUD setObject:_userID forKey:kUserID];
        [NSUD synchronize];
        

        if (self.accessToken != nil) {
        [ViewControllerManager getViewControllerWithType:ViewControllerTypeMain];
        }

        
    }
}

@end
