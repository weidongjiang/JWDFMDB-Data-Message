//
//  JWDFMDBChatMessageData.m
//  JWDFMDB-Data
//
//  Created by 蒋伟东 on 2016/11/2.
//  Copyright © 2016年 YIXIA. All rights reserved.
//

#import "JWDFMDBChatMessageData.h"



static JWDFMDBChatMessageData *chatMessageData = nil;


@implementation JWDFMDBChatMessageData


+(instancetype)shareChatMeaage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatMessageData = [[JWDFMDBChatMessageData alloc] init];
    });
    return chatMessageData;
}



@end
