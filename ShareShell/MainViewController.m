//
//  MainViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "BaseNavigationController.h"
#import "SendViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"
#import "NotifyCountModel.h"
#import "WeiboTable.h"
#import "CHTumblrMenuView.h"

#pragma mark -
#pragma mark - tabBar define
#define kTabBarBackGround @"tabBar_bg_all.png"
#define kTabBarHight 49

#pragma mark -
#pragma mark - selectImage define
#define kSelectImage @"selectItem.png"
#define kSelectImageHeight 45
#define kSelectImageWeight 50

#pragma mark -
#pragma mark - tabBarItem define
#define ktabBarItemHeight 30
#define ktabBarItemweight 30


#define kNotifyCount @"notifyCount"
#define kCountLabelTag 1000

@interface MainViewController ()

//私有方法，初始化子视图控制器
- (void)initViewController;

- (void)createCustomTabBar;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBar.hidden = YES;
        self.tabBar.userInteractionEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initViewController];
    [self createCustomTabBar];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:180.0f target:self selector:@selector(loadNotifyCount) userInfo:nil repeats:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - initViewMethod 创建子视图控制器
//初始化子视图控制器
- (void)initViewController
{
    //创建子视图控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    MessageViewController *message = [[MessageViewController alloc] init];
    MoreViewController *more = [[MoreViewController alloc] init];
    
    //存放试图控制器的数组
    NSArray *controllersArray = @[home,message,more];
    //创建用于存放navigation控制器的数组
    NSMutableArray *navigationsArray = [[NSMutableArray alloc] initWithCapacity:5];
    //for循环为每个视图创建navigation控制器
    for (UIViewController *viewController in controllersArray) {
        BaseNavigationController *navigationController = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        navigationController.delegate = self;
        //将每个视图创建navigation控制器添加到navigation的数组中
        [navigationsArray addObject:navigationController];
        
    }
    self.viewControllers = navigationsArray;
    
    
}



#pragma mark - 创建自定义tabBar
- (void)createCustomTabBar
{    //创建基本的tabbar视图
    _tabBarView = [UIFactory initWithImageName:kTabBarBackGround];
    _tabBarView.frame =CGRectMake(0, kDeviceHeight-kTabBarHight, kDeviceWidth, kTabBarHight);
    _tabBarView.userInteractionEnabled = YES;
    
    
    //创建自定义的选中视图
    _selectImage = [UIFactory initWithImageName:kSelectImage];
    _selectImage.frame = CGRectMake(15, 2, kSelectImageWeight, kSelectImageHeight);
    _selectImage.layer.cornerRadius     = 10.0f;
    _selectImage.layer.masksToBounds    = YES;
    
    [_tabBarView addSubview:_selectImage];
    NSArray *itemIcon = @[@"home.png",@"Chat.png",@"Gear.png",@"Discover.png"];
    for (int index = 0; index < 4 ; index ++) {
        //调用工厂类创建TabBaritem视图
        UIImageView *itemsView = [UIFactory initWithImageName:itemIcon[index]];
        itemsView.tag = index;
        //指定大小
        itemsView.frame = CGRectMake(25+index*80, (19/2.0), ktabBarItemweight, ktabBarItemHeight);
        itemsView.userInteractionEnabled = YES;
        
        
        
        //为每个自定义tabBarItem添加点击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewController:)];
        [itemsView addGestureRecognizer:tapGesture];
        [_tabBarView addSubview:itemsView];
    }

    
    
    [self.view addSubview:_tabBarView];
}


#pragma mark - loadData
- (void)loadNotifyCount
{
    NSDictionary *dic = nil;
    self.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    if (self.accessToken == nil) {
        NSLog(@"请重新登录");
        return;
    }else{
        //将本类中的accrssToken值传入字典中
        dic = [NSDictionary dictionaryWithObject:self.accessToken forKey:kAccessToken];
    }
    NSString *getNotifyUrl = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    [WBHttpRequest requestWithAccessToken:self.accessToken
                                      url:getNotifyUrl
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:kNotifyCount];
}



- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    self.notifies = [[NotifyCountModel alloc] initWithDataDic:dic];
    [self showNotifyCount:[self.notifies.status intValue]];
    
    
    
}

