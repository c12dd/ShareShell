//
//  EmotionsBoard.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-2.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "EmotionsBoard.h"
@implementation EmotionsBoard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (id)initWithBlock:(ClickEmoticonBlock)clickEmotionBlock
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        //调用_emotionView的block
        _emotionsView.clickEmotionBlock = clickEmotionBlock;
    }
    return self;
}
- (void)initView
{
    
    _emotionsView = [[EmotionsView alloc] initWithFrame:CGRectZero];
    self.pageCount = self.emotionsView.pageCount;
    _scrolleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, _emotionsView.height)];
    self.scrolleView.backgroundColor = [UIColor lightGrayColor];
    self.scrolleView.contentSize = CGSizeMake(_emotionsView.width, _emotionsView.height);
    self.scrolleView.pagingEnabled = YES;
    self.scrolleView.showsHorizontalScrollIndicator = NO;
    self.scrolleView.showsVerticalScrollIndicator = NO;
    self.scrolleView.directionalLockEnabled = YES;
    self.scrolleView.clipsToBounds = NO;
    self.scrolleView.delegate = self;
    [self.scrolleView addSubview:self.emotionsView];
    self.height = _emotionsView.height+20;
    self.width = self.scrolleView.width;
    
    [self addSubview:self.scrolleView];
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,_scrolleView.bottom, 320, 20)];
    pageControl.numberOfPages = self.pageCount;
    pageControl.backgroundColor = [UIColor lightGrayColor];
    pageControl.currentPage = 0;
    pageControl.tag = 3000;
    [self addSubview:pageControl];
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger page =  scrollView.contentOffset.x/320;
    UIPageControl *pageCountrol = (UIPageControl *)[self viewWithTag:3000];
    [UIView beginAnimations:nil context:nil];
    pageCountrol.currentPage = page;
    [UIView commitAnimations];

}


@end
