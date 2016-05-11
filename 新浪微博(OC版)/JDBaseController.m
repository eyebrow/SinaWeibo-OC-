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
    JDWelcomeView *welcomView = [JDWelcomeView getWelcomeViewFromXib];
    welcomView.delegate = self;
    self.view = welcomView;
    self.welcomView = welcomView;
}

#pragma mark - JDWelcomeViewDelegate:

-(void)loginWithWelcomeView:(JDWelcomeView *)welcomeView loginButton:(UIButton *)loginButton {
    JDLoginController *loginVC = [[JDLoginController alloc] init];
    JDNavigationController *navVC = [[JDNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

@end
