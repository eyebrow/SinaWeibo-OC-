
//
//  UIWindow+JDExtension.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/30.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "UIWindow+JDExtension.h"
#import "JDNewFeatureController.h"
#import "JDWelcomeController.h"

@implementation UIWindow (JDExtension)

-(void)chooseRootViewController {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 当前版本号：
    NSString *currentVer = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    // 取出沙盒中的版本号：
    NSString *sandVer = [defaults objectForKey:@"CFBundleShortVersionString"];
    // 判断是否显示新特性界面：
    if ([currentVer compare:sandVer] == NSOrderedDescending) {
        // 替换版本号：
        [defaults setObject:currentVer forKey:@"CFBundleShortVersionString"];
        [defaults synchronize];
        // 显示新特性界面：
        JDNewFeatureController *newFeatureVC = [[JDNewFeatureController alloc] init];
        self.rootViewController = newFeatureVC;
    } else {
        // 显示欢迎界面：
        JDWelcomeController *welcomeVC = [[JDWelcomeController alloc] init];
        self.rootViewController = welcomeVC;
    }
}

@end
