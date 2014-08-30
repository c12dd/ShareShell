//
//  ThemeViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-16.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "ThemeViewController.h"
#import "BaseTableView.h"
#import "ThemeManager.h"




@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //获得微博plist文件中的主题信息
       _themeName = [[ThemeManager shareInstance].themPlist allKeys];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景图片
    UIImageView *backgroundImage = [UIFactory initWithImageName:kViewBackGroundImage];
    backgroundImage.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    self.view = backgroundImage;
    self.view.userInteractionEnabled = YES;
    
    
    //表格
    BaseTableView *tabelView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    [self.view addSubview:tabelView];
    
}





-(void)test
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _themeName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"themeCell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *themeName = _themeName[indexPath.row];
    cell.textLabel.text = themeName;
    
    
    
    if ([kCurrentTheme isEqualToString:themeName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //获取选中的主题名
    NSString *themeName= _themeName[indexPath.row];
    //将选中的主题名给主题管理类
    [ThemeManager shareInstance].themeName = themeName;
    //
    NSString *currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
    NSLog(@"currentThemeName :%@",currentThemeName);
    NSLog(@"themeName :%@",themeName);
    //判断当前主题时候是已经使用的主题
    if ([currentThemeName isEqualToString:themeName]) {
        return;
    }else{
        
    //发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNofication object:themeName];
        
        //记录主题配置信息
        [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    //刷新表格中的数据
    [tableView reloadData];
    }


@end
