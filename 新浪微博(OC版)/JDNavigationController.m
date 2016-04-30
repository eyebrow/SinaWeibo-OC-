//
//  JDNavigationController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
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
 *  类第一次被加时调用：
 */
+(void)initialize {
    // 获取当前的item对象：
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTintColor:[UIColor orangeColor]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateHighlighted];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

@end
