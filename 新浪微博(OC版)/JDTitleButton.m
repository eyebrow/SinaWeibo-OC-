//
//  JDTitleButton.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/26.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDTitleButton.h"

@implementation JDTitleButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTitleButton];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTitleButton];
    }
    return self;
}

/**
 *  设置标题按钮属性：
 */
-(void)setupTitleButton {
    [self setTitle:@"首页" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self sizeToFit];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    // 交换标题和图表的位置：
    self.titleLabel.x = self.imageView.x;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
}

@end
