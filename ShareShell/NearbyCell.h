//
//  NearbyCell.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-28.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *detilTitle;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic)NSDictionary *data;
@end
