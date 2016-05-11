//
//  JDMessageController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDMessageController.h"

@interface JDMessageController ()

@end

@implementation JDMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMessageController];
}

-(void)setupMessageController {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送消息" style:UIBarButtonItemStylePlain target:self action:@selector(clickToSendMessage:)];
}

/**
 *  点击发送消息：
 *
 *  @param sender
 */
-(void)clickToSendMessage:(UIBarButtonItem *)sender {
    JDLog(@"点击了发送消息的按钮....");
}

@end
