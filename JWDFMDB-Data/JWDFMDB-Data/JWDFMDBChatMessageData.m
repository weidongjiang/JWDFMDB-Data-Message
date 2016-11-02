//
//  JWDFMDBChatMessageData.m
//  JWDFMDB-Data
//
//  Created by 蒋伟东 on 2016/11/2.
//  Copyright © 2016年 YIXIA. All rights reserved.
//

#import "JWDFMDBChatMessageData.h"
#import <FMDB.h>

// 数据库名
#define JWDFMDBChatName @"JWDFMDBChatMessageData.sqlite"

// 数据库版本表
#define JWDFMDBChatVersion @"JWDFMDBChat_version"

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
        [self addNewVersion:@"1.0"];
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




@end



















