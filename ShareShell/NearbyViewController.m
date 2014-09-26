//
//  NearbyViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "NearbyCell.h"
@interface NearbyViewController ()

@end

#define RequestWhenInUseAuthorization(locationManager) [locationManager requestWhenInUseAuthorization]


@implementation NearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (CLLocationManager *)locationManager
//{
//    static CLLocationManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[CLLocationManager alloc] init];
//    });
//    return manager;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissNearView:)];
    [cancelBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    [SVProgressHUD showWithStatus:@"正在寻找。。"];


    self.nearbyTable.hidden = YES;
    _locationManager = [[CLLocationManager alloc] init];
    //设置定位的精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置代理
    self.locationManager.delegate = self;
    //开始定位
    [self.locationManager startUpdatingLocation];
    

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//                [self.locationManager requestWhenInUseAuthorization];
                RequestWhenInUseAuthorization(self.locationManager);
            }
            break;
        default:
            break;
            
            
    } 
}
 
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    
    //结束定位
    [manager stopUpdatingLocation];
    
    if (self.data == nil) {
        //取出经纬度
        CGFloat longtitude  = location.coordinate.longitude;
        CGFloat latitude    = location.coordinate.latitude;
        NSString *longtitudeStr = [NSString stringWithFormat:@"%f",longtitude];
        NSString *latitudeStr = [NSString stringWithFormat:@"%f",latitude];
        NSDictionary *dic =@{
                             @"long" : longtitudeStr,
                             @"lat" : latitudeStr
                             };
        NSString *accessToken = [NSUD objectForKey:kAccessToken];
        [WBHttpRequest requestWithAccessToken:accessToken
                                          url:@"https://api.weibo.com/2/place/nearby/pois.json"
                                   httpMethod:@"GET"
                                       params:dic
                                     delegate:self
                                      withTag:@"getNear"];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    NSArray *tempArray = [tempDic objectForKey:@"pois"];
    [self loadDataFinish:tempArray];
}

- (void)loadDataFinish:(NSArray *)tempArray
{
    self.data = tempArray;
    self.nearbyTable.hidden = NO;
    [self.nearbyTable reloadData];
    
    [super dismissSVProcessHUD];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier = @"nearByCell";
    NearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NearbyCell" owner:self options:nil] lastObject];
    }

    cell.data = self.data[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - 选中微博位置之后将选中的值传入发送微博页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *result = self.data[indexPath.row];
    if (self.selectNearbyCellBlock) {
        _selectNearbyCellBlock(result);
    }
    [self dismissNearView:nil];
}


- (void)dismissNearView:(UIBarButtonItem *)button
{
//    [self dismissViewControllerAnimated:YES completion:^{
//    [super dismissSVProcessHUD];
//    }];
    [super dismissSVProcessHUD];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
