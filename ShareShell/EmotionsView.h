//
//  EmotionsView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-31.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickEmoticonBlock)(NSString *emoticonName);

@interface EmotionsView : UIView
{
@private
    NSMutableArray  *_items;
    UIImageView     *_magnifierView;
    NSString        *_selectName;
}
@property(nonatomic,strong)NSMutableArray  *items;
@property(nonatomic,strong)UIImageView     *magnifierView;
@property(nonatomic,strong)NSString        *selectName;
@property(nonatomic,assign)NSUInteger       pageCount;
@property(nonatomic,copy)ClickEmoticonBlock clickEmotionBlock;

@end
