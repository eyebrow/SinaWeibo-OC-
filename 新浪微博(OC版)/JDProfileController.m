//
//  JDProfileController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDProfileController.h"

@interface JDProfileController ()

@end

@implementation JDProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置按钮：
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(clickToIntoSettingPage)];
    
    // 登录界面样式：
    if (self.defaultCenterView != nil) {
        self.defaultCenterView.iconImageName = @"visitordiscover_image_profile";
        self.defaultCenterView.infoText = @"登录后，你的微博、相册和个人资料都会展示给别人。";
        self.defaultCenterView.turntableHidden = YES;
    }
}

/**
 *  点击进入设置界面：
 */
-(void)clickToIntoSettingPage {
    JDLog(@"%s", __func__);
}

@end
