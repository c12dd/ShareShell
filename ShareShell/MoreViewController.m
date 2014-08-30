//
//  MoreViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "UIImageView+WebCache.h"
#import "ViewControllerManager.h"
#import "NearWeiboViewController.h"
#import "UserViewController.h"
#import "UserImageView.h"
#import "UserModel.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"More";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCustomView];
}

#pragma mark -
#pragma mrak - 初始化用户自定义视图
-(void)initCustomView
{
    [self requestPersonInfoWithUid];
    //列表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.alpha = 0.8f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = self.tableViewHeader;
}



- (void)requestPersonInfoWithUid
{
    NSDictionary *dic = @{@"uid": [NSUD objectForKey:kUserID]};
    [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                      url:@"https://api.weibo.com/2/users/show.json"
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:nil];

}


- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
    if (error != nil) {
        NSLog(@"%@",error);
    }
    
    
    [self refreshView:tempDic];

}

- (void)refreshView:(NSDictionary *)tempDic
{
    _user = [[UserModel alloc] initWithDataDic:tempDic];
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:_user.avatar_large]];
    self.name.text = _user.screenName;
    self.intro.text = [NSString stringWithFormat:@"简介:%@",_user.description];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToInfomation:)];
    [self.tableViewHeader addGestureRecognizer:tapGesture];
}

- (void)pushToInfomation:(UITapGestureRecognizer *)tapGesture
{
    UserViewController *userViewCtrl = [[UserViewController alloc] init];
    userViewCtrl.screenName = self.user.screenName;

    [self.navigationController pushViewController:userViewCtrl animated:YES];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 1;
//    if (section == 1) {
//        return 2;
//    }
    return row;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    

    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
            cell.textLabel.text = @"色彩";
            }
            break;
        case 1:
            if (indexPath.row == 0) {
            cell.textLabel.text = @"周边的微博";
            }

            break;
        case 2:
            break;
        case 3:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"退出登录";
            }
            break;
        default:
            break;
    }
    
    


    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ThemeViewController *themeViewController = [[ThemeViewController alloc] init];
            [self.navigationController pushViewController:themeViewController animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NearWeiboViewController *near = [[NearWeiboViewController alloc] init];
            [self.navigationController pushViewController:near animated:YES];
            
        }
        
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            [self logout];
        }
    }
}

- (void)logout
{
    
    [ WeiboSDK logOutWithToken:[NSUD objectForKey:kAccessToken] delegate:self withTag:nil];
    [NSUD removeObjectForKey:kAccessToken];
    [NSUD removeObjectForKey:kUserID];
    [UIView animateWithDuration:0.3f animations:^{
    [ViewControllerManager getViewControllerWithType:ViewControllerTypeLogin];
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
