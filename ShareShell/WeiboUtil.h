//
//  DataUtil.h
//  ShareShell
//
//  Created by 宁晓明 on 14-7-20.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboUtil : NSObject


+ (NSString*)resolveSinaWeiboDate:(NSString*)dateString;
+ (NSString *)parseSource:(NSString *)weiboSource;
+ (NSString *)parseTextLink:(NSString *)text;
+ (NSString *)formatCount:(NSNumber *)count;




@end
