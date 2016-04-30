//
//  JDMessageController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/27.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDMessageController.h"

@interface JDMessageController ()

@end

@implementation JDMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 发送按钮：
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"发送消息" style:UIBarButtonItemStylePlain target:self action:@selector(clickToSendMessage)];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    // 修改登录页面样式：
    if (self.defaultCenterView != nil) {
        self.defaultCenterView.iconImageName = @"visitordiscover_image_message";
        self.defaultCenterView.infoText = @"登录后，收到评论、私信和系统消息时，会在这里显示。";
        self.defaultCenterView.turntableHidden = YES;
    }
}

/**
 *  点击发送信息：
 */
-(void)clickToSendMessage {
    JDLog(@"%s", __func__);
}

@end
