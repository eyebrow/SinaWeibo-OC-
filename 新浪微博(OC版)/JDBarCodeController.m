
//
//  JDBarCodeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBarCodeController.h"

@interface JDBarCodeController ()

@end

@implementation JDBarCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBarCodeController];
}

/**
 *  初始化JDBarCodeController：
 */
-(void)setupBarCodeController {
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_barcode"]];
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrcode_tabbar_icon_barcode_highlighted"] getOriginalImage]];
    [self.navigationController.tabBarController.tabBar setTintColor:[UIColor orangeColor]];
}

@end
