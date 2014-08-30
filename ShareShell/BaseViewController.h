//
//  BaseViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"

@interface BaseViewController : UIViewController<WBHttpRequestDelegate>
{
@private
    UIWindow *_statusMessage;
}
@property (nonatomic,assign) BOOL isConnectNet;

- (void)showSVProcessHUDWithMessage:(NSString *)message;
- (void)dismissSVProcessHUD;
- (void)showSVProcessHUDSuccess:(NSString *)message;
- (void)showOrHiddenMessageStatus:(BOOL)show title:(NSString *)title;

@end