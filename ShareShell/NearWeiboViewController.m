//
//  NearWeiboViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "NearWeiboViewController.h"
#import "DetailViewController.h"
#import "WeiboModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
@interface NearWeiboViewController ()

@end

@implementation NearWeiboViewController

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
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissSendView:)];
    [cancelBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    self.mapView.delegate = self;
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];

    
}

#pragma  mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    [manager stopUpdatingLocation];
    
    CLLocationDegrees latitude = location.coordinate.latitude;
	CLLocationDegrees longitude = location.coordinate.longitude;
    CLLocationCoordinate2D center = {latitude,longitude};
	MKCoordinateSpan span = {0.1,0.1};
	MKCoordinateRegion region = {center,span};
    [self.mapView setRegion:region animated:YES];
    
    
    if (self.weiboArray == nil) {
        [self requestWithLongitude:longitude latitude:latitude];
    }
}


- (void)requestWithLongitude:(double)longitude latitude:(double)latitude
{
    NSDictionary *dic = @{
                          @"long": [NSString stringWithFormat:@"%f",longitude],
                          @"lat": [NSString stringWithFormat:@"%f",latitude]
                          };
    [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                      url:@"https://api.weibo.com/2/place/nearby_timeline.json"
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:nil];

}


- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    NSArray *tempArray = [dic objectForKey:@"statuses"];
    for(NSUInteger index = 0; index < tempArray.count; index++){
        NSDictionary *dic = tempArray[index];
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:dic];
        [self.weiboArray addObject:weibo];
        WeiboAnnotation *weiboAnnotation = [[WeiboAnnotation alloc] initWithWeiboModel:weibo];
        [self.mapView performSelector:@selector(addAnnotation:) withObject:weiboAnnotation afterDelay:0.05f*index];
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }else{
    static NSString *identifier = @"weiboAnnotationView";
        WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            __weak NearWeiboViewController *weakSelf = self;
            annotationView.clickWeiboAnnotationViewBlock = ^(WeiboModel *weiboData){
                DetailViewController *detailCtrl = [[DetailViewController alloc] init];
                NSLog(@"%@",weiboData.weiboId);
                detailCtrl.weibo = weiboData;
                detailCtrl.isNearby = YES;
                [weakSelf.navigationController pushViewController:detailCtrl animated:YES];
            };

        }
        return annotationView;
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    UIView *annotationView = [views lastObject];
    
    CGAffineTransform transform = annotationView.transform;
    annotationView.transform = CGAffineTransformScale(transform, 0.7f, 0.7f);
    annotationView.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        annotationView.transform = CGAffineTransformScale(transform, 1.2f, 1.2f);
        annotationView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
           annotationView.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)dismissSendView:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
