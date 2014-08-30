//
//  AtfriendViewController.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-4.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "AtfriendViewController.h"
#import "FriendCell.h"
#import "UserModel.h"
@interface AtfriendViewController ()

@end

@implementation AtfriendViewController

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
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissCommentView)];
    [cancelBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    [self sendHttpRequest];
    
}
- (void)dismissCommentView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendHttpRequest
{
    NSDictionary *dic = @{@"uid": [NSUD objectForKey:kUserID]};
    [WBHttpRequest requestWithAccessToken:[NSUD objectForKey:kAccessToken]
                                      url:@"https://api.weibo.com/2/friendships/friends.json"
                               httpMethod:@"GET"
                                   params:dic
                                 delegate:self
                                  withTag:nil];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    NSArray *tempArray = [tempDic objectForKey:@"users"];
    _friendsArray = [NSMutableArray arrayWithCapacity:tempArray.count];
    for (NSDictionary *dic in tempArray) {
        UserModel *user = [[UserModel alloc] initWithDataDic:dic];
        [self.friendsArray addObject:user];
    }
    [self.friendTable reloadData];
    

}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"friendCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:self options:nil] lastObject];
    }
    
    cell.friend = self.friendsArray[indexPath.section];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.friendsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserModel *friend = self.friendsArray[indexPath.section];
    if (self.selectFriendCellBlock) {
        _selectFriendCellBlock(friend.screenName);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
