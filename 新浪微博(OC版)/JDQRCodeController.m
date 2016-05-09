
//
//  JDQRCodeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDQRCodeController.h"

@interface JDQRCodeController ()

@end

@implementation JDQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRCodeController];
}

/**
 *  初始化JDQRCodeController：
 */
-(void)setupRCodeController {
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode"]];
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode_highlighted"] getOriginalImage]];
    [self.navigationController.tabBarController.tabBar setTintColor:[UIColor orangeColor]];
}

@end
