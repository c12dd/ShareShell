//
//  DataBaseManager.m
//  ShareShell
//
//  Created by 宁晓明 on 14-8-8.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import "DataBaseManager.h"
#import "WeiboModel.h"
#import "UserModel.h"

static NSString *const WeibiDataBaseName = @"WeiboDataBase";
@implementation DataBaseManager
/**
 * 单例
 * 返回值：单例对象
 * 参数：无
 **/
+ (instancetype)shareInstance
{
    static DataBaseManager *dataBaseMangaer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBaseMangaer = [[DataBaseManager alloc] init];
    });
    return dataBaseMangaer;

}
/**
 * 单例初始化方法
 * 返回值：单例对象
 * 参数：无
 * 初始化单例对象的同时打开数据库
 **/
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *fileName = WeibiDataBaseName;
        NSString *filePath = [self copyFileToDocuments:fileName];
        NSLog(@"Databas path is :%@",filePath);
        _fmDatabase = [FMDatabase databaseWithPath:filePath];
        if (![self.fmDatabase open]) {
            NSLog(@"open  error! error msg %@",self.fmDatabase.lastErrorMessage);
        }
    }
    return self;
}

/**
 * 将包目录文件下的数据库复制到沙盒目录下
 * 返回值：数据库路径
 * 参数：数据库名称
 **/
- (NSString *)copyFileToDocuments:(NSString *)fileName
{
    //获得沙盒中的documents完整目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //拼接数据库的名字
    NSString *dataBasePath = [documentsPath stringByAppendingPathComponent:[fileName stringByAppendingString:@".sqlite"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dataBasePath]) {
        NSError *error = nil;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"sqlite"];
        [fileManager copyItemAtPath:filePath toPath:dataBasePath error:&error];
        if (error != nil) {
            NSLog(@"Copy DataBase Failed %@",error);
            return nil;
        }
        return dataBasePath;
    }else{
        return dataBasePath;
    }
}

/**
 * 保存多条用户微博数据
 * 返回值：BOOL
 * 参数：微博数组
 **/

- (BOOL)saveWeiboDataToDataBaseWithWeiboArray:(NSArray *)weiboArray
{
    BOOL result = NO;
    for (WeiboModel *weibo in weiboArray) {
       result = [self saveWeiboDataToDataBaseWithWeiboModel:weibo];
    }
    return result;
}

/**
 * 保存单条用户数据
 * 返回值：BOOL
 * 参数：微博对象
 **/
- (BOOL)saveWeiboDataToDataBaseWithWeiboModel:(WeiboModel *)weiboModel
{
    NSString *insertSql = @"insert into T_STATUS (id,\
                                            status_id, \
                                            created_at, \
                                            text,\
                                            source,\
                                            thumbnail_pic,\
                                            bmiddle_pic,\
                                            original_pic,\
                                            user_id,\
                                            retweeted_status_id,\
                                            reposts_count,\
                                            comments_count,\
                                            attitudes_count,\
                                            pic_urls_id) \
                                            values(null,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL result = [self.fmDatabase
                   executeUpdate:insertSql,
                   weiboModel.weiboId,
                   weiboModel.createDate,
                   weiboModel.text,
                   weiboModel.source,
                   weiboModel.thumbnailImage,
                   weiboModel.bmiddleImage,
                   weiboModel.originalImage,
                   [weiboModel.user objectForKey:@"id"],
                   [weiboModel.relWeibo objectForKey:@"id"],
                   weiboModel.repostsCount,
                   weiboModel.commentsCount,
                   weiboModel.attitudesCount,
                   weiboModel.picUrls
                   ];
    UserModel *user = [[UserModel alloc] initWithDataDic:weiboModel.user];
    [self saveUserDataToDataBaseWithUserModel:user];
    if (weiboModel.relWeibo != nil) {
    WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboModel.relWeibo];
    [self saveWeiboDataToDataBaseWithWeiboModel:weibo];
    }

    if (!result) {
        NSLog(@"insert error %@",[self.fmDatabase lastErrorMessage]);
    }
    return result;
}

/**
 * 保存多条用户数据
 * 返回值：用户对象
 * 参数：BOOL
 **/
