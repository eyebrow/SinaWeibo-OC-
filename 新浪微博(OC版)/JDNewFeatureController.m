//
//  JDNewFeatureController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/13.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDNewFeatureController.h"
#import "JDTabBarController.h"

@interface JDNewFeatureController ()

@end

@implementation JDNewFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 *  点击开始微博：
 *
 *  @param sender
 */
- (IBAction)clickToStartWeibo:(UIButton *)sender {
    JDLog(@"点击了开始微博按钮....");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    JDTabBarController *tabBarVC = [[JDTabBarController alloc] init];
    window.rootViewController = tabBarVC;
}

@end
