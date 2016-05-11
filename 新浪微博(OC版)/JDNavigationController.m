//
//  JDNavigationController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDNavigationController.h"

@interface JDNavigationController ()

@end

@implementation JDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  类第一次被加载时调用：
 */
+(void)initialize {
    // 统一导航栏按钮文字主题：
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} forState:UIControlStateHighlighted];
}

@end
