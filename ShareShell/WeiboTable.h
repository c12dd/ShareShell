//
//  WeiboTable.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-20.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseTableView.h"

@protocol weiboTableDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
@end

@interface WeiboTable : BaseTableView
{
@private
    __weak id <weiboTableDelegate> _weiboTableDelegate;
}
@property (nonatomic,weak) id <weiboTableDelegate> weiboTableDelegate;
@property (nonatomic,assign) BOOL isUserInfo;


@end
