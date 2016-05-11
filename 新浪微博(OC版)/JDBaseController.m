//
//  JDBaseController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBaseController.h"
#import "JDWelcomeView.h"

@interface JDBaseController ()

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
    self.view = welcomView;
    self.welcomView = welcomView;
}

@end
