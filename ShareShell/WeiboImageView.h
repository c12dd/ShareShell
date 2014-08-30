//
//  WeiboImageView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboModel;

typedef void(^ClickImageBlock)(WeiboModel *weibo);

@protocol weiboImageDelegate <NSObject>
- (void)clickTheImageView:(UITapGestureRecognizer *)tap;
@end

@interface WeiboImageView : UIImageView
{
@private
    __weak id<weiboImageDelegate> _weiboImageDelegate;
}
@property (nonatomic,weak) id<weiboImageDelegate> weiboImageDelegate;
@property (nonatomic,copy) ClickImageBlock clickImageBlock;
@end
