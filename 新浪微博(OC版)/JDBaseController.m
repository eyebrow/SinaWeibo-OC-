
//
//  JDBaseController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/28.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBaseController.h"
#import "JDNavigationController.h"
#import "JDOAuthController.h"
#import "JDAccountModel.h"

@interface JDBaseController () <JDDefaultCenterViewDelegate>

@end

@implementation JDBaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.defaultCenterView.delegate = self;
}

/**
 *  页面加载完成后调用：
 */
-(void)loadView {
    // 解档：
    JDAccountModel *account = [JDAccountModel getAccountInfo];
    // 如果已经授权则进入主页，没有授权则进入登录页面：
    if (!account) {
        JDDefaultCenterView *defaultCenterView = [JDDefaultCenterView getDefaultCenter];
        self.view = defaultCenterView;
        self.defaultCenterView = defaultCenterView;
    } else {
        [super loadView];
    }
}

#pragma mark - JDDefaultCenterViewDelegate

-(void)defaultCenterView:(JDDefaultCenterView *)defaultCenterView didClickRegistButton:(UIButton *)registBtn {
    JDLog(@"%s", __func__);
}

-(void)defaultCenterView:(JDDefaultCenterView *)defaultCenterView didClickLoginButton:(UIButton *)loginBtn {
    JDLog(@"%s", __func__);
    // 进入OAuth授权界面：
    JDOAuthController *OAuthVC = [[JDOAuthController alloc] init];
    JDNavigationController *navVC = [[JDNavigationController alloc] initWithRootViewController:OAuthVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end
