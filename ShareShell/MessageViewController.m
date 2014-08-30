//
//  MessageViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-2.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "MessageViewController.h"
#import "FriendsViewController.h"
#import "CommentTableView.h"
#import "WeiboTable.h"
#import "WeiboModel.h"
#import "CommentModel.h"
//HttpUrl
static NSString *const kUrlForCommME = @"https://api.weibo.com/2/comments/to_me.json";
static NSString *const kUrlForAtMe = @"https://api.weibo.com/2/statuses/mentions.json";
//HttpRequestTag
static NSString *const kRequestForAtMeTag = @"RequestForAtMeTag";
static NSString *const kRequestForCommMeTag = @"RequestForCommMeTag";
/*
//定义按钮的类型
typedef enum{
    NavigationBarBtnAtMe    = 0,
    NavigationBarBtnComm    = 1,
    NavigationBarBtnMsg     = 2,
    NavigationBarBtnNotifiy = 3
}NavigationBarBtnType;
*/
@interface MessageViewController ()

@end

@implementation MessageViewController

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
    //创建导航栏上的按钮
    NSArray *imageName = @[@"at.png",
                           @"message.png",
                           @"friend.png",
                           @"fans.png"];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    for (NSUInteger i = 0; i < 4; i ++) {
        UIButton *button = [UIFactory initButtonWithName:imageName[i] HighlightName:imageName[i]];
        button.tag = (100)+i;
        [button addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(10+50*i, 0, 30, 30);
        button.showsTouchWhenHighlighted = YES;
        [titleView addSubview:button];
    }
    self.navigationItem.titleView = titleView;
    
    //创建微博Table的对象
    _weiboTable = [[WeiboTable alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _weiboTable.hidden = YES;
    //下拉刷新
    __weak MessageViewController *weakSelf = self;
    [_weiboTable addHeaderWithCallback:^{
    [weakSelf SendRequestWithRequestTag:(kRequestForAtMeTag)];
    }];
    [_weiboTable addFooterWithCallback:^{
        
    }];
    [self.view addSubview:_weiboTable];
    
    
    _commentTable = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _commentTable.hidden = YES;
    _commentTable.isCommentMe = YES;
    //下拉刷新
    [_commentTable addHeaderWithCallback:^{
    [weakSelf SendRequestWithRequestTag:kRequestForCommMeTag];
    }];
    [_commentTable addFooterWithCallback:^{

    }];
    [self.view addSubview:_commentTable];
    
    
    [self SendRequestWithRequestTag:(kRequestForAtMeTag)];
    
}


//navigationBar按钮响应事件
- (void)clickTheButton:(UIButton *)button
{

    switch (button.tag) {
        case 100:
            [self SendRequestWithRequestTag:(kRequestForAtMeTag)];
            _commentTable.hidden = YES;

            break;
        case 101:
            [self SendRequestWithRequestTag:kRequestForCommMeTag];

            _weiboTable.hidden = YES;
            break;
        case 102:
            [self pushToFriendViewOrFollow:YES];
            break;
        case 103:
            [self pushToFriendViewOrFollow:NO];
            break;
            
        default:
            break;
    }

}

//@我的微博Http请求
- (void)SendRequestWithRequestTag:(NSString *)requestTag
{
    NSDictionary *params = nil;
    NSString *url = nil;
    if ([requestTag isEqualToString:kRequestForAtMeTag]) {
        url = kUrlForAtMe;
    }else if ([requestTag isEqualToString:kRequestForCommMeTag])
    {
        url = kUrlForCommME;
    }
    [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                      url:url
                               httpMethod:@"GET"
                                   params:params
                                 delegate:self
                                  withTag:requestTag];
    
}


- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"dic%@",dic);
    NSArray *tempArray = nil;
    if ([request.tag isEqualToString:kRequestForAtMeTag]) {
        tempArray = [dic objectForKey:@"statuses"];
        [self parseDataForWeiboTable:tempArray];
    }else if ([request.tag isEqualToString:kRequestForCommMeTag]){
        tempArray = [dic objectForKey:@"comments"];
        [self parseDataForCommentTable:tempArray];
    
    }

    
}

- (void)parseDataForWeiboTable:(NSArray *)tempArray
{
    if (tempArray.count == 0) {

                [SVProgressHUD showErrorWithStatus:@"没有消息"];
        return;
    }
    NSDictionary *weiboDic = nil;
    NSMutableArray *weiboArray = [NSMutableArray arrayWithCapacity:tempArray.count];
    for (weiboDic in tempArray) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboDic];
        [weiboArray addObject:weibo];
    }
    
    
    if (weiboArray != nil || weiboArray.count != 0 ) {
        self.weiboTable.data = weiboArray;
        self.weiboTable.hidden = NO;
        [self.weiboTable reloadData];
        [self.weiboTable headerEndRefreshing];
        
    }else{
        return;
    }

}

- (void)parseDataForCommentTable:(NSArray *)tempArray
{
    if (tempArray.count == 0) {

        [SVProgressHUD showErrorWithStatus:@"没有消息"];
        return;
    }

    NSDictionary *commentDic = nil;
    NSMutableArray *commentArray = [NSMutableArray arrayWithCapacity:tempArray.count];
    for (commentDic in tempArray) {
        CommentModel *weibo = [[CommentModel alloc] initWithDataDic:commentDic];
        [commentArray addObject:weibo];
    }
    if (commentArray != nil || commentArray.count != 0 ) {
        self.commentTable.commmentData = commentArray;
        self.commentTable.hidden = NO;
        [self.commentTable reloadData];
        [self.commentTable headerEndRefreshing];
        
    }else{
        return;
    }


}


- (void)pushToFriendViewOrFollow:(BOOL)guid
{
    FriendsViewController *friendCtrl = [[FriendsViewController alloc] init];
    
    BaseNavigationController *navigationCtrl = [[BaseNavigationController alloc] initWithRootViewController:friendCtrl];
    if (guid) {
        friendCtrl.isFriend = YES;
        friendCtrl.title = @"我关注的";
    }else{
        friendCtrl.isFriend = NO;
        friendCtrl.title = @"关注我的";
    }
    [self presentViewController:navigationCtrl animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
