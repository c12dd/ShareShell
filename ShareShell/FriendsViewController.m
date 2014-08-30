//
//  FriendsViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "FriendsViewController.h"
#import "UserModel.h"
#import "FriendTable.h"
//url
static NSString *const kUrlForFriends = @"https://api.weibo.com/2/friendships/friends.json";
static NSString *const kUrlForFollows = @"https://api.weibo.com/2/friendships/followers.json";
//requestTag
static NSString *const kRequestForFriendTag = @"requestForFriendTag";
static NSString *const kRequestForFollowTag = @"requestForFollowTag";

@interface FriendsViewController ()

@end

@implementation FriendsViewController

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
    
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissSendView:)];
    [cancelBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = cancelBarItem;

    _friendTabel = [[FriendTable alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];

    [self.view addSubview:self.friendTabel];
    [self sendHttpRequest];

    
}

- (void)sendHttpRequest
{
    NSString *url = nil;
    NSDictionary *dic = @{
                         @"uid": [NSUD objectForKey:kUserID]
                         };
    if (self.isFriend) {
        url = kUrlForFriends;
    }else{
        url = kUrlForFollows;
    }
    NSString *tag = kRequestForFriendTag;
    [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                      url:url
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:tag];
}


- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers
                                                         error:nil];
    NSArray *tempArray = [dic objectForKey:@"users"];
    [self parseData:tempArray];
}

- (void)parseData:(NSArray *)tempArray
{
    NSMutableArray *usersArray = [[NSMutableArray alloc] initWithCapacity:(tempArray.count/3)];
    NSMutableArray *users2D = nil;
    for (NSUInteger index = 0;index < tempArray.count; index++) {
    NSDictionary *userDic = tempArray[index];
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        if (index % 3 ==0) {
            users2D = [NSMutableArray arrayWithCapacity:3];
            [usersArray addObject:users2D];
        }
        [users2D addObject:user];
    }
    
    self.friendTabel.friendData = usersArray;
    [self.friendTabel reloadData];
    
}

- (void)dismissSendView:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