- (BOOL)saveUserDataToDataBaseWithUserArray:(NSArray *)userArray
{
    BOOL result = NO;
    for (UserModel *user in userArray) {
        result = [self saveUserDataToDataBaseWithUserModel:user];
    }
    return result;
    
}
/**
 * 查询单条微博信息
 * 返回值：微博ID
 * 参数：要查询的微博ID
 **/
- (WeiboModel *)queryWeiboModerFromDataBaseWithWeiboId:(NSString *)weiboId
{
    if (weiboId == nil) {
        return nil;
    }
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from T_STATUS where status_id = %@",weiboId];
    FMResultSet *resultSet = [self.fmDatabase executeQuery:sqlQuery];
    WeiboModel *weibo = nil;
    while ([resultSet next]) {
        weibo = [[WeiboModel alloc] init];
        weibo.weiboId = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"status_id"] integerValue]];
        weibo.createDate = [resultSet stringForColumn:@"created_at"];
        weibo.text = [resultSet stringForColumn:@"text"];
        weibo.source = [resultSet stringForColumn:@"source"];
        weibo.thumbnailImage = [resultSet stringForColumn:@"thumbnail_pic"];
        weibo.bmiddleImage = [resultSet stringForColumn:@"bmiddle_pic"];
        weibo.originalImage =[resultSet stringForColumn:@"original_pic"];
        weibo.user = [self createUserDicWithUserModel:[self queryUserModelFromDataBaseWithUserId:[resultSet stringForColumn:@"user_id"]]];
        weibo.relWeibo = [self createWeiboDicWithWeiboModle:[self queryWeiboModerFromDataBaseWithWeiboId:[resultSet stringForColumn:@"retweeted_status_id"]]];
        weibo.repostsCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"reposts_count"] integerValue]];
        weibo.commentsCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"comments_count"] integerValue]];
        weibo.attitudesCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"attitudes_count"] integerValue]];
        weibo.picUrls = [NSArray arrayWithObject:[resultSet stringForColumn:@"pic_urls_id"]];
    }
    
    return weibo;

}
/**
 * 查询所有微博信息
 * 返回值：无
 * 参数：微博数组
 **/
- (NSArray *)queryWeiboModerFromDataBase
{
    NSString *sqlQuery = @"select * from T_STATUS";
    FMResultSet *resultSet = [self.fmDatabase executeQuery:sqlQuery];
    NSMutableArray *weiboArray = [NSMutableArray arrayWithCapacity:10];
    WeiboModel *weibo = nil;
    while ([resultSet next]) {
        weibo = [[WeiboModel alloc] init];
        weibo.weiboId = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"status_id"] integerValue]];
        weibo.createDate = [resultSet stringForColumn:@"created_at"];
        weibo.text = [resultSet stringForColumn:@"text"];
        weibo.source = [resultSet stringForColumn:@"source"];
        weibo.thumbnailImage = [resultSet stringForColumn:@"thumbnail_pic"];
        weibo.bmiddleImage = [resultSet stringForColumn:@"bmiddle_pic"];
        weibo.originalImage =[resultSet stringForColumn:@"original_pic"];
        weibo.user = [self createUserDicWithUserModel:[self queryUserModelFromDataBaseWithUserId:[resultSet stringForColumn:@"user_id"]]];
//        weibo.relWeibo = [self createWeiboDicWithWeiboModle:[self queryWeiboModerFromDataBaseWithWeiboId:[resultSet stringForColumn:@"status_id"]]];
        weibo.repostsCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"reposts_count"] integerValue]];
        weibo.commentsCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"comments_count"] integerValue]];
        weibo.attitudesCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"attitudes_count"] integerValue]];
        weibo.picUrls =[NSArray arrayWithObject:[resultSet stringForColumn:@"pic_urls_id"]];
        [weiboArray addObject:weibo];
        }
    [self closeDataBase];
    return weiboArray;
}
/**
 * 根据用户对象创建用户字典
 * 返回值：用户字典
 * 参数：用户对象
 **/
