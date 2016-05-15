

//
//  JDComposeToolsBar.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/15.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDComposeToolsBar.h"

#define kButtonsCount 5

@interface JDComposeToolsBar ()

/**
 *  用于封装普通状态图片：
 */
@property (nonatomic, strong) NSArray *normalImagesArray;
/**
 *  封装高亮状态图片：
 */
@property (nonatomic, strong) NSArray *highlightedImagesArray;

@end

@implementation JDComposeToolsBar

-(NSArray *)normalImagesArray {
    if (!_normalImagesArray) {
        _normalImagesArray = @[[UIImage imageNamed:@"compose_toolbar_picture"],
                               [UIImage imageNamed:@"compose_mentionbutton_background"],
                               [UIImage imageNamed:@"compose_trendbutton_background"],
                               [UIImage imageNamed:@"compose_emoticonbutton_background"],
                               [UIImage imageNamed:@"compose_keyboardbutton_background"]];
    }
    return _normalImagesArray;
}

-(NSArray *)highlightedImagesArray {
    if (!_highlightedImagesArray) {
        _highlightedImagesArray = @[[UIImage imageNamed:@"compose_toolbar_picture_highlighted"],
                                    [UIImage imageNamed:@"compose_mentionbutton_background_highlighted"],
                                    [UIImage imageNamed:@"compose_trendbutton_background_highlighted"],
                                    [UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"],
                                    [UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"]];
    }
    return _highlightedImagesArray;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupComposeToolsBar];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupComposeToolsBar];
    }
    return self;
}

/**
 *  初始化ComposeToolsBar：
 */
-(void)setupComposeToolsBar {
    // 创建5个按钮并设置图片：
    for (int i = 0; i < kButtonsCount; i++) {
        UIButton *toolBtn = [[UIButton alloc] init];
        UIImage *norImage = self.normalImagesArray[i];
        UIImage *highImage = self.highlightedImagesArray[i];
        [toolBtn setImage:norImage forState:UIControlStateNormal];
        [toolBtn setImage:highImage forState:UIControlStateHighlighted];
        [self addSubview:toolBtn];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.width / kButtonsCount;
    CGFloat height = self.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < kButtonsCount; i++) {
        UIButton *toolBtn = self.subviews[i];
        x = i * width;
        toolBtn.frame = CGRectMake(x, y, width, height);
    }
}

@end