#pragma mark - NotifyCount
- (void)showNotifyCount:(int)count
{
    if (_notifyView ==nil) {
        _notifyView = [UIFactory initWithImageName:@"selectItem.png"];
        _notifyView.backgroundColor     = [UIColor blueColor];
        _notifyView.alpha               = 0.5f;
        _notifyView.frame               = CGRectMake(64-20, 0, 20, 20);
        _notifyView.layer.cornerRadius  = 10.0f;
        _notifyView.layer.masksToBounds = YES;
        [_tabBarView addSubview:_notifyView];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _notifyView.width, _notifyView.height)];
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.tag           = kCountLabelTag;
        countLabel.font             = [UIFont boldSystemFontOfSize:10];
        countLabel.textColor        = [UIColor whiteColor];
        [_notifyView addSubview:countLabel];
    }
    UILabel *label = (UILabel *)[_notifyView viewWithTag:kCountLabelTag];
    if (count == 0) {
        _notifyView.hidden = YES;
    }else{
        label.text = [NSString stringWithFormat:@"%d",count];
        _notifyView.hidden = NO;
    }
    
}


#pragma mark - 主页面的视图切换
- (void)changeViewController:(UITapGestureRecognizer *)tabGesture
{
    UIView *view = [tabGesture view];
    //selectImage切换动画
    [UIView beginAnimations:nil context:NULL];
    _selectImage.frame = CGRectMake(15+view.tag*80, 2, 50, 45);
    [UIView commitAnimations];
    NSLog(@"%ld",(long)view.tag);
    
    //重复点击主页面刷新微博
    if (view.tag == self.selectedIndex && view.tag == 0) {
        //取出主页面的导航控制器
        UINavigationController *naigation = self.viewControllers[0];
        HomeViewController *homeViewontroller = [naigation.viewControllers objectAtIndex:0];
        [homeViewontroller.weiboTable headerBeginRefreshing];
    }
    //更换页面视图控制器

    switch (view.tag) {
        case 0:
        case 1:
        case 2:
            self.selectedIndex = view.tag;
            break;
        case 3:
            [self showMenu];
        default:
            break;
    }
    
    
    
    
    
}


#pragma mark - 中间的菜单
- (void)showMenu
{
    __weak MainViewController *weakSelf = self;
    _menuView= [[CHTumblrMenuView alloc] init];
    [_menuView addMenuItemWithTitle:@"微博" andIcon:[UIImage imageNamed:@"post_type_bubble_text.png"] andSelectedBlock:^{
        SendViewController *sendCtrl = [[SendViewController alloc] init];
        BaseNavigationController *navigationCtrl = [[BaseNavigationController alloc] initWithRootViewController:sendCtrl];
        [weakSelf presentViewController:navigationCtrl animated:YES completion:^{
            
        }];
        
    }];
    [_menuView addMenuItemWithTitle:@"Photo" andIcon:[UIImage imageNamed:@"post_type_bubble_photo.png"] andSelectedBlock:^{
        
        [weakSelf selectCamera];
        
    }];
//    [_menuView addMenuItemWithTitle:@"Quote" andIcon:[UIImage imageNamed:@"post_type_bubble_quote.png"] andSelectedBlock:^{
//        NSLog(@"Quote selected");
//        
//    }];
//    [_menuView addMenuItemWithTitle:@"Link" andIcon:[UIImage imageNamed:@"post_type_bubble_link.png"] andSelectedBlock:^{
//        NSLog(@"Link selected");
//        
//    }];
//    [_menuView addMenuItemWithTitle:@"Chat" andIcon:[UIImage imageNamed:@"post_type_bubble_chat.png"] andSelectedBlock:^{
//        NSLog(@"Chat selected");
//        
//    }];
//    [_menuView addMenuItemWithTitle:@"Video" andIcon:[UIImage imageNamed:@"post_type_bubble_video.png"] andSelectedBlock:^{
//        NSLog(@"Video selected");
//        
//    }];
    
    
    
    [_menuView show];
}

- (void)selectCamera
{
    UIImagePickerControllerSourceType sourceType;

        //UIImagePickerController的相机类型
        sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断设备是否支持相机
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"没有摄像头！"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    //UIImagePickerController的使用
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
    }];


}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    SendViewController *sendCtrl = [[SendViewController alloc] init];
    BaseNavigationController *navigationCtrl = [[BaseNavigationController alloc] initWithRootViewController:sendCtrl];
    sendCtrl.selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    [picker presentViewController:navigationCtrl animated:YES completion:^{
    }];


}






#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //判断如果某个ViewController的中控制器大于1个时隐藏tabBar
    NSUInteger count = navigationController.viewControllers.count;
    if (count > 1) {
        [self showOrHiddenTabBar:YES];
    }else{
        [self showOrHiddenTabBar:NO];
    }
}




#pragma mark - ShowOrHiddenTabBar
- (void)showOrHiddenTabBar:(BOOL)flag
{
    [UIView animateWithDuration: 0.2f
                     animations:^{
                         if (flag) {
                             _tabBarView.top = kDeviceHeight;
                         }else{
                             _tabBarView.top = kDeviceHeight-kTabBarHight;
                         }
                     }];
}


- (void)dealloc
{
    [self.timer invalidate];
}


@end
