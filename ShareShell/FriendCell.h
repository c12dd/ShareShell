//
//  FriendCell.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-4.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface FriendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *screenName;
@property (strong, nonatomic) UserModel *friend;
@end
