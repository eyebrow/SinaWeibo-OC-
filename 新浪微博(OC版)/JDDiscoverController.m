//
//  JDDiscoverController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDDiscoverController.h"
#import "JDCustomSearchBar.h"

@interface JDDiscoverController () <UITextFieldDelegate>

/**
 *  自定义的searchBar：
 */
@property (nonatomic, weak) JDCustomSearchBar *searchBar;

@end

@implementation JDDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDiscoverController];
}

/**
 *  初始化发现界面：
 */
-(void)setupDiscoverController {
    // 替换titleView为自定义searchBar：
    CGFloat width = JDScreenWidth * 0.85;
    CGFloat height = 33;
    JDCustomSearchBar *searchBar = [[JDCustomSearchBar alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    searchBar.leftViewIconName = @"searchbar_searchlist_search_icon";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
}

#pragma mark - UITextFieldDelegate:

// 进入编辑时调用：
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // 右侧添加取消按钮：
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCancelEditting:)];
    // 更换textField左侧图标：
    self.searchBar.leftViewIconName = @"settings_statistic_triangle";
}

/**
 *  点击取消编辑：
 *
 *  @param sender
 */
-(void)clickToCancelEditting:(UIBarButtonItem *)sender {
    JDLog(@"点击了取消编辑的按钮....");
    [self.searchBar endEditing:YES];
    // 图标还原：
    self.searchBar.leftViewIconName = @"searchbar_searchlist_search_icon";
    // 取消
    self.navigationItem.rightBarButtonItem = nil;
}

// 拖拽tableView时，取消编辑模式：
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self clickToCancelEditting:nil];
}

@end
