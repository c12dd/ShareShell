//
//  MainViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotifyCountModel;
@class CHTumblrMenuView;
@interface MainViewController : UITabBarController<WBHttpRequestDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
@private
    UIImageView      *_tabBarView;
    UIImageView      *_selectImage;
    CHTumblrMenuView *_menuView;
}
@property(nonatomic,strong)NSString         *accessToken;
@property(nonatomic,strong)NotifyCountModel *notifies;
@property(nonatomic,strong)NSTimer          *timer;
@property(nonatomic,strong)UIImageView      *notifyView;
@end
