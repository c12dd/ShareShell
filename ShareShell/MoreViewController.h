//
//  MoreViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-11.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@class UserImageView;
@interface MoreViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UITableView     *_tableView;
}
@property (strong, nonatomic) UserModel                 *user;
@property (strong, nonatomic) IBOutlet UILabel          *intro;
@property (strong, nonatomic) IBOutlet UILabel          *name;
@property (strong, nonatomic) IBOutlet UIView           *tableViewHeader;
@property (strong, nonatomic) IBOutlet UserImageView    *userHeadImageView;


@end
