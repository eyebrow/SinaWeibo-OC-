//
//  JDNewFeatureController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/29.
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
 *  点击进入新特性界面：
 *
 *  @param sender
 */
- (IBAction)clickToInToMainController:(UIButton *)sender {
    JDTabBarController *mainVC = [[JDTabBarController alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = mainVC;
}

@end
