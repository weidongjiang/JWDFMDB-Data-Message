//
//  ViewController.m
//  JWDFMDB-Data
//
//  Created by 蒋伟东 on 2016/11/2.
//  Copyright © 2016年 YIXIA. All rights reserved.
//

#import "ViewController.h"
#import "JWDFMDBChatMessageData.h"
#import "JWDModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    JWDFMDBChatMessageData *chatMessageData = [JWDFMDBChatMessageData shareChatMeaage];
    
    [chatMessageData openDB];
    
    JWDModel *model = [[JWDModel alloc] init];
    model.loginid = 679790;
    model.friendid = 13314;
    model.message = [NSString stringWithFormat:@"蓝瘦香菇"];
    model.messagetype = 1;
    model.readStatus = 0;
    model.sendStatus = 1;
    model.cureatetime = 2698798713;
    
    int64_t messageid = [chatMessageData addNewMessageWithModel:model];
    if (-1 != messageid){
        NSLog(@"数据插入成功 消息id %lld",messageid);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
