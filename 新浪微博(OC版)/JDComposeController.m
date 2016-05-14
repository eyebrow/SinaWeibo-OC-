//
//  JDComposeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDComposeController.h"
#import "JDComposeTextView.h"

@interface JDComposeController () <UITextViewDelegate>

@end

@implementation JDComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComposeController];
}

/**
 *  初始化：
 */
-(void)setupComposeController {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCloseComposePage:)];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(clickToConfirmSend:)];
    
    // 添加自定义textView：
    JDComposeTextView *textView = [[JDComposeTextView alloc] initWithFrame:self.view.bounds];
    // 设置提示文字：
    textView.placeholderText = @"请输入您想要发送的微博内容......";
    // 设置滚动：
    textView.delegate = self;
    [self.view addSubview:textView];
}

/**
 *  点击关闭撰写微博页面：
 *
 *  @param sender
 */
-(void)clickToCloseComposePage:(UIBarButtonItem *)sender {
    JDLog(@"点击了关闭撰写微博界面的按钮....");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击确认发送一条新微博：
 *
 *  @param sender
 */
-(void)clickToConfirmSend:(UIBarButtonItem *)sender {
    JDLog(@"点击了确认发送一条新微博的按钮....");
}

#pragma mark - UITextViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
