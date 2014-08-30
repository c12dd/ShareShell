//
//  WeiboTable.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-20.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboTable.h"
#import "AppDelegate.h"
#import "WeiboCell.h"
#import "DetailViewController.h"



@implementation WeiboTable

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
    }
    return self;
}




#pragma mark - TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *weiboCellIdnetifier = @"weiboCell";
    WeiboCell *weiboCell = [tableView dequeueReusableCellWithIdentifier:weiboCellIdnetifier];
    if (weiboCell == nil) {
        weiboCell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weiboCellIdnetifier];
    }
    weiboCell.weibo = self.data[indexPath.row];
    weiboCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  weiboCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据行数获得WeiboModel对象中对应的数据
    WeiboModel *weibo = self.data[indexPath.row];
    //根据对应的数据计算cell的高度
    float height = [WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    height +=70;
    //再加上评论栏的高度
    height +=20 ;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.weiboTableDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [self.weiboTableDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.weiboTableDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.weiboTableDelegate tableView:tableView viewForHeaderInSection:section];
    }else{
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

@end
