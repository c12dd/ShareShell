//
//  WeiboAnnotationView.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView
{
    _weiboImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.weiboImage.layer.borderWidth = 2.0f;
    self.weiboImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _weiboImage.hidden = YES;
    [self addSubview:self.weiboImage];
    
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.userImage.layer.borderWidth = 1.0f;
    self.userImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userImage.hidden = YES;
    [self addSubview:self.userImage];
    
    _weiboLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weiboLabel.font = [UIFont systemFontOfSize:11.0f];
    self.weiboLabel.backgroundColor = [UIColor clearColor];
    self.weiboLabel.textColor = [UIColor whiteColor];
    self.weiboLabel.numberOfLines = 0;
    self.weiboLabel.hidden = YES;
    [self addSubview:self.weiboLabel];
    
    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWeiboAnnotationView:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)clickWeiboAnnotationView:(UITapGestureRecognizer *)tagGesture
{
    if (self.clickWeiboAnnotationViewBlock) {
        _clickWeiboAnnotationViewBlock(self.weiboData);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    WeiboAnnotation *weiboAnnotation = self.annotation;
    if ([weiboAnnotation isKindOfClass:[WeiboAnnotation class]]) {
       self.weiboData = weiboAnnotation.weibo;
    }
    
    if (self.weiboData.thumbnailImage == nil) {
        self.image = [UIImage imageNamed:@"nearby_map_content"];
        
        self.userImage.frame = CGRectMake(20, 18, 50, 50);
        NSLog(@"%@",self.weiboData.thumbnailImage);
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[self.weiboData.user objectForKey:@"profile_image_url"]]];
        self.userImage.hidden = NO;
        
        self.weiboLabel.frame = CGRectMake(self.userImage.right + 5.0f, 20, 110, 50);
        self.weiboLabel.text = self.weiboData.text;
        self.weiboLabel.hidden = NO;
        
    }else {
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg"];
        
        self.weiboImage.frame = CGRectMake(0, 0, 120, 120);
        self.weiboImage.hidden = NO;
        [self.weiboImage sd_setImageWithURL:[NSURL URLWithString:self.weiboData.thumbnailImage]];
        
        self.userImage.frame = CGRectMake(70, 70, 50, 50);
        self.userImage.hidden = NO;
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[self.weiboData.user objectForKey:@"profile_image_url"]]];
    }
}



@end
