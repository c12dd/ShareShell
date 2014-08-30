//
//  ZoomScaleViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-29.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "ZoomScaleViewController.h"
#import "UIImageView+WebCache.h"
@interface ZoomScaleViewController ()

@end

@implementation ZoomScaleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated
{
    [self zoomScaleImage:self.url];
}

- (void)zoomScaleImage:(NSString *)url
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.userInteractionEnabled = YES;
    imageView.multipleTouchEnabled = YES;
    imageView.tag = 100;
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:weibo.originalImage]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSInteger process = (receivedSize/expectedSize);
        [SVProgressHUD showProgress:process status:@"请稍后！"];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [SVProgressHUD dismiss];
    }];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissZoomScaleImageView:)];
    [imageView addGestureRecognizer:tap];
     
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(kDeviceWidth, kDeviceHeight);
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.minimumZoomScale = 1.0f;
    scrollView.maximumZoomScale = 30.0f;
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
}

- (void)dismissZoomScaleImageView:(UITapGestureRecognizer *)tap
{
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:100];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
