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
#import "JWDModel.h"

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
                // 如果需要更新数据库，那么可以在这里对相应的表添加和删除字段 并且更改版本号
                NSString *updateGradeSql = [NSString stringWithFormat:@"alter table JWDFMDBChat_Message add age integer not null default -1"];
                
                // 如果不需要更新，直接传递 nil
                [self updateGradeSql:nil newVersion:JWDFMDBChatVersion_num];
            }
        }
    }
    return self;
}


- (BOOL)openDB {
    return [self.database open];
}
- (BOOL)closeDB {
    return [self.database close];
}
- (BOOL)isOpend {
    return [self.database goodConnection];
}

/**
 创建数据表的存储地址
 
 @return 返回之地
 */
+(NSString *)dataPath {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [document stringByAppendingPathComponent:JWDFMDBChatName];
    
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

#pragma mark -
#pragma mark - 增 删 改 查
/**
 增  插入数据
 
 @param messageModel 消息模型
 
 @return 消息id 也就是主键
 */
- (int64_t)addNewMessageWithModel:(JWDModel *)messageModel {

    if(nil == messageModel){
        return NO;
    }
    
    if(nil == messageModel.message){
        messageModel.message = @"";
    }
    
    // 方式1
//    NSString *sql = [NSString stringWithFormat:@"insert into %@ (loginid,friendid,message,messagetype,readStatus,sendStatus,cureatetime) values (%0ld,%0ld,'%@',%0ld,%0ld,%0ld,%f)",JWDFMDBChatMessageDataName,(long)messageModel.loginid,(long)messageModel.friendid,messageModel.message,(long)messageModel.messagetype,(long)messageModel.readStatus,(long)messageModel.sendStatus,messageModel.cureatetime];
//    
//    if ([self.database executeUpdate:sql]){
//        
//        return self.database.lastInsertRowId;
//        
//    }else{
//    
//        NSLog(@"插入数据出错 %@",self.database.lastErrorMessage);
//        return -1;
//    }
    
    // 方式2  当方式1 中插入的数据有特殊的字符是，就会数据写入失败，使用方式2可以完美解决这一问题。
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (loginid,friendid,message,messagetype,readStatus,sendStatus,cureatetime) values (?,?,?,?,?,?,?)",JWDFMDBChatMessageDataName];
    
    NSNumber *loginid = [NSNumber numberWithInteger:(long)messageModel.loginid];
    NSNumber *friendid = [NSNumber numberWithInteger:(long)messageModel.friendid];
    NSString *message = [NSString stringWithString:messageModel.message];
    NSNumber *messagetype = [NSNumber numberWithInteger:(long)messageModel.messagetype];
    NSNumber *readStatus = [NSNumber numberWithInteger:(long)messageModel.readStatus];
    NSNumber *sendStatus = [NSNumber numberWithInteger:(long)messageModel.sendStatus];
    NSNumber *cureatetime = [NSNumber numberWithFloat:messageModel.cureatetime];
    
    if ([self.database executeUpdate:sql withArgumentsInArray:@[loginid,friendid,message,messagetype,readStatus,sendStatus,cureatetime]]){
        return self.database.lastInsertRowId;
    }else{
        
        NSLog(@"插入数据出错 %@",self.database.lastErrorMessage);
        return -1;
    }
}
/**
 删  根据id 删除数据
 
 @param messageID 消息id
 
 @return 是否删除成功
 */
- (BOOL)deleteMessageWithMessageID:(NSInteger)messageID {

    NSString *sql = [NSString stringWithFormat:@"delete from %@ where messageid=%0ld",JWDFMDBChatMessageDataName,(long)messageID];
    return [self.database executeUpdate:sql];
}

/**
 改
 
 @param messageModel 数据模型
 
 @return 是否修改成功
 */

- (BOOL)updateMessageWithMessageModel:(JWDModel *)messageModel{
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set loginid=?,friendid=?,message=?,messagetype=?,readStatus=?,sendStatus=?,cureatetime=? where messageid=?",JWDFMDBChatMessageDataName];
    
    NSNumber *loginid = [NSNumber numberWithInteger:(long)messageModel.loginid];
    NSNumber *friendid = [NSNumber numberWithInteger:(long)messageModel.friendid];
    NSString *message = [NSString stringWithString:messageModel.message];
    NSNumber *messagetype = [NSNumber numberWithInteger:(long)messageModel.messagetype];
    NSNumber *readStatus = [NSNumber numberWithInteger:(long)messageModel.readStatus];
    NSNumber *sendStatus = [NSNumber numberWithInteger:(long)messageModel.sendStatus];
    NSNumber *cureatetime = [NSNumber numberWithFloat:messageModel.cureatetime];
    NSNumber *messageid = [NSNumber numberWithInteger:(long)messageModel.messageid];

    BOOL isupdate = [self.database executeUpdate:sql withArgumentsInArray:@[loginid,friendid,message,messagetype,readStatus,sendStatus,cureatetime,messageid]];
    
    return isupdate;

}
/**
 查 获取所有数据
 @param loginid  用户id , 可以多账号登录，获取不同的数据
 @param friendid 不同的聊天对象
 @param offset   数据起始位置
 @param limit    查询的个数
 @return 模型数组
 */
- (NSArray<JWDModel *> *)getAllMessageWithLoginID:(NSInteger)loginid friendid:(NSInteger)friendid offset:(NSInteger)offset limit:(NSInteger)limit {

    if (loginid<=0 || friendid<=0){
        NSLog(@"参数 id 不对");
        return nil;
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from (select * from %@ where loginid=%ld and friendid=%ld order by cureatetime desc limit %ld offset %ld) order by cureatetime",JWDFMDBChatMessageDataName,loginid,friendid,limit,offset];
    NSMutableArray<JWDModel *> *data = [NSMutableArray array];
    FMResultSet *set = [self.database executeQuery:sql];
    while ([set next]) {
        JWDModel *model = [[JWDModel alloc] init];
        model.messageid = [set intForColumn:@"messageid"];
        model.loginid = [set intForColumn:@"loginid"];
        model.friendid = [set intForColumn:@"friendid"];
        model.message = [set stringForColumn:@"message"];
        model.messagetype = [set intForColumn:@"messagetype"];
        model.readStatus = [set intForColumn:@"readStatus"];
        model.sendStatus = [set intForColumn:@"sendStatus"];
        model.cureatetime = [set doubleForColumn:@"cureatetime"];
        [data addObject:model];
    }
    if (data.count>0){
        return [NSArray arrayWithArray:data];
    }else{
        return nil;
    }
}
@end



















