//
//  FriendTable.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "FriendTable.h"
#import "FriendGridCell.h"
@implementation FriendTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


    }
    return self;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *friendGridCellIdnetifier = @"gridCell";
    FriendGridCell *cell = [tableView dequeueReusableCellWithIdentifier:friendGridCellIdnetifier];
    if (cell == nil) {
        cell = [[FriendGridCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendGridCellIdnetifier];
    }
    cell.friendArray = self.friendData[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;

}
@end
