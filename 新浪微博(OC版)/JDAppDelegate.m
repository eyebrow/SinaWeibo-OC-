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
    // 请求用户授权：
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:JDScreenBounds];
    [window setBackgroundColor:[UIColor whiteColor]];
    JDTabBarController *tabBarVC = [[JDTabBarController alloc] init];
    [window makeKeyAndVisible];
    // 判断是否授权：
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    if (account) {
#warning 由于这个方法内部是用.keyWindow的方式获取window，所以在调用这个方法前需要先执行[window makeKeyAndVisible]。
        [window chooseRootViewController];
    } else {
        JDLog(@"为授权显示游客欢迎界面....");
        window.rootViewController = tabBarVC;
    }
    self.window = window;
    return YES;
}

// app进入后台后调用：
-(void)applicationDidEnterBackground:(UIApplication *)application {
    // 开启后台任务：
    // 由于音乐类app的优先级最高，不易被ios杀死，所以一般可以将app注册为一个音乐app：
    [application beginBackgroundTaskWithExpirationHandler:nil];
}

@end
