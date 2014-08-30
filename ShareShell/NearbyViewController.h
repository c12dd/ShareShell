//
//  NearbyViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectNearbyCellBlock)(NSDictionary *result);

@interface NearbyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
@private
    CLLocationManager *_locationManager;
}
@property (copy, nonatomic) SelectNearbyCellBlock selectNearbyCellBlock;
@property (strong, nonatomic) IBOutlet UITableView *nearbyTable;
@property (strong, nonatomic) NSArray *data;
@end
