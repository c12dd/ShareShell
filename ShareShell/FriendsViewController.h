//
//  FriendsViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "BaseViewController.h"
@class FriendTable;
@interface FriendsViewController : BaseViewController
@property (nonatomic,strong) FriendTable *friendTabel;
@property (nonatomic,assign) BOOL isFriend;
@end

