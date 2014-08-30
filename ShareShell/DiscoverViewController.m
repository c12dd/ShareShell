//
//  DiscoverViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-29.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "DiscoverViewController.h"
#import "EmotionsBoard.h"
#import "NearWeiboViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToNearWeiboCtrl:(UIButton *)sender {
    NearWeiboViewController *near = [[NearWeiboViewController alloc] init];
    [self.navigationController pushViewController:near animated:YES];
}
@end
