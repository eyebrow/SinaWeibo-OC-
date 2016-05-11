

//
//  JDCustomSearchBar.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDCustomSearchBar.h"

@implementation JDCustomSearchBar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomSearchBar];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupCustomSearchBar];
    }
    return self;
}

/**
 *  初始化searchBar：
 */
-(void)setupCustomSearchBar {
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.placeholder = @"赶紧输入您感兴趣的内容吧！！！";
//    self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_searchlist_search_icon"]];
    self.leftViewMode = UITextFieldViewModeUnlessEditing;
    // 设置清除按钮：
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

-(void)setLeftViewIconName:(NSString *)leftViewIconName {
    _leftViewIconName = leftViewIconName;
    CGFloat width = 23;
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftViewIconName]];
    iconImageView.width = width;
    iconImageView.contentMode = UIViewContentModeCenter;
    self.leftView = iconImageView;
}

@end