-(NSDictionary *)createUserDicWithUserModel:(UserModel *)user
{
    if (user == nil) {
        return nil;
    }
    NSDictionary *userDic = @{
                              @"user_id":user.userId,
                              @"screen_name":user.screenName,
                              @"name":user.name,
                              @"province":user.province,
                              @"city":user.city,
                              @"location":user.location,
                              @"description":user.description,
                              @"url":user.url,
                              @"profile_image_url":user.profileImage,
                              @"gender":user.gender,
                              @"followers_count":user.friendsCount,
                              @"friends_count":user.friendsCount,
                              @"statuses_count":user.statusesCount,
                              @"created_at":user.createDate,
                              @"remark":user.remark,
                              @"avatar_large":user.avatar_large
                              };
    return userDic;
}
/**
 * 根据微博对象创建微博字典
 * 返回值：微博字典
 * 参数：微博对象
 **/
- (NSDictionary *)createWeiboDicWithWeiboModle:(WeiboModel *)weibo
{
    if (weibo == nil) {
        return nil;
    }
    NSLog(@"%@",weibo.thumbnailImage);
    NSDictionary *weiboDic = @{
                          @"status_id":weibo.weiboId,
                          @"created_at":weibo.createDate,
                          @"text":weibo.text,
                          @"source":weibo.source,
                          @"thumbnail_pic":weibo.thumbnailImage == nil ? @"":weibo.thumbnailImage,
                          @"bmiddle_pic":weibo.bmiddleImage == nil ? @"":weibo.bmiddleImage,
                          @"original_pic":weibo.originalImage == nil ? @"":weibo.originalImage,
                          @"user_id": [weibo.user objectForKey:@"id"] == nil ? @"":[weibo.user objectForKey:@"id"],
                          @"retweeted_status_id":[weibo.relWeibo objectForKey:@"id"] == nil ? @"":[weibo.relWeibo objectForKey:@"id"],
                          @"reposts_count":weibo.repostsCount,
                          @"comments_count":weibo.commentsCount,
                          @"attitudes_count":weibo.attitudesCount,
                          @"pic_urls":weibo.picUrls
                          };
    return weiboDic;
}
/**
 * 保存单条用户信息
 * 返回值：BOOL
 * 参数：用户对象
 **/
- (BOOL)saveUserDataToDataBaseWithUserModel:(UserModel *)userModel
{
    if (userModel == nil) {
        return NO;
    }
    NSString *insertSql= @"insert into T_USER (id,\
                                            user_id,\
                                            screen_name,\
                                            name,\
                                            province,\
                                            city,\
                                            location,\
                                            description,\
                                            url,\
                                            profile_image_url,\
                                            gender,\
                                            followers_count,\
                                            friends_count,\
                                            statuses_count,\
                                            created_at,\
                                            remark,\
                                            avatar_large)  values(null,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL result = [self.fmDatabase executeUpdate:insertSql,
                   userModel.userId,
                   userModel.screenName,
                   userModel.name,
                   userModel.province,
                   userModel.city,
                   userModel.location,
                   userModel.description,
                   userModel.url,
                   userModel.profileImage,
                   userModel.gender,
                   userModel.followersCount,
                   userModel.friendsCount,
                   userModel.statusesCount,
                   userModel.createDate,
                   userModel.remark,
                   userModel.avatar_large];
    if (!result) {
        NSLog(@"insert error %@",[self.fmDatabase lastErrorMessage]);
    }

    return result;
}


/**
 * 查询单条用户信息
 * 返回值：用户对象
 * 参数：用户ID
 **/
