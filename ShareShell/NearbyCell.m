//
//  NearbyCell.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "NearbyCell.h"
#import "UIImageView+WebCache.h"
@implementation NearbyCell

- (void)awakeFromNib
{
}
- (void)layoutSubviews{
    _title.text = [self.data objectForKey:@"title"];
    _detilTitle.text = [self.data objectForKey:@"address"];
    NSString *url = [self.data objectForKey:@"icon"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:url]];
}


@end
