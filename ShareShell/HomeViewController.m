//
//  HomeViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "HomeViewController.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboTable.h"
#import "MainViewController.h"
#import "DetailViewController.h"
#import "TSActionSheet.h"
#import "Reachability.h"


//请求微博时的tag
static NSString    *const     kLoadWeiboRefreshTag     = @"loadWeiboRefresh";
static NSString    *const     kLoadWeiboNewTag         = @"loadWeiboNew";
static NSString    *const     kLoadWeiboOldTag         = @"loadWeiboOld";
//请求微博是param的字典键值
static NSString    *const     kSince_id        = @"since_id";
static NSString    *const     kMax_id          = @"max_id";

static NSString    *const kUrlForFriend =  @"https://api.weibo.com/2/statuses/friends_timeline.json";
static NSString    *const kUrlForPublic =  @"https://api.weibo.com/2/statuses/public_timeline.json";
static NSString    *const kUrlForHot =  @"https://api.weibo.com/2/suggestions/favorites/hot.json";

typedef enum {
    loadWeiboTypeNew = 0,
    loadWeiboTypeOld = 1,
    loadWeiboTypeRefresh = 2
}loadWeiboType;

@interface HomeViewController ()

@end

@implementation HomeViewController



#pragma mark - initMethod

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //刷新选项
       UIButton *button = [UIFactory initButtonWithName:@"pocket_F.png" HighlightName:@"pocket_F.png"];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button addTarget:self action:@selector(showRefreshMenu:event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    self.accessToken =[[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    [super showSVProcessHUDWithMessage:@"正在加载微博。。。"];
    [self initView];
    
    
    


}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.isConnectNet) {
        [SVProgressHUD showErrorWithStatus:@"无法连接网络！"];
        self.weiboArray= [[DataBaseManager shareInstance] queryWeiboModerFromDataBase];
        if (self.weiboArray.count == 0) {
            return;
        }
        self.weiboTable.data = self.weiboArray;
        self.weiboTable.hidden = NO;
        [super dismissSVProcessHUD];
        [self.weiboTable reloadData];
    }else
    {
        if (self.weiboArray.count > 0) {
            return;
        }
            _url = [NSString stringWithFormat:kUrlForFriend];
            if (self.accessToken) {
                [self loadWeiboRequest:(loadWeiboTypeNew) RequestTag:kLoadWeiboNewTag];
            }
    }

}

- (void)initView
{
    _weiboTable = [[WeiboTable alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight ) style:UITableViewStylePlain];
    _weiboTable.hidden = YES;
    _weiboTable.weiboTableDelegate = self;
    //添加下拉刷新
    __weak HomeViewController *weakSelf = self;
    [_weiboTable addHeaderWithCallback:^{
        
        if (weakSelf.isConnectNet) {
            if (weakSelf.weiboArray.count > 20) {
                [weakSelf loadWeiboRequest:loadWeiboTypeRefresh RequestTag:kLoadWeiboRefreshTag];
            }else{
                [weakSelf loadWeiboRequest:loadWeiboTypeNew RequestTag:kLoadWeiboNewTag];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"无法连接网络！"];
            [weakSelf.weiboTable headerEndRefreshing];
        }

    }];
    //添加上拉加载更多
    [_weiboTable addFooterWithCallback:^{
        if (weakSelf.isConnectNet) {
            [weakSelf loadWeiboRequest:loadWeiboTypeOld RequestTag:kLoadWeiboOldTag];
        }else{
            [SVProgressHUD showErrorWithStatus:@"无法连接网络！"];
            [weakSelf.weiboTable footerEndRefreshing];
            return ;
        }

    }];
    [self.view addSubview:_weiboTable];
    
    
}



#pragma mark - ActionMethod
- (void)showRefreshMenu:(UIBarButtonItem *)sender  event:(UIEvent *)event
{
    [SVProgressHUD dismiss];
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@""];    
    actionSheet.layer.contents = (id)([[ThemeManager shareInstance] getThemeImageWithImageName:@"tabBar_bg_all.png"].CGImage);
    actionSheet.popoverBaseColor = [UIColor whiteColor];
    actionSheet.titleShadow = NO;
    actionSheet.buttonGradient = NO;
    [actionSheet addButtonWithTitle:@"关注人的微博"
                              color:[UIColor clearColor]
                         titleColor:[UIColor whiteColor]
                        borderWidth:0.1f
                        borderColor:[UIColor grayColor]
                              block:^{
                                  _url = kUrlForFriend;
                                  _sinceId = nil;
                                  _maxId = nil;
                                  self.weiboArray = nil;
                                  [self loadWeiboRequest:loadWeiboTypeRefresh RequestTag:kLoadWeiboRefreshTag];
                              }];
    
    [actionSheet addButtonWithTitle:@"公共微博"
                              color:[UIColor clearColor]
                         titleColor:[UIColor whiteColor]
                        borderWidth:0.1f
                        borderColor:[UIColor grayColor]
                              block:^{
                                  _url = kUrlForPublic;
                                  _sinceId = nil;
                                  _maxId = nil;
                                  self.weiboArray = nil;
                                  [self loadWeiboRequest:loadWeiboTypeRefresh RequestTag:kLoadWeiboRefreshTag];
                              }];
    
    [actionSheet showWithTouch:event];
}


/**
 微博封装Http请求的消息结构
 WBHttpRequest
 */
