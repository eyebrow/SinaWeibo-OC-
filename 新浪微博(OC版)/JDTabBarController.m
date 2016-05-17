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
#import "JDComposeController.h"
#import "JDAccountModel.h"

#define kUnreadURL @"https://rm.api.weibo.com/2/remind/unread_count.json"

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
    
    // 开启定时器，获取未读信息：
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(getUnreadWeibosCount) userInfo:nil repeats:YES];
    // 为了保证即使程序进入后台也能够获取未读信息，所以此时应该把timmer加入runloop：
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  获取未读微博的数量：
 */
-(void)getUnreadWeibosCount {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    [manager GET:kUnreadURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JDLog(@"获取未读微博信息成功....");
        NSNumber *unreadsCount = responseObject[@"status"];
        if (unreadsCount.integerValue > 0) {
            // 有未读数据：
            self.homeVC.tabBarItem.badgeValue = [unreadsCount description];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"获取未读微博信息失败.... %@", error);
    }];
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
    JDHomeController *homeVC = (JDHomeController *)[self createChildControllerWithStoryboardName:@"JDHomeController" title:@"首页" normalImageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    self.homeVC = homeVC;
    // 消息中心：
    JDMessageController *messageVC = (JDMessageController *)[self createChildControllerWithStoryboardName:@"JDMessageController" title:@"消息" normalImageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    self.messageVC = messageVC;
    // 发现：
    JDDiscoverController *discoverVC = (JDDiscoverController *)[self createChildControllerWithStoryboardName:@"JDDiscoverController" title:@"发现" normalImageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    self.discoverVC = discoverVC;
    // 个人中心：
    JDProfileController *profileVC = (JDProfileController *)[self createChildControllerWithStoryboardName:@"JDProfileController" title:@"我" normalImageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
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
    self.customTabBar.item = viewController.tabBarItem;
    JDNavigationController *navVC = [[JDNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navVC];
    return viewController;
}

// 通过storyboard的方式创建控制器：
-(UIViewController *)createChildControllerWithStoryboardName:(NSString *)storyboardName title:(NSString *)title normalImageName:(NSString *)norImageName selectedImageName:(NSString *)selImageName {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [sb instantiateInitialViewController];
    [self createChildControllerWithViewController:vc title:title normalImageName:norImageName selectedImageName:selImageName];
    return vc;
}

#pragma mark - JDCustomTabBarDelegate:

-(void)customTabBar:(JDCustomTabBar *)customTabBar didClickWithStartPoint:(NSInteger)startPoint endPoint:(NSInteger)endPoint {
    // 一行代码切换控制器：
    self.selectedIndex = endPoint;
    // 拿到当前控制器：
    JDNavigationController *navVC = self.selectedViewController;
    UIViewController *vc = navVC.topViewController;
    
    // 当在首页点击首页按钮时，如果有新微博则刷新微博，如果没有则会到最顶部：
    if ([vc isKindOfClass:[JDHomeController class]]) {
        if (self.homeVC.tabBarItem.badgeValue.integerValue > 0) {
            JDLog(@"下拉刷新....");
            [self.homeVC.tableView.mj_header beginRefreshing];
        } else {
            JDLog(@"回滚到顶部....");
            // 取出顶部cell：
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.homeVC.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

-(void)customTabBar:(JDCustomTabBar *)customTabBar didClickComposeButton:(UIButton *)composeBtn {
    JDLog(@"点击了写微博的按钮....");
    UIStoryboard *composeSB = [UIStoryboard storyboardWithName:@"JDComposeController" bundle:nil];
    JDComposeController *composeVC = [composeSB instantiateInitialViewController];
    JDNavigationController *navVC = [[JDNavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end
