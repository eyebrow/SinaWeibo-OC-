
//
//  JDCustomTitleView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/10.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDCustomTitleView.h"

@implementation JDCustomTitleView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupCustomTitleView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomTitleView];
    }
    return self;
}

/**
 *  初始化自定义titleView：
 */
-(void)setupCustomTitleView {
    [self setTitle:@"首页" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeCenter;
}

/**
 *  重新布局button中的子控件：
 */
-(void)layoutSubviews {
    [super layoutSubviews];
    // 交换title和imageView的位置：
    self.titleLabel.x = self.imageView.x;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 8;
    [self sizeToFit];
}

@end