- (void)loadWeiboRequest:(NSUInteger)loadWeiboType RequestTag:(NSString *)RequestTag
{
    
    
    NSDictionary *dic = nil;
    switch (loadWeiboType) {
        case 0:
            //判断是否存储了sinceId
            if (self.sinceId != nil) {
                dic = [NSMutableDictionary dictionaryWithObject:self.sinceId forKey:kSince_id];
            }
            break;
        case 1:
            //判断是否存储了sinceId
            if (self.maxId != nil) {
                dic = [NSMutableDictionary dictionaryWithObject:self.maxId forKey:kMax_id];
            }
        case 2:
            
            break;
            
        default:
            break;
    }
    
    //字典用于请求是的参数，参数的键名参考API文档
    //https://api.weibo.com/2/statuses/public_timeline.json
    //https://api.weibo.com/2/statuses/friends_timeline.json
    [WBHttpRequest requestWithAccessToken:self.accessToken
                                      url:_url
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:RequestTag];
}



#pragma mark - WBHttpRequestDelegate

/**
 收到一个来自微博Http请求的网络返回
 @param result 请求返回结果
 */

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSMutableDictionary *dic = nil;
    if ([_url isEqualToString:kUrlForHot]) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        dic = [NSMutableDictionary dictionaryWithObject:array forKey:@"statuses"];
        
    }else{
        //json解析数据
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    //根据request的tag值来判断进行哪些数据处理
    if ([request.tag isEqualToString:kLoadWeiboNewTag]||[request.tag isEqualToString:kLoadWeiboRefreshTag]) {
        
        [self WeiboManager:dic RequestTag:request.tag];
        
    }else if([request.tag isEqualToString:kLoadWeiboOldTag]){
        
        [self WeiboManager:dic RequestTag:request.tag];
    }
}



- (void)WeiboManager:(NSDictionary *)dic RequestTag:(NSString *)RequestTag
{
    NSArray *dataArrays = [dic objectForKey:@"statuses"];
    
    NSUInteger currentIndex = 0;
    NSUInteger oleWeiboLength = 0;
    if (dataArrays.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有新微博！"];

        NSLog(@"没有新微博");
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
    if (self.weiboArray.count != 0) {
        if([RequestTag isEqualToString:kLoadWeiboOldTag]){
            //把获得的旧的微博数据拼接到现有的微博后面
            //返回的数据第一条和已存在的数据的最后一条是相通的所以要删除返回数据的第一条
            [tempArray removeObjectAtIndex:0];
            currentIndex = self.weiboArray.count;
            [self.weiboArray addObjectsFromArray:tempArray];
            oleWeiboLength = dataArrays.count;
            indexPaths = [[NSMutableArray alloc] initWithCapacity:oleWeiboLength];
            //计算indexPaths
            for (NSUInteger i = currentIndex; i < self.weiboArray.count; i ++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }else if([RequestTag isEqualToString:kLoadWeiboNewTag]){
            //把已有的微博拼接到新获得的数据中
            [tempArray addObjectsFromArray:self.weiboArray];
            self.weiboArray = tempArray;
        }else if([RequestTag isEqualToString:kLoadWeiboRefreshTag]){
            self.weiboArray = tempArray;
        }
    }else{
        self.weiboArray = tempArray;
        if (tempArray.count > 0) {
            //向数据库中存储数据
            [[DataBaseManager shareInstance] deleteAll];
            [[DataBaseManager shareInstance] saveWeiboDataToDataBaseWithWeiboArray:self.weiboArray];
        }


    }
    
    //将获得的微博数据赋值给微博列表对象的数据
    if (self.weiboArray.count > 0) {
        WeiboModel *firstWeibo = self.weiboArray[0];                //取出最新的一条微博
        self.sinceId = [firstWeibo.weiboId stringValue];            //记录这条微博的sinceId
        WeiboModel *lastWeibo = [self.weiboArray lastObject];       //取出最后一条微博
        self.maxId = [lastWeibo.weiboId stringValue];               //并记录这条微博的maxId
        _weiboTable.data = self.weiboArray;                         //把微博的数据转递给table的数组中
        //刷新数据
        if([RequestTag isEqualToString:kLoadWeiboOldTag]){
            //下拉刷新时采用插入的方式
            [self.weiboTable beginUpdates];
            [self.weiboTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.weiboTable endUpdates];
        }else{
            [self.weiboTable reloadData];
        }
        [super dismissSVProcessHUD];                                //结束SVProcessHUD动画
        _weiboTable.hidden = NO;                                    //显示列表
        if ([RequestTag isEqualToString:kLoadWeiboNewTag]||[RequestTag isEqualToString:kLoadWeiboRefreshTag]) {
            [_weiboTable headerEndRefreshing];                      //结束下拉的菜单
            //隐藏HomeViewController中的count标记
            MainViewController *mainViewController = (MainViewController *)self.tabBarController;
            mainViewController.notifyView.hidden = YES;
            //提示信息
            [SVProgressHUD showSuccessWithStatus:@"加载完成！"];
        }else if([RequestTag isEqualToString:kLoadWeiboOldTag]){
            [_weiboTable footerEndRefreshing];                      //结束上拉加载
        }
    }else{
        NSLog(@"微博数据为空");
    }
    
    [_weiboTable reloadData];
    [_weiboTable footerEndRefreshing];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
}



/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"链接失败" message:@"链接失败!请重试!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alertView show];
    [SVProgressHUD dismiss];
    [_weiboTable headerEndRefreshing];
}




#pragma mark - WeiboTableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    detail.weibo = _weiboTable.data[indexPath.row];
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告");
}

@end
