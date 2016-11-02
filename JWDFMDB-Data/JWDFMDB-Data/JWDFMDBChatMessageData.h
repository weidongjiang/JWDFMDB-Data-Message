//
//  JWDFMDBChatMessageData.h
//  JWDFMDB-Data
//
//  Created by 蒋伟东 on 2016/11/2.
//  Copyright © 2016年 YIXIA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JWDModel;

@interface JWDFMDBChatMessageData : NSObject


+(instancetype)shareChatMeaage;
- (BOOL)openDB;
- (BOOL)closeDB;
- (BOOL)isOpend;
/**
 增  插入数据

 @param messageModel 消息模型

 @return 消息id 也就是主键
 */
- (int64_t)addNewMessageWithModel:(JWDModel *)messageModel;

@end
