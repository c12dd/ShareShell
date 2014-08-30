//
//  BaseViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"
NSUInteger const messageLabelTag = 2014;
@interface BaseViewController ()

@end
@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIFactory initButtonWithName:@"nav_back_white.png" HighlightName:@"nav_back_black.png"];
        backButton.frame = CGRectMake(0, 0, 20, 15);
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
    
    
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            self.isConnectNet = NO;
            break;
        case ReachableViaWWAN:
            // 使用3G网络
        case ReachableViaWiFi:
            // 使用WiFi网络
            self.isConnectNet = YES;
            break;
    }

    
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    
    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"链接失败" message:@"链接失败!请重试!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    
    [alertView show];
    [self showOrHiddenMessageStatus:NO title:@"请求网络失败"];
}

#pragma mark - 
#pragma mark - 重写UIViewController的setTitle
- (void)setTitle:(NSString *)title
{
        [super setTitle:title];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        self.navigationItem.titleView = titleLabel;

}

//显示或隐藏状态栏的提示
- (void)showOrHiddenMessageStatus:(BOOL)show title:(NSString *)title
{
    if (_statusMessage == nil) {
        _statusMessage = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
        _statusMessage.windowLevel = UIWindowLevelStatusBar;
        _statusMessage.backgroundColor = [UIColor blackColor];
        
        UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
        message.textAlignment = NSTextAlignmentCenter;
        message.font = [UIFont systemFontOfSize:13.0f];
        message.textColor = [UIColor whiteColor];
        message.backgroundColor = [UIColor clearColor];
        message.tag = messageLabelTag;
        [_statusMessage addSubview:message];
    }
    UILabel *label = (UILabel *)[_statusMessage viewWithTag:messageLabelTag];
    if (show) {
        label.text = title;
        _statusMessage.hidden = NO;
    }else{
        label.text = title;
        [self performSelector:@selector(hiddenMessageStatus) withObject:nil afterDelay:2.0f];
    }
    
}

- (void)hiddenMessageStatus
{
    _statusMessage.hidden = YES;
}


- (void)showSVProcessHUDWithMessage:(NSString *)message
{
    [SVProgressHUD showWithStatus:message];

}

- (void)showSVProcessHUDSuccess:(NSString *)message
{
    [SVProgressHUD showSuccessWithStatus:message];
}

- (void)dismissSVProcessHUD
{
    [SVProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    WBHttpRequest *request = [[WBHttpRequest alloc] init];
    [request disconnect];
    [request setDelegate:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
