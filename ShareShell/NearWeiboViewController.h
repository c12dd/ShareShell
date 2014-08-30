//
//  NearWeiboViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface NearWeiboViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView    *mapView;
@property (strong, nonatomic) CLLocationManager     *locationManager;
@property (strong, nonatomic) NSMutableArray        *weiboArray;

@end
