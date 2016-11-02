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
    
    
    UIButton *addbtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 80, 40)];
    addbtn.backgroundColor = [UIColor greenColor];
    addbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [addbtn setTitle:@"插入数据" forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addbtnDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addbtn];
    
    UIButton *delebtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 40)];
    delebtn.backgroundColor = [UIColor greenColor];
    delebtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [delebtn setTitle:@"删除数据" forState:UIControlStateNormal];
    [delebtn addTarget:self action:@selector(delebtnDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delebtn];
    
    UIButton *updatebtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 80, 40)];
    updatebtn.backgroundColor = [UIColor greenColor];
    updatebtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [updatebtn setTitle:@"修改数据" forState:UIControlStateNormal];
    [updatebtn addTarget:self action:@selector(updatebtnDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updatebtn];
    
    UIButton *getDatabtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 80, 40)];
    getDatabtn.backgroundColor = [UIColor greenColor];
    getDatabtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [getDatabtn setTitle:@"获取全部数据" forState:UIControlStateNormal];
    [getDatabtn addTarget:self action:@selector(getDatabtnDid) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getDatabtn];
    
}

-(void)addbtnDid {

    JWDFMDBChatMessageData *chatMessageData = [JWDFMDBChatMessageData shareChatMeaage];
    
    [chatMessageData openDB];
    
    JWDModel *model = [[JWDModel alloc] init];
    model.loginid = 679790;
    model.friendid = 13314;
    model.message = [NSString stringWithFormat:@"'"];
    model.messagetype = 1;
    model.readStatus = 0;
    model.sendStatus = 1;
    model.cureatetime = 2698798713;
    
    int64_t messageid = [chatMessageData addNewMessageWithModel:model];
    if (-1 != messageid){
        NSLog(@"数据插入成功 消息id %lld",messageid);
    }
}


- (void)delebtnDid {
   
    BOOL isdele = [[JWDFMDBChatMessageData shareChatMeaage] deleteMessageWithMessageID:10];
    NSLog(@"isdele -- %d",isdele?1:0);
}

- (void)updatebtnDid {
    
    JWDModel *model = [[JWDModel alloc] init];
    
    model.messageid = 21;
    model.loginid = 1111111111;
    model.friendid = 222222222;
    model.message = [NSString stringWithFormat:@"我在跟进，完毕,iiiii"];
    model.messagetype = 1;
    model.readStatus = 0;
    model.sendStatus = 1;
    model.cureatetime = 80808089899;
    
    BOOL isupdate = [[JWDFMDBChatMessageData shareChatMeaage] updateMessageWithMessageModel:model];
    NSLog(@"isupdate -- %d",isupdate?1:0);
    
}
- (void)getDatabtnDid {
    
    
   NSArray *data = [[JWDFMDBChatMessageData shareChatMeaage] getAllMessageWithLoginID:679790 friendid:13314 offset:0 limit:100];
    
    NSLog(@"data count %lu",(unsigned long)data.count);
}

@end
