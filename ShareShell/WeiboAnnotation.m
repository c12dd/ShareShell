//
//  WeiboAnnotation.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (instancetype) initWithWeiboModel:(WeiboModel *)weibo
{
       self =  [super init];
    if (self) {
        self.weibo = weibo;
    }
    return  self;
}
//复写setWeibo方法
- (void)setWeibo:(WeiboModel *)weibo
{
    if (_weibo != weibo) {
        _weibo = weibo;
    }
    
    NSDictionary *geo = weibo.geo;
    if (geo != nil) {
       NSArray *coordinate = [geo objectForKey:@"coordinates"];
        if (coordinate.count == 2) {
            float latitude  = [[coordinate objectAtIndex:0] floatValue];
            float longitude = [[coordinate objectAtIndex:1] floatValue];
            _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        }
    }
    
}

@end
