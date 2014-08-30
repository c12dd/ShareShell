//
//  FriendGridCell.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-6.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendView;
@interface FriendGridCell : UITableViewCell
@property (nonatomic,strong) FriendView *friendView;
@property (nonatomic,strong) NSArray    *friendArray;

@end
