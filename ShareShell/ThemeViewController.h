//
//  ThemeViewController.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-16.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    NSArray *_themeName;
    
}

@end
