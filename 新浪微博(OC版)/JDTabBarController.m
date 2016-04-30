//
//  JDTabBarController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDTabBarController.h"
#import "JDNavigationController.h"
#import "JDHomeController.h"
#import "JDDiscoveryController.h"
#import "JDMessageController.h"
#import "JDProfileController.h"
#import "JDTabBar.h"
#import "JDComposeController.h"
#import "JDAccountModel.h"

@interface JDTabBarController () <JDTabBarDelegate>

@property (nonatomic, weak) JDTabBar *customTabBar;

@property (nonatomic, strong) JDProfileController *profileVC;
@property (nonatomic, strong) JDHomeController *homeVC;
@property (nonatomic, strong) JDMessageController *messageVC;
@property (nonatomic, strong) JDDiscoveryController *discoveryVC;

@end

@implementation JDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 用自定义tabBar替换系统tabBar：
    JDTabBar *tabBar = [[JDTabBar alloc] init];
    tabBar.frame = self.tabBar.frame;
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    self.customTabBar = tabBar;
    // 开启定时器，获取未读信息：
    [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(getUnreadInfo) userInfo:nil repeats:YES];
}

/**
 *  获取未得的微博信息数量：
 */
-(void)getUnreadInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 封装请求参数：
    JDAccountModel *account = [JDAccountModel getAccountInfo];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    [manager GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *unreadCount = responseObject[@"status"];
        if (unreadCount.integerValue > 0) {
            self.homeVC.tabBarItem.badgeValue = [unreadCount description];
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadCount.integerValue;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"%@", error);
    }];
}

// 移除系统的tabBar：
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBar removeFromSuperview];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChildControllers];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupChildControllers];
    }
    return self;
}

/**
 *  初始化主页面的四个主要的控制器：
 */
-(void)setupChildControllers {
    // 发现：
    JDHomeController *homeVC = (JDHomeController *)[self createChildControllerWithName:@"JDHomeController" andTitle:@"首页" andNormalImageName:@"tabbar_home" andSelectedImageName:@"tabbar_home_selected"];
    self.homeVC = homeVC;
    // 消息中心：
    JDMessageController *messageVC = (JDMessageController *)[self createChildControllerWithName:@"JDMessageController" andTitle:@"消息" andNormalImageName:@"tabbar_message_center" andSelectedImageName:@"tabbar_message_center_selected"];
    self.messageVC = messageVC;
    // 发现：
    JDDiscoveryController *discoveryVC = (JDDiscoveryController *)[self createChildControllerWithName:@"JDDiscoveryController" andTitle:@"发现" andNormalImageName:@"tabbar_discover" andSelectedImageName:@"tabbar_discover_selected"];
    self.discoveryVC = discoveryVC;
    // 个人中心：
    JDProfileController *profileVC = (JDProfileController *)[self createChildControllerWithName:@"JDProfileController" andTitle:@"我" andNormalImageName:@"tabbar_profile" andSelectedImageName:@"tabbar_profile_selected"];
    self.profileVC = profileVC;
}

/**
 *  调用此方法通过storyboard创建子控制器：
 *
 *  @param viewControllerName sb的名字；
 *  @param title              标题；
 *  @param norImageName       常态图片；
 *  @param seleImageName      选中图片。
 */
-(UIViewController *)createChildControllerWithName:(NSString *)viewControllerName andTitle:(NSString *)title andNormalImageName:(NSString *)norImageName andSelectedImageName:(NSString *)seleImageName {
    // 通过storyboard记载viewcontroller：
    UIStoryboard *sb = [UIStoryboard storyboardWithName:viewControllerName bundle:nil];
    UIViewController *viewController = [sb instantiateInitialViewController];

    // 设置属性：
    [self createChildControllerWithViewController:viewController andTitle:title andNormalImageName:norImageName andSelectedImageName:seleImageName];
    return viewController;
}

/**
 *  调用此方法创建子控制器：
 *
 *  @param viewController 子控制器；
 *  @param title          标题；
 *  @param norImageName   常态图片；
 *  @param seleImageName  选中图片。
 */
-(UIViewController *)createChildControllerWithViewController:(UIViewController *)viewController andTitle:(NSString *)title andNormalImageName:(NSString *)norImageName andSelectedImageName:(NSString *)seleImageName {
    // 设置属性：
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:norImageName];
    viewController.tabBarItem.selectedImage = [UIImage getOriginalImgaeWithImageName:seleImageName];
//    [viewController.view setBackgroundColor:JDRandomColor];
    // 创建一个对应的tabBarItem：
    self.customTabBar.item = viewController.tabBarItem;
    // 包装一个nav控制器：
    JDNavigationController *navController = [[JDNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navController];
    
    return viewController;
}

#pragma mark - JDTabBarDelegate

-(void)tabBar:(JDTabBar *)tabBar didClickButton:(JDButton *)button from:(NSInteger)start to:(NSInteger)end {
    // 切换控制器：
    self.selectedIndex = end;
    // 拿到当前的控制器：
    JDNavigationController *navVC = self.selectedViewController;
    UIViewController *childVC = navVC.topViewController;
    // 判断点击的控制器是否是首页：
    if ([childVC isKindOfClass:[JDHomeController class]]) {
        if (childVC.tabBarItem.badgeValue.integerValue > 0) {
            // 下拉刷新：
            JDLog(@"下拉刷新....");
            [self.homeVC.tableView.mj_header beginRefreshing];
        } else {
            // 滚回到最顶部：
            JDLog(@"回到顶部....");
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.homeVC.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

// 点击发送微博：
-(void)tabBar:(JDTabBar *)tabBar didClickAddButton:(UIButton *)addBtn {
    JDLog(@"%s", __func__);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"JDComposeController" bundle:nil];
    JDComposeController *composeVC = [sb instantiateInitialViewController];
    JDNavigationController *navVC = [[JDNavigationController alloc] initWithRootViewController:composeVC];
    composeVC.title = @"发送微博";
    [self presentViewController:navVC animated:YES completion:nil];
}

@end
