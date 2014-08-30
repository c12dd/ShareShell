//
//  BaseTableView.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-16.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)NSArray *data;   //数据
@end

