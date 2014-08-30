//
//  UserViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-25.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoView.h"
#import "UserModel.h"
#import "WeiboModel.h"
#import "DetailViewController.h"

//请求微博时的tag
NSString    *const     kLoadUserInfoTag         = @"loadUserInfo";
NSString    *const     kLoadUserWeiboNewTag     = @"loadUserWeiboNew";
NSString    *const     kLoadUserWeiboOldTag     = @"loadUserWeiboOld";
NSString    *const     kLoadSpecifyWeiboTag     = @"loadSpecifyWeibo";
//请求微博是param的字典键值

#define kLoadUserWeiboUrl @"https://api.weibo.com/statuses/user_timeline.json"
#define kLoadUserInfoUrl  @"https://api.weibo.com/2/users/show.json"
#define kSpecifyWeiboUrl  @"https://api.weibo.com/2/statuses/show.json"


typedef enum {
    loadUserInfo     = 0,
    loadUserWeiboNew = 1,
    loadUserWeiboOle = 2,
    kLoadSpecify     = 3
}loadUserType;


@interface UserViewController ()

@end
@implementation UserViewController

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
    // Do any additional setup after loading the view from its nib.
    [self loadUserData:loadUserInfo];
    if (self.user != nil) {
        self.user = nil;
        self.weiboTable.data = nil;
    }
    
    _weiboTable = [[WeiboTable alloc] initWithFrame:CGRectMake(0, -180, kDeviceWidth, kDeviceHeight+180) style:UITableViewStylePlain];
    self.weiboTable.weiboTableDelegate = self;
    self.weiboTable.hidden = YES;
    [self.view addSubview:self.weiboTable];
    _userInfoView = [[UserInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
    //添加下拉刷新
    __weak UserViewController *userViewController = self;
    [_weiboTable addHeaderWithCallback:^{
        [userViewController loadUserData:loadUserWeiboNew];
    }];
    //添加上拉加载更多
    [_weiboTable addFooterWithCallback:^{
        [userViewController loadUserData:loadUserWeiboOle];
    }];
    
    
}

#pragma mark - WBHttpRequest
- (void) loadUserData:(NSUInteger)type
{
    NSDictionary *dic = nil;
    NSString *tag = nil;
    NSString *url = nil;
    NSString *accrssToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    switch (type) {
        case loadUserInfo:
            dic = [NSDictionary dictionaryWithObject:self.screenName forKey:@"screen_name"];
            tag = kLoadUserInfoTag;
            url = kLoadUserInfoUrl;
            break;
        case loadUserWeiboNew:
            if (self.sinceId != nil) {
                dic = @{@"screen_name": self.screenName,
                        @"since_id"   : self.sinceId};
            }else{
                dic = @{@"screen_name": self.screenName};
            }
            tag = kLoadUserWeiboNewTag;
            url = kLoadUserWeiboUrl;
            break;
        case loadUserWeiboOle:
            if (self.maxId != nil) {
                dic = @{@"screen_name": self.screenName,
                        @"max_id"     : self.maxId};
            }else{
                dic = @{@"screen_name": self.screenName};
            }
            tag = kLoadUserWeiboOldTag;
            url = kLoadUserWeiboUrl;
            break;
        default:
            break;
    }
    [WBHttpRequest requestWithAccessToken:accrssToken
                                      url:url
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:tag];
    
}
//请求指定的一条微博
- (void)loadSpecifyWeibo
{
    NSDictionary *dic = @{@"id": [[self.user.status objectForKey:@"id"] stringValue]};
    [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                      url:kSpecifyWeiboUrl
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:kLoadSpecifyWeiboTag];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{

    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"链接失败" message:@"链接失败!请重试!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alertView show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [self loadUserData:loadUserInfo];
            break;
        default:
            break;
    }
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    
    NSError *error = nil;

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if ([dic objectForKey:@"error"] != nil) {
        [SVProgressHUD showErrorWithStatus:@"错误的请求！"];
        return;
    }
    if (error != nil) {
        NSLog(@"%@",error);
        return;
    }
    if ([request.tag isEqualToString:kLoadUserInfoTag]) {
        self.user = [[UserModel alloc] initWithDataDic:dic];
        self.userInfoView.user = self.user;
        self.weiboTable.hidden = NO;
        [self.weiboTable reloadData];
        
        //为tableView设置headerView
        self.weiboTable.tableHeaderView = _userInfoView;
        
        if ([[self.user.userId stringValue] isEqualToString:[NSUD objectForKey:kUserID]]) {
        [self loadUserData:loadUserWeiboNew];
        }else{
        [self loadSpecifyWeibo];
        }
    }else if([request.tag isEqualToString:kLoadUserWeiboNewTag]){
        [self WeiboManager:dic tag:request.tag];
    }else if([request.tag isEqualToString:kLoadUserWeiboOldTag]){
        [self WeiboManager:dic tag:request.tag];
    }else if([request.tag isEqualToString:kLoadSpecifyWeiboTag]){
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:dic];
        NSArray *tempArray = @[weibo];
        self.weiboTable.data = tempArray;
        [self.weiboTable reloadData];
    }
}

