//
//  UIWindow+JDExtension.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "UIWindow+JDExtension.h"
#import "JDWelcomeController.h"
#import "JDNewFeatureController.h"

@implementation UIWindow (JDExtension)

-(void)chooseRootViewController {
    // 取出沙盒中的版本号和当前最新的版本号：
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentVer = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *lastVer = [defaults objectForKey:@"CFBundleShortVersionString"];
    // 检测是否是最新版本：
    if ([currentVer compare:lastVer] == NSOrderedDescending) {
        JDLog(@"已授权_有新版本，显示新特性界面....");
        // 如果当前版本更新，则显示新特性，并存储版本号：
        JDNewFeatureController *newFeatureVC = [[JDNewFeatureController alloc] init];
        self.rootViewController = newFeatureVC;
        [defaults setObject:currentVer forKey:@"CFBundleShortVersionString"];
        [defaults synchronize];
    } else {
        JDLog(@"已授权_没有最新版，显示欢迎界面....");
        // 没有新版本则显示欢迎界面：
        JDWelcomeController *welcomeVC = [[JDWelcomeController alloc] init];
        self.rootViewController = welcomeVC;
    }
}

@end
