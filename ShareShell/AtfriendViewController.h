//
//  AtfriendViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-4.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^SelectFriendCellBlock)(NSString *screenName);
@interface AtfriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendTable;
@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (strong, nonatomic) SelectFriendCellBlock selectFriendCellBlock;
@end
