//
//  DataUtil.m
//  ShareShell
//
//  Created by 宁晓明 on 14-7-20.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "WeiboUtil.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
@implementation WeiboUtil


//解析新浪微博中的日期
+ (NSString*)resolveSinaWeiboDate:(NSString*)dateString{
    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    //必须设置，否则无法解析
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date=[iosDateFormater dateFromString:dateString];
    
    //发布微博的时间点据当前时间的间隔,单位秒
    NSTimeInterval interval = [date timeIntervalSinceNow];
    //换算成分钟
    double tempTime = abs((int)(interval)/60.0);
    NSString *finalDataString =nil;
    if (tempTime <= 60) {
        finalDataString = [NSString stringWithFormat:@"%d分钟前",(int)tempTime];
        
    }else if (tempTime < 2) {
        finalDataString = [NSString stringWithFormat:@"刚刚"];
    }else if(tempTime > 60 && tempTime <= 600){
        finalDataString = [NSString stringWithFormat:@"%d小时%d分钟前",(int)(tempTime)/60,(int)(tempTime)%60];
    }else{
        NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
        [resultFormatter setDateFormat:@"MM-dd HH:mm"];
        finalDataString = [resultFormatter stringFromDate:date];
    }
    
    return finalDataString;
}

//解析微博来源的方法
+ (NSString *)parseSource:(NSString *)weiboSource
{
    
    if (weiboSource != nil) {
        NSString *regex = @">\\w+<";
        //微博来源的源字符
        NSString *matchstr = weiboSource;
        //按照正则表达式截取字符>XXXXX<
        NSArray *matchArray = [matchstr componentsMatchedByRegex:regex];
        NSString *source = nil;
        if (matchArray.count > 0) {
            NSString *sourceStr = matchArray[0];
            NSRange range;
            range.location = 1;
            range.length = sourceStr.length - 2;
            source = [sourceStr substringWithRange:range];
            
        }
        return source;
    }else{
        return nil;
    }
    
}

+ (NSString *)parseTextLink:(NSString *)text
{

    
    NSString *regex = @"(@\\w+)|(#\\w+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    //从文本中截获需要替换的字符
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    
    //对@ 和 #进行编码
    for (NSString *matchStr in matchArray) {
        NSString *replacStr = nil;
        if ([matchStr hasPrefix:@"@"]) {
            replacStr = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",[matchStr URLEncodedString],matchStr];
        }else if([matchStr hasPrefix:@"http"]){
            replacStr = [NSString stringWithFormat:@"<a href='%@'>%@</a>",matchStr,matchStr];
        }else if([matchStr hasPrefix:@"#"]){
            replacStr = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",[matchStr URLEncodedString],matchStr];
        }
        if (replacStr != nil) {
            text = [text stringByReplacingOccurrencesOfString:matchStr withString:replacStr];
        }
    }
    
    return text;
}

//格式化显示数字
+ (NSString *)formatCount:(NSNumber *)count
{
    long Count = [count longValue];
    NSString *countStr = nil;
    if (Count >= 10000) {
        Count = Count/10000;
        countStr = [NSString stringWithFormat:@"%ld万",Count];
    }else{
        countStr = [NSString stringWithFormat:@"%ld",Count];
    }
    if ([countStr isEqualToString:@"0"]) {
        countStr = @"";
    }
    return countStr;
}


@end
