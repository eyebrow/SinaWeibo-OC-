//
//  JDTabBarController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDTabBarController.h"
#import "JDHomeController.h"
#import "JDMessageController.h"
#import "JDDiscoverController.h"
#import "JDProfileController.h"
#import "JDNavigationController.h"
#import "JDCustomTabBar.h"

@interface JDTabBarController () <JDCustomTabBarDelegate>

/**
 *  主页：
 */
@property (nonatomic, strong) JDHomeController *homeVC;
/**
 *  消息中心：
 */
@property (nonatomic, strong) JDMessageController *messageVC;
/**
 *  发现：
 */
@property (nonatomic, strong) JDDiscoverController *discoverVC;
/**
 *  个人中心：
 */
@property (nonatomic, strong) JDProfileController *profileVC;
/**
 *  自定义的tabBar：
 */
@property (nonatomic, strong) JDCustomTabBar *customTabBar;

@end

@implementation JDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建自定义的tabBar：
    JDCustomTabBar *customTabBar = [[JDCustomTabBar alloc] init];
    customTabBar.frame = self.tabBar.frame;
    customTabBar.delegate = self;
    self.customTabBar = customTabBar;
}

// 视图即将加载时调用：
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 将系统tabBar替换为自定义tabBar：
    [self.view addSubview:self.customTabBar];
}

// 视图加载完成后调用：
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 将系统的tabBar删除：
    [self.tabBar removeFromSuperview];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTabBarController];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupTabBarController];
    }
    return self;
}

/**
 *  初始化控制器：
 */
-(void)setupTabBarController {
    // 主页：
    JDHomeController *homeVC = [[JDHomeController alloc] init];
    homeVC = (JDHomeController *)[self createChildControllerWithViewController:homeVC title:@"首页" normalImageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    self.homeVC = homeVC;
    // 消息中心：
    JDMessageController *messageVC = [[JDMessageController alloc] init];
    messageVC = (JDMessageController *)[self createChildControllerWithViewController:messageVC title:@"消息" normalImageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    self.messageVC = messageVC;
    // 发现：
    JDDiscoverController *discoverVC = [[JDDiscoverController alloc] init];
    discoverVC = (JDDiscoverController *)[self createChildControllerWithViewController:discoverVC title:@"发现" normalImageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    self.discoverVC = discoverVC;
    // 个人中心：
    JDProfileController *profileVC = [[JDProfileController alloc] init];
    profileVC = (JDProfileController *)[self createChildControllerWithViewController:profileVC title:@"我" normalImageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    self.profileVC = profileVC;
}

/**
 *  创建子控制器并赋予一些属性：
 *
 *  @param viewController 空白的子控制器；
 *  @param title          标题；
 *  @param norImageName   普通图片；
 *  @param highImageName  选中图片。
 *
 *  @return 创建完毕的子控制器。
 */
-(UIViewController *)createChildControllerWithViewController:(UIViewController *)viewController title:(NSString *)title normalImageName:(NSString *)norImageName selectedImageName:(NSString *)selImageName {
    [viewController setTitle:title];
    [viewController.tabBarItem setImage:[[UIImage imageNamed:norImageName] getOriginalImage]];
    [viewController.tabBarItem setSelectedImage:[[UIImage imageNamed:selImageName] getOriginalImage]];
    [viewController.view setBackgroundColor:JDRandomColor];
    self.customTabBar.item = viewController.tabBarItem;
    JDNavigationController *navVC = [[JDNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navVC];
    return viewController;
}

#pragma mark - JDCustomTabBarDelegate:

-(void)customTabBar:(JDCustomTabBar *)customTabBar didClickWithStartPoint:(NSInteger)startPoint endPoint:(NSInteger)endPoint {
    // 一行代码切换控制器：
    self.selectedIndex = endPoint;
}

@end