- (void)WeiboManager:(NSDictionary *)dic tag:(NSString *)tag
{
    NSArray *dataArrays = [dic objectForKey:@"statuses"];
    NSUInteger currentIndex = 0;
    NSUInteger oleWeiboLength = 0;
    if (dataArrays.count == 0) {
        //如果Json没有数组说明没有新的微博，停止下拉刷新直接返回
        [_weiboTable headerEndRefreshing];
        [_weiboTable footerEndRefreshing];
        return;
    }
    //实例化临时存放微博对象的数组
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:dataArrays.count];
    for (NSDictionary *dic in dataArrays) {
        //将Json中的字典转换成WeiboModel对象
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:dic];
        //将微博对象添加到数组中
        [tempArray addObject:weibo];
    }
    NSMutableArray *indexPaths = nil;
    //判断现有的微博数组如果不为空则说明不是获取新的微博
    if (self.weiboArray != nil) {
        if([tag isEqualToString:kLoadUserWeiboOldTag]){
            //把获得的旧的微博数据拼接到现有的微博后面
            //返回的数据第一条和已存在的数据的最后一条是相通的所以要删除返回数据的第一条
            [tempArray removeObjectAtIndex:0];
            currentIndex = self.weiboArray.count;
            [self.weiboArray addObjectsFromArray:tempArray];
            oleWeiboLength = dataArrays.count;
            indexPaths = [[NSMutableArray alloc] initWithCapacity:oleWeiboLength];      //计算indexPaths
            for (NSUInteger i = currentIndex; i < self.weiboArray.count; i ++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }else if([tag isEqualToString:kLoadUserWeiboNewTag]){
            //把已有的微博拼接到新获得的数据中
            [tempArray addObjectsFromArray:self.weiboArray];
            self.weiboArray = tempArray;
        }
    }else{
        self.weiboArray = tempArray;
    }
    
    //将获得的微博数据赋值给微博列表对象的数据
    if (self.weiboArray.count > 0) {
        WeiboModel *firstWeibo = self.weiboArray[0];                //取出最新的一条微博
        self.sinceId = [firstWeibo.weiboId stringValue];            //记录这条微博的sinceId
        WeiboModel *lastWeibo = [self.weiboArray lastObject];       //取出最后一条微博
        self.maxId = [lastWeibo.weiboId stringValue];               //并记录这条微博的maxId
        _weiboTable.data = self.weiboArray;                         //把微博的数据转递给table的数组中
        //刷新数据
        if([tag isEqualToString:kLoadUserWeiboOldTag]){
            //下拉刷新时采用插入的方式
            [self.weiboTable beginUpdates];
            [self.weiboTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.weiboTable endUpdates];
        }else{
            [self.weiboTable reloadData];
        }
        [super dismissSVProcessHUD];                                //结束SVProcessHUD动画
        _weiboTable.hidden = NO;                                    //显示列表
        if ([tag isEqualToString:kLoadUserWeiboNewTag]) {
            [_weiboTable headerEndRefreshing];                      //结束下拉的菜单
        }else if([tag isEqualToString:kLoadUserWeiboOldTag]){
            [_weiboTable footerEndRefreshing];                      //结束上拉加载
        }
    }else{
        NSLog(@"微博数据为空");
    }
    
}










#pragma mark - UIAction
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self showOrHiddenNavigationBar:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self showOrHiddenNavigationBar:NO];
}


#pragma mark - WeiboTableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    detail.weibo = _weiboTable.data[indexPath.row];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        //创建基本的视图
        UIView *userTableHeader = [[UIView alloc] initWithFrame:CGRectZero];
        userTableHeader.backgroundColor = [UIColor clearColor];
        userTableHeader.layer.borderWidth = 1.0f;
        userTableHeader.layer.borderColor = [UIColor grayColor].CGColor;
        userTableHeader.userInteractionEnabled = YES;
        //创建自定义的选中视图
        NSArray *buttonNames = @[@"主页",@"微博"];
        for (int index = 0; index < 2 ; index ++) {
            //调用工厂类创建TabBaritem视图
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = index;
            button.alpha = 0.6f;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [button setTitle:buttonNames[index] forState:UIControlStateNormal];
            [button setTitle:buttonNames[index] forState:UIControlStateHighlighted];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            button.frame = CGRectMake(index*160+((160-40.0)/2.0), 0, 40, 20);
            button.showsTouchWhenHighlighted = YES;
            button.userInteractionEnabled = YES;
            button.tag = index;
            //为每个自定义button添加点击事件
            [button addTarget:self action:@selector(switchTableView:) forControlEvents:UIControlEventTouchUpInside];
            [userTableHeader addSubview:button];
            

        }
        return userTableHeader;
}

- (void)switchTableView:(UIButton *)button
{
    switch (button.tag) {
        case 0:

            break;
        case 1:
            
            break;
            
        default:
            break;
    }
}


//隐藏或显示Navigation
- (void)showOrHiddenNavigationBar:(BOOL)flag
{
    [UIView animateWithDuration: 0.5f
                     animations:^{
                         if (flag) {
                             self.navigationController.navigationBarHidden = YES;
                             self.navigationController.navigationBar.alpha = 0;
                         }else{
                             self.navigationController.navigationBarHidden = NO;
                             self.navigationController.navigationBar.alpha = 1;
                         }
                     }];
}




#pragma mark - loadUserData
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
