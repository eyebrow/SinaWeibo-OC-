
//
//  JDHomeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDHomeController.h"
#import "JDScanCodeController.h"
#import "JDCustomTitleView.h"

@interface JDHomeController () {
    UIWindow *_window;
}

/**
 *  蒙板：
 */
@property (nonatomic, weak) UIButton *coverButton;
/**
 *  导航条的titleView：
 */
@property (nonatomic, weak) JDCustomTitleView *titleButton;

@end

@implementation JDHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

/**
 *  初始化导航栏：
 */
-(void)setupNavigationBar {
    // 设置导航条：
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:nil normalImageName:@"navigationbar_friendsearch" highlightedImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(clickToSearchFriends:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:nil normalImageName:@"navigationbar_pop" highlightedImageName:@"navigationbar_pop_highlighted" target:self action:@selector(clickToUseCamera:)];
    // 设置titleView：
    JDCustomTitleView *titleBtn = [[JDCustomTitleView alloc] init];
    [self.navigationItem setTitleView:titleBtn];
    [titleBtn addTarget:self action:@selector(clickToAlertMenuBar:) forControlEvents:UIControlEventTouchUpInside];
    self.titleButton = titleBtn;
}

/**
 *  点击弹出菜单条：
 *
 *  @param sender
 */
-(void)clickToAlertMenuBar:(UIButton *)sender {
    JDLog(@"点击了弹出菜单条....");
    sender.selected = YES;
    [self setupMenuBar];
}

/**
 *  初始化菜单条：
 */
-(void)setupMenuBar {
    // 菜单条的尺寸计算：
    CGFloat menuWidth = 217;
    CGFloat menuHeight = 350;
    CGFloat menuMargin = 11;
    CGFloat menuX = 0;
    CGFloat menuY = 66 - menuMargin;
    // 菜单条中显示内容的tableView尺寸的计算：
    CGFloat contentMarginX = 20;
    CGFloat contentMarginY = 30;
    CGFloat contentWidth = menuWidth - contentMarginX;
    CGFloat contentHeight = menuHeight - contentMarginY;
    CGFloat contentX = contentMarginX * 0.5;
    CGFloat contentY = contentMarginY * 0.55;
    
    // 菜单条：
    UIImageView *menuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_background"]];
    menuImageView.frame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    menuImageView.centerX = JDScreenWidth * 0.5;
    menuImageView.userInteractionEnabled = YES;
    // 显示内容的tableView：
    UITableView *contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(contentX, contentY, contentWidth, contentHeight)];
    [menuImageView addSubview:contentTableView];
    
    // 添加蒙板，实现点击屏幕除菜单条外的任意位置，收起菜单条的效果：
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:JDScreenBounds];
    [coverBtn setBackgroundColor:[UIColor clearColor]];
    [coverBtn addSubview:menuImageView];
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:coverBtn];
    [coverBtn addTarget:self action:@selector(clickToCloseMenuBar:) forControlEvents:UIControlEventTouchUpInside];
    self.coverButton = coverBtn;
}

/**
 *  点击收起菜单条：
 */
-(void)clickToCloseMenuBar:(UIButton *)sender {
    JDLog(@"点击了收起菜单条....");
    // 销毁window：
    self.titleButton.selected = NO;
    [self.coverButton removeFromSuperview];
    _window = nil;
}

/**
 *  点击进入查找好友界面：
 *
 *  @param sender
 */
-(void)clickToSearchFriends:(UIButton *)sender {
    JDLog(@"点击了查找好友按钮....");
    
}

/**
 *  点击启动相机进入扫码界面：
 *
 *  @param sender
 */
-(void)clickToUseCamera:(UIButton *)sender {
    JDLog(@"点击了启动相机按钮....");
    // 从SB中加载控制器：
    UIStoryboard *scanSB = [UIStoryboard storyboardWithName:@"JDScanCodeController" bundle:nil];
    JDScanCodeController *scanVC = [scanSB instantiateInitialViewController];
    [self presentViewController:scanVC animated:YES completion:nil];
}

@end
