//
//  EmotionsBoard.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-2.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmotionsView.h"
@interface EmotionsBoard : UIView<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrolleView;
@property(nonatomic,assign)NSUInteger   pageCount;
@property(nonatomic,strong)EmotionsView *emotionsView;


- (id)initWithBlock:(ClickEmoticonBlock)clickEmotionBlock;
@end
