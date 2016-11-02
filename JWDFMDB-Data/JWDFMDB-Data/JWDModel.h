//
//  JWDModel.h
//  JWDFMDB-Data
//
//  Created by 蒋伟东 on 2016/11/2.
//  Copyright © 2016年 YIXIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWDModel : NSObject

//@"create table 'JWDFMDBChat_Message' ('messageid' integer primary key autoincrement, 'loginid' intger default -1, 'friendid' integer default -1, 'message' text default '', 'messagetype' integer default -1, 'readStatus' integer default -1, 'sendStatus' integer default -1,'cureatetime' double default -1)"

@property (nonatomic, assign) NSInteger messageid;//!< 消息id
@property (nonatomic, assign) NSInteger loginid;//!< 登陆者id
@property (nonatomic, assign) NSInteger friendid;//!< 聊天对方id
@property (nonatomic, strong) NSString  *message;//!< 消息体
@property (nonatomic, assign) NSInteger messagetype;//!< 消息类型
@property (nonatomic, assign) NSInteger readStatus;//!< 消息 已读与未读
@property (nonatomic, assign) NSInteger sendStatus;//!< 消息 发送成功或失败
@property (nonatomic, assign) double    cureatetime;//!< 消息 发送或接受时间


@end
