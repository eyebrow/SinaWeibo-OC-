//
//  JDProfileController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDProfileController.h"
#import "JDWelcomeView.h"

@interface JDProfileController ()

@end

@implementation JDProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupProfileController];
}

-(void)setupProfileController {
    self.welcomView.wheelHidden = YES;
    self.welcomView.iconImageName = @"visitordiscover_image_profile";
    self.welcomView.infoText = @"登录后，你的微博、相册和个人资料都会展示给别人。";
    self.welcomView.infoTop = -5;
}

@end
