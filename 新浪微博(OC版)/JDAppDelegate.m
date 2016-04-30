//
//  JDAppDelegate.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDAppDelegate.h"
#import "JDTabBarController.h"
#import "JDAccountModel.h"

@interface JDAppDelegate ()

@end

@implementation JDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 向用户请求授权(仅在ios8之后需要)：
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    // 初始化主页：
    JDTabBarController *tabBarController = [[JDTabBarController alloc] init];
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreenBounds];
    // 判断是否授权：
    JDAccountModel *account = [JDAccountModel getAccountInfo];
    if (!account) {
        window.rootViewController = tabBarController;
    } else {
        [window chooseRootViewController];
    }
    [window makeKeyAndVisible];
    self.window = window;
    return YES;
}

/**
 *  内存释放：
 *
 *  @param application
 */
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    // 取消当前下载：
    [[SDWebImageManager sharedManager] cancelAll];
    // 清空缓存：
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
    JDLog(@"%s", __func__);
    // 开启后台多任务：
    [application beginBackgroundTaskWithExpirationHandler:nil];
}

@end
