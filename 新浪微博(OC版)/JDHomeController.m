
//
//  JDHomeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDHomeController.h"

@interface JDHomeController ()

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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:nil normalImageName:@"navigationbar_friendsearch" highlightedImageName:@"navigationbar_friendsearch_highlighted" target:self action:@selector(clickToSearchFriends:)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem createBarButtonItemWithTitle:nil normalImageName:@"navigationbar_pop" highlightedImageName:@"navigationbar_pop_highlighted" target:self action:@selector(clickToUseCamera:)];
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
}

@end
