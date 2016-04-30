//
//  JDSearchBar.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/27.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDSearchBar.h"

@implementation JDSearchBar

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSearchBar];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSearchBar];
    }
    return self;
}

/**
 *  初始化searchBar：
 */
-(void)setupSearchBar {
    self.borderStyle = UITextBorderStyleRoundedRect;
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_searchlist_search_icon"]];
    self.leftView = iconImageView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode  = UITextFieldViewModeWhileEditing;
}

-(void)setLeftViewImageName:(NSString *)leftViewImageName {
    _leftViewImageName = leftViewImageName;
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leftViewImageName]];
    iconImageView.width = 25;
    iconImageView.contentMode = UIViewContentModeCenter;
    self.leftView = iconImageView;
}

@end