- (UserModel *)queryUserModelFromDataBaseWithUserId:(NSString *)userId
{
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from T_USER where user_id = %@",userId];
    FMResultSet *resultSet = [self.fmDatabase executeQuery:sqlQuery];
    UserModel *user = [[UserModel alloc] init];
    while ([resultSet next]) {
        user.userId = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"user_id"] integerValue]];
        user.screenName = [resultSet stringForColumn:@"screen_name"];
        user.name = [resultSet stringForColumn:@"name"];
        user.province = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"province"] integerValue]];
        user.city = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"city"] integerValue]];
        user.location = [resultSet stringForColumn:@"location"];
        user.description = [resultSet stringForColumn:@"description"];
        user.url = [resultSet stringForColumn:@"url"];
        user.profileImage = [resultSet stringForColumn:@"profile_image_url"];
        user.gender = [resultSet stringForColumn:@"gender"];
        user.followersCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"followers_count"] integerValue]];
        user.friendsCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"friends_count"] integerValue]];
        user.statusesCount = [NSNumber numberWithInteger: [[resultSet stringForColumn:@"statuses_count"] integerValue]];
        user.createDate = [resultSet stringForColumn:@"created_at"];
        user.remark = [resultSet stringForColumn:@"remark"];
        user.avatar_large = [resultSet stringForColumn:@"avatar_large"];
        
    }

    return user;
}
/**
 * 查询所有用户信息
 * 返回值：用户对象数组
 * 参数：无
 **/
- (NSMutableArray *)queryUserModelArrayFromDataBase
{
    NSString *sqlQuery = @"select * from T_USER";
    NSMutableArray *userArray = [NSMutableArray arrayWithCapacity:10];
    FMResultSet *resultSet = [self.fmDatabase executeQuery:sqlQuery];
    UserModel *user = nil;
    while ([resultSet next]) {
        user = [[UserModel alloc] init];
        user.userId = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"user_id"] integerValue]];
        user.screenName = [resultSet stringForColumn:@"screen_name"];
        user.name = [resultSet stringForColumn:@"name"];
        user.province = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"province"] integerValue]];
        user.city = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"city"] integerValue]];
        user.location = [resultSet stringForColumn:@"location"];
        user.description = [resultSet stringForColumn:@"description"];
        user.url = [resultSet stringForColumn:@"url"];
        user.profileImage = [resultSet stringForColumn:@"profile_image_url"];
        user.gender = [resultSet stringForColumn:@"gender"];
        user.followersCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"followers_count"] integerValue]];
        user.friendsCount = [NSNumber numberWithInteger:[[resultSet stringForColumn:@"friends_count"] integerValue]];
        user.statusesCount = [NSNumber numberWithInteger: [[resultSet stringForColumn:@"statuses_count"] integerValue]];
        user.createDate = [resultSet stringForColumn:@"created_at"];
        user.remark = [resultSet stringForColumn:@"remark"];
        user.avatar_large = [resultSet stringForColumn:@"avatar_large"];
        [userArray addObject:user];
    }
    [self closeDataBase];
    return userArray;
}



/**
 * 删除用户数据和微博数据
 * 返回值：无
 * 参数：无
 **/
- (void)deleteAll
{
    [self deleteUserData];
    [self deleteWeiboData];
}
- (void)deleteUserData
{
    NSString *sql = @"delete from T_USER";
    [self.fmDatabase executeUpdate:sql];
}
- (void)deleteWeiboData
{
    NSString *sql = @"delete from T_STATUS";
    [self.fmDatabase executeUpdate:sql];
}


- (void)closeDataBase
{
    [self.fmDatabase closeOpenResultSets];
    [self.fmDatabase close];
}


/*

- (BOOL)openDataBase:(NSString *)DataBaseName
{
    _dateBase = NULL;
    NSInteger result = sqlite3_open([DataBaseName UTF8String], &_dateBase);
    if (result != SQLITE_OK) {
        NSLog(@"DataBase Open Fail");
        sqlite3_close(self.dateBase);
        return NO;
    }else{
        return YES;
    }
}





- (NSArray *)loadWeiboModelDataFromDataBase:(NSString *)dataBaseName
{
    NSArray *weiboArray = nil;
    if ([self openDataBase:dataBaseName]) {
        NSString *sql = @"select * from status";
        char *errmsg = NULL;
        sqlite3_stmt *stmt = NULL;
        sqlite3_prepare_v2(_dateBase, [sql UTF8String], -1, &stmt, NULL);
        int result = sqlite3_step(stmt);
        
        
        if (result != SQLITE_OK) {
            NSLog(@"SELECT Failed %s",errmsg);
            sqlite3_close(_dateBase);
            return nil;
        }
        return weiboArray;
    }else{
        return nil;
    }

}

*/
@end
