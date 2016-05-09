
//
//  JDQRCodeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDQRCodeController.h"

@interface JDQRCodeController ()

/**
 *  二维码扫描图片约束的Y值：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeConstraintY;
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation JDQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRCodeController];
}

/**
 *  初始化JDQRCodeController：
 */
-(void)setupRCodeController {
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode"]];
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrcode_tabbar_icon_qrcode_highlighted"] getOriginalImage]];
    [self.navigationController.tabBarController.tabBar setTintColor:[UIColor orangeColor]];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(scanning)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

/**
 *  扫描过程执行的方法：
 */
-(void)scanning {
    self.QRCodeConstraintY.constant += 5;
    if (self.QRCodeConstraintY.constant >= 170) {
        self.QRCodeConstraintY.constant = -170;
    }
}

@end
