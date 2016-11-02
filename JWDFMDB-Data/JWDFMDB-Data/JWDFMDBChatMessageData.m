//
//  JWDFMDBChatMessageData.m
//  JWDFMDB-Data
//
//  Created by 蒋伟东 on 2016/11/2.
//  Copyright © 2016年 YIXIA. All rights reserved.
//

#import "JWDFMDBChatMessageData.h"
#include <UIKit/UIKit.h>
#import <FMDB.h>

// 数据库名
#define JWDFMDBChatName @"JWDFMDBChatMessageData.sqlite"

// 数据库版本表
#define JWDFMDBChatVersion @"JWDFMDBChat_version"

// 数据库版本号
static NSString *JWDFMDBChatVersion_num = @"1.0";

// 数据表名
#define JWDFMDBChatMessageDataName @"JWDFMDBChat_Message"

static JWDFMDBChatMessageData *chatMessageData = nil;


@interface JWDFMDBChatMessageData ()

@property(nonatomic, strong)FMDatabase *database;//!< <#value#>

@end




@implementation JWDFMDBChatMessageData

+(instancetype)shareChatMeaage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatMessageData = [[JWDFMDBChatMessageData alloc] init];
    });
    return chatMessageData;
}

/**
 创建数据表的存储地址

 @return 返回之地
 */
+(NSString *)dataPath {

    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [document stringByAppendingPathComponent:JWDFMDBChatName];
    
}

- (instancetype)init {

    if(self == [super init]){
    
        // 1.判断是否有数据库表
        if (NO == [[NSFileManager defaultManager] fileExistsAtPath:[JWDFMDBChatMessageData dataPath]]){
        
            FMDatabase *database = [FMDatabase databaseWithPath:[JWDFMDBChatMessageData dataPath]];
            self.database = database;
            
            
            // 创建表是否成功
            if(NO == [self createtable]){
                return nil;
            }
            
            
            
        }else{// 已经有表，直接打开
            FMDatabase *database = [FMDatabase databaseWithPath:[JWDFMDBChatMessageData dataPath]];
            self.database = database;
            if(NO == [self.database open]){
                [self.database close];
            }else{
                // 2.是否升级版本号
                
                // 如果需要更新数据库，那么可以在这里对相应的表添加和删除字段
                NSString *updateGradeSql = [NSString stringWithFormat:@"alter table JWDFMDBChat_Message add age integer not null default -1"];
                
                // 如果不需要更新，直接传递 nil
                [self updateGradeSql:updateGradeSql newVersion:@"4.0"];
            
            }
        
            
        }
        
        
    }
    return self;
}

- (BOOL)createtable {

    
    [self.database open];
    
    // 创建版本表
    {
        NSString *sql = [NSString stringWithFormat:@"create table 'JWDFMDBChat_version' ('id' integer primary key autoincrement, 'version' text not null default '0', 'updateDate' text not null default '')"];
        if(NO == [self.database executeUpdate:sql]){
            NSLog(@"创建JWDFMDBChat_version表失败");
            [self.database close];
            return NO;
        }
        
        // 创建版本号
        [self addNewVersion:JWDFMDBChatVersion_num];
    }
    
    // 创建数据库显示表
    {
        NSString *sql = [NSString stringWithFormat:@"create table 'JWDFMDBChat_Message' ('messageid' integer primary key autoincrement, 'loginid' intger default -1, 'friendid' integer default -1, 'message' text default '', 'messagetype' integer default -1, 'readStatus' integer default -1, 'sendStatus' integer default -1,'cureatetime' double default -1)"];

        if(NO == [self.database executeUpdate:sql]){
            NSLog(@"创建JWDFMDBChat_Message表失败");
            [self.database close];
            return NO;
        }
        
    }
    
    [self.database close];
    return YES;
}


/**
 添加版本号

 @param version <#version description#>

 @return <#return value description#>
 */
- (BOOL)addNewVersion:(NSString*)version{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss-zzz"];
    NSString *datestring = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (version, updateDate) values ('%@','%@')",JWDFMDBChatVersion,version,datestring];
    
    
    return [self.database executeUpdate:sql];
}

/**
 更新数据库版本 
 1、版本低更新插入新的版本，2、版本一样不需要更新 3、没有记录版本，更新插入

 @param updateGradeSql 需要执行的 添加字段的版本号
 @param newVersion     新的版本号

 @return 是否更新成功
 */
- (BOOL)updateGradeSql:(NSString *)updateGradeSql newVersion:(NSString *)newVersion {

    // 不需要更新
    if (nil == updateGradeSql){
        return YES;
    
    }else {// 需要更新
    
        NSString *spl = [NSString stringWithFormat:@"select * from %@ order by id desc limit 0,1",JWDFMDBChatVersion];
        FMResultSet *set = [self.database executeQuery:spl];
        CGFloat lastversion = -1.0;
        while ([set next]) {
            
            lastversion = [[set stringForColumn:@"version"] floatValue];
            if ([newVersion floatValue] > lastversion){
            
                // 执行更新数据库版本
                if([self.database executeUpdate:updateGradeSql]){
                    return [self addNewVersion:newVersion];
                }
            }
        }
    
        // 没有记录版本号，需要更新
        if (lastversion == -1) {
            if([self.database executeUpdate:updateGradeSql]){
                return [self addNewVersion:newVersion];
            }
        }
        
    }
    
    return YES;
    
}



@end



















