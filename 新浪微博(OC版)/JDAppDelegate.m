//
//  JDAppDelegate.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDAppDelegate.h"
#import "JDTabBarController.h"
#import "JDAccountModel.h"
#import "JDNewFeatureController.h"
#import "JDWelcomeController.h"

@interface JDAppDelegate ()

@end

@implementation JDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:JDScreenBounds];
    [window setBackgroundColor:[UIColor whiteColor]];
    JDTabBarController *tabBarVC = [[JDTabBarController alloc] init];
    // 判断是否授权：
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    if (account) {
        // 判断版本号：
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *currentVer = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        NSString *lastVer = [defaults objectForKey:@"CFBundleShortVersionString"];
        if ([currentVer compare:lastVer] == NSOrderedDescending) {
            JDLog(@"已授权_有新版本，显示新特性界面....");
            JDNewFeatureController *newFeatureVC = [[JDNewFeatureController alloc] init];
            window.rootViewController = newFeatureVC;
            [defaults setObject:currentVer forKey:@"CFBundleShortVersionString"];
            [defaults synchronize];
        } else {
            JDLog(@"已授权_没有最新版，显示欢迎界面....");
            JDWelcomeController *welcomeVC = [[JDWelcomeController alloc] init];
            window.rootViewController = welcomeVC;
        }
    } else {
        JDLog(@"为授权显示游客欢迎界面....");
        window.rootViewController = tabBarVC;
    }
    [window makeKeyAndVisible];
    self.window = window;
    return YES;
}

@end
