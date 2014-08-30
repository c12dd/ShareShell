//
//  WeiboAnnotation.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"
@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) WeiboModel *weibo;

- (instancetype) initWithWeiboModel:(WeiboModel *)weibo;
@end
