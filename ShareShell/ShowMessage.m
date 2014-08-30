//
//  ShowMessage.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-25.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "ShowMessage.h"

@implementation ShowMessage


+ (void)showNewWeiboCountView:(NSString *)title View:(UIView *)View
{
    UIImageView *countView = nil;
    if(countView == nil){
        countView = [UIFactory initWithImageName:@"tabBar_bg_all.png"];
        countView.layer.cornerRadius  = 10.0f;  //圆弧弧度
        countView.layer.masksToBounds = YES;
        countView.layer.borderColor   = [UIColor grayColor].CGColor;
        countView.frame = CGRectMake((kDeviceWidth-180)/2, -44, 180, 44);
        [View addSubview:countView];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        countLabel.frame = CGRectMake(0, 0, countView.width, countView.height);
        countLabel.tag = 1000;
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont systemFontOfSize:14.0f];
        countLabel.textAlignment = NSTextAlignmentCenter;
        [countView addSubview:countLabel];
    }
    
    UILabel *countLabel = (UILabel *)[countView viewWithTag:1000];
    //微博提示信息动画
    [UIView animateWithDuration:0.6 animations:^{
        countLabel.text     = title;
        countView.alpha    = 1.0f;
        countView.top      = 64.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.6f
                                  delay:2.0f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 countView.top = -44.0f;
                                 countView.alpha = 0.0f;
                             } completion:nil];
        }
    }];

}

@end
