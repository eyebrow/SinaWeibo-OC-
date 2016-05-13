//
//  JDBaseController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBaseController.h"
#import "JDWelcomeView.h"
#import "JDLoginController.h"
#import "JDNavigationController.h"
#import "JDAccountModel.h"

@interface JDBaseController () <JDWelcomeViewDelegate>

@end

@implementation JDBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  更换控制器的view：
 */
-(void)loadView {
    // 从沙盒加载模型对象：
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    // 如果模型存在表示登录成功，则不会再加载游客欢迎界面：
    if (account) {
        JDLog(@"已授权....");
        [super loadView];
    } else {
        // 加载游客欢迎界面：
        JDWelcomeView *welcomView = [JDWelcomeView getWelcomeViewFromXib];
        welcomView.delegate = self;
        self.view = welcomView;
        self.welcomView = welcomView;
    }
}

#pragma mark - JDWelcomeViewDelegate:

-(void)loginWithWelcomeView:(JDWelcomeView *)welcomeView loginButton:(UIButton *)loginButton {
    JDLoginController *loginVC = [[JDLoginController alloc] init];
    JDNavigationController *navVC = [[JDNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end
