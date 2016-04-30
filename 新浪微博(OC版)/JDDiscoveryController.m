//
//  JDDiscoveryController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDDiscoveryController.h"
#import "JDSearchBar.h"

@interface JDDiscoveryController () <UITextFieldDelegate>

@end

@implementation JDDiscoveryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = UIScreenSize.width * 0.85;
    CGFloat height = 35;
    JDSearchBar *searchBar = [[JDSearchBar alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    searchBar.placeholder = @"请输入您感兴趣的内容";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

#pragma mark - UITextFieldDelegate 

/**
 *  文本框开始被编辑时调用：
 *
 *  @param textField
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    JDLog(@"%s", __func__);
    // 添加按钮：
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCancelSearch)];
    // 替换左侧图片：
    JDSearchBar *searchBar = (JDSearchBar *)textField;
    searchBar.leftViewImageName = @"settings_statistic_triangle";
}

/**
 *  文本框编辑结束时调用：
 *
 *  @param textField
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = nil;
    JDSearchBar *searchBar = (JDSearchBar *)textField;
    searchBar.leftViewImageName = @"searchbar_searchlist_search_icon";
}

/**
 *  点击取消搜索：
 */
-(void)clickToCancelSearch {
    JDLog(@"%s", __func__);
    // 关闭键盘：
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - scrollView delegate

/**
 *  tableView被拖拽时调用：
 *
 *  @param scrollView
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#

@end
