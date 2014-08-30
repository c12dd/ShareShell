//
//  WeiboAnnotationView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WeiboModel.h"

typedef void(^ClickWeiboAnnotationViewBlock)(WeiboModel *weibo);
@interface WeiboAnnotationView : MKAnnotationView
@property (nonatomic, strong) UIImageView   *userImage;
@property (nonatomic, strong) UIImageView   *weiboImage;
@property (nonatomic, strong) UILabel       *weiboLabel;
@property (nonatomic, strong) WeiboModel    *weiboData;
@property (nonatomic, strong) ClickWeiboAnnotationViewBlock clickWeiboAnnotationViewBlock;
@end
