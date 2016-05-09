
//
//  JDBarCodeController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDBarCodeController.h"

@interface JDBarCodeController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barCodeConstraintY;
@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation JDBarCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBarCodeController];
}

/**
 *  初始化JDBarCodeController：
 */
-(void)setupBarCodeController {
    [self.navigationController.tabBarItem setSelectedImage:[UIImage imageNamed:@"qrcode_tabbar_icon_barcode"]];
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"qrcode_tabbar_icon_barcode_highlighted"] getOriginalImage]];
    [self.navigationController.tabBarController.tabBar setTintColor:[UIColor orangeColor]];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(scanning)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
}

-(void)scanning {
    self.barCodeConstraintY.constant += 5;
    if (self.barCodeConstraintY.constant >= 128) {
        self.barCodeConstraintY.constant = -128;
    }
}

@end
