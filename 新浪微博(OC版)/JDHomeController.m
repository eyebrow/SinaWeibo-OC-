
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
#import "JDMenuContentController.h"

@interface JDHomeController () {
    UIWindow *_window;
    JDMenuContentController *_contentVC;
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
    // 按钮选中：
    sender.selected = YES;
    // 创建显示内容的view：
    _contentVC = [[JDMenuContentController alloc] init];
    // 创建菜单条：
    CGFloat width = 217;
    CGFloat height = 350;
    [self setupMenuBarWithTargetView:self.navigationController.navigationBar contentView:_contentVC.view width:width height:height];
}

/**
 *  初始化菜单条：
 *
 *  @param targetView  菜单条弹出后需要指向的view；
 *  @param contentView 菜单条中显示内容的view；
 *  @param height 菜单条的高度。
 */
-(void)setupMenuBarWithTargetView:(UIView *)targetView contentView:(UIView *)contentView width:(CGFloat)width height:(CGFloat)height {
    // 添加蒙板，实现点击屏幕除菜单条外的任意位置，收起菜单条的效果：
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:JDScreenBounds];
    [coverBtn setBackgroundColor:[UIColor clearColor]];
#warning UIWindow不要乱创建，能用.keyWindow获取的就尽量这么做。
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:coverBtn];
    
    // 菜单条的尺寸计算：
    CGFloat menuWidth = width;
    CGFloat menuHeight = height;
    CGFloat menuMargin = 9;
    CGFloat menuX = 0;
    CGFloat menuY = 0;
    // 菜单条中显示内容的tableView尺寸的计算：
    CGFloat contentMarginX = 20;
    CGFloat contentMarginY = 30;
    CGFloat contentWidth = menuWidth - contentMarginX;
    CGFloat contentHeight = menuHeight - contentMarginY;
    CGFloat contentX = contentMarginX * 0.5;
    CGFloat contentY = contentMarginY * 0.56;
    
    // 菜单条：
    UIImageView *menuImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_background"]];
    menuImageView.frame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    menuImageView.userInteractionEnabled = YES;
    // 显示内容的view：
    contentView.frame = CGRectMake(contentX, contentY, contentWidth, contentHeight);
    [menuImageView addSubview:contentView];
    
    // 后续操作：
    [coverBtn addSubview:menuImageView];
    [coverBtn addTarget:self action:@selector(clickToCloseMenuBar:) forControlEvents:UIControlEventTouchUpInside];
    // 由于需要指向的目标view的superView可能和菜单条所在superView不是同一个，这也就意味着双方不在同一个坐标系中，此时就必须用到坐标系的转换：
    CGRect resultRect = [_window convertRect:targetView.frame fromView:targetView.superview];
    CGPoint resultPoint = [_window convertPoint:targetView.center fromView:targetView.superview];
    menuImageView.y = CGRectGetMaxY(resultRect) - menuMargin;
    menuImageView.centerX = resultPoint.x;
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
    _contentVC = nil;
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
