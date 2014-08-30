//
//  DataBaseManager.h
//  ShareShell
//
//  Created by 宁晓明 on 14-8-8.
//  Copyright (c) 2014年 com.shareShell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class WeiboModel;
@class UserModel;
@interface DataBaseManager : NSObject

@property (nonatomic,strong)FMDatabase *fmDatabase;
+ (instancetype)shareInstance;

- (NSString *)copyFileToDocuments:(NSString *)fileName;
/**
 * 保存微博数据
 * 返回值：返回是否存储成功
 * 参数：传入要存储的微博实体或者微博实体的数组
 **/
- (BOOL)saveWeiboDataToDataBaseWithWeiboArray:(NSArray *)weiboArray;
- (BOOL)saveWeiboDataToDataBaseWithWeiboModel:(WeiboModel *)weiboModel;

/**
 * 保存用户信息
 * 返回值：返回是否存储成功
 * 参数：传入要存储的用户实体或者用户实体的数组
 **/
- (BOOL)saveUserDataToDataBaseWithUserArray:(NSArray *)userArray;
- (BOOL)saveUserDataToDataBaseWithUserModel:(UserModel *)userModel;

/**
 * 查询用户信息
 * 返回值：用户对象
 * 参数：无
 **/
- (NSMutableArray *)queryUserModelArrayFromDataBase;
- (UserModel *)queryUserModelFromDataBaseWithUserId:(NSString *)userId;


/**
 * 查询微博信息
 * 返回值：微博数组
 * 参数：无
 **/
- (NSMutableArray *)queryWeiboModerFromDataBase;
- (WeiboModel *)queryWeiboModerFromDataBaseWithWeiboId:(NSString *)weiboId;

/**
 * 删除用户数据和微博数据
 * 返回值：无
 * 参数：无
 **/
- (void)deleteAll;
- (void)deleteUserData;
- (void)deleteWeiboData;













/*
@property (nonatomic,assign)sqlite3 *dateBase;
- (BOOL)openDataBase:(NSString *)DataBaseName;
*/
 /**
 * 查询存入数据库中的微博实体信息
 * 返回值：返回查询到的微博实体数组
 * 参数：传入数据库的地址
 **/
/*
- (NSArray *)loadWeiboModelDataFromDataBase:(NSString *)dataBaseName;
*/
@end
