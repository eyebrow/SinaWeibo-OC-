

//
//  JDTextToolsView.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/4.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDTextToolsView.h"

@implementation JDTextToolsView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTextToolsView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTextToolsView];
    }
    return self;
}

/**
 *  初始化输入工具条：
 */
-(void)setupTextToolsView {
    // 创建按钮：
    [self createButtonWithNormalImageName:@"compose_toolbar_picture" andHighlightedImageName:@"compose_toolbar_picture_highlighted"];
    [self createButtonWithNormalImageName:@"compose_mentionbutton_background" andHighlightedImageName:@"compose_mentionbutton_background_highlighted"];
    [self createButtonWithNormalImageName:@"compose_trendbutton_background" andHighlightedImageName:@"compose_trendbutton_background_highlighted"];
    [self createButtonWithNormalImageName:@"compose_emoticonbutton_background" andHighlightedImageName:@"compose_emoticonbutton_background_highlighted"];
    [self createButtonWithNormalImageName:@"compose_keyboardbutton_background" andHighlightedImageName:@"compose_keyboardbutton_background_highlighted"];
}

/**
 *  调用方法，创建新的按钮：
 *
 *  @param norImageName
 *  @param highImageName
 */
-(void)createButtonWithNormalImageName:(NSString *)norImageName andHighlightedImageName:(NSString *)highImageName {
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    [btn setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickToUseTools:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickToUseTools:(UIButton *)btn {
    JDLog(@"%s", __func__);
}

/**
 *  设置子控件的frame：
 */
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.width / self.subviews.count;
    CGFloat height = self.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    NSInteger index = 0;
    for (UIButton *btn in self.subviews) {
        x = index * width;
        btn.frame = CGRectMake(x, y, width, height);
        index++;
    }
}

@end
