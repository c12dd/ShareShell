//
//  EmotionsView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-31.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "EmotionsView.h"

#define item_width 42
#define item_height 45

@implementation EmotionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
        _pageCount = self.items.count;

    }
    return self;
}


- (void)initData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray  *tempArray = [NSArray arrayWithContentsOfFile:plistPath];
    _items = [NSMutableArray arrayWithCapacity:4];
    NSMutableArray *emotionsArray = nil;
    for (NSUInteger i = 0; i<tempArray.count; i++) {
        NSDictionary *emotionDic = tempArray[i];
        if (i % 28 == 0) {
            emotionsArray = [NSMutableArray arrayWithCapacity:28];
            [_items addObject:emotionsArray];
        }
        [emotionsArray addObject:emotionDic];
    }
    
    //计算高和宽
    self.width = _items.count * kDeviceWidth;
    self.height = 4 * item_height;
    //添加放大镜
    _magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    _magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    _magnifierView.backgroundColor = [UIColor clearColor];
    _magnifierView.hidden = YES;
    [self addSubview:_magnifierView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((64-30)/2.0, 15, 30, 30)];
    imageView.tag = 300;
    imageView.backgroundColor = [UIColor clearColor];
    [_magnifierView addSubview:imageView];
    
}

- (void)drawRect:(CGRect)rect
{

    int colum = 0,row = 0;
    
    for (NSUInteger i = 0; i<_items.count; i++) {
        NSArray *tempArray = _items[i];
        for (NSUInteger j = 0; j < tempArray.count; j++) {
            NSDictionary *emotionsDic = tempArray[j];
            NSString *imageName = [emotionsDic objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imageName];
            CGRect frame = CGRectMake(colum*item_width+15, row*item_height+15, 30, 30);
            CGFloat x = i * 320+frame.origin.x;
            frame.origin.x = x;
           [image drawInRect:frame];
            
            colum ++;
            if (colum % 7 == 0 ) {
                colum = 0;
                row++;
            }
            if (row == 4) {
                row = 0;
            }
        }
    }
}

#pragma mark - TouchBeagin
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
    [self touchEmotion:point];
}

#pragma mark - TouchMoved
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchEmotion:point];

}

#pragma mark - TouchEnd
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
    if (self.clickEmotionBlock != nil) {
        _clickEmotionBlock(self.selectName);
    }
}
#pragma mark - TouchCancel
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _magnifierView.hidden = YES;
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

#pragma mark - TouchEmotion
- (void)touchEmotion:(CGPoint)point
{
    NSUInteger page = point.x/320;
    //在当前页中的坐标
    CGFloat x = point.x-(page*320)-10;
    CGFloat y = point.y-10;
    //获得在当前页中的行数
    NSUInteger colum = x / item_width;
    NSUInteger row   = y / item_height;
    
    if (colum > 6) {
        colum = 6;
    }
    if (row > 3) {
        row = 3;
    }
    
    NSUInteger index = colum + (row*7);
    NSArray *tempArray = _items[page];
    if (page == 3 && index>=20) {
        return;
    }
    NSDictionary *emotionDic = tempArray[index];
    
    NSLog(@"%@",[emotionDic objectForKey:@"chs"]);
    NSString *imageName = [emotionDic objectForKey:@"chs"];
    
    if (![_selectName isEqualToString:imageName] || _selectName == nil) {

        UIImageView *imageView = (UIImageView *)[_magnifierView viewWithTag:300];
        imageView.image = [UIImage imageNamed:[emotionDic objectForKey:@"png"]];
        _magnifierView.left = (page*320)+colum*item_width;
        _magnifierView.bottom = row*item_height+20;
        _selectName = imageName;
    }
    
}

@end
