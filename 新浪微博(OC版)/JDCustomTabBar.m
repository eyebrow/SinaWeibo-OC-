
//
//  JDCustomTabBar.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDCustomTabBar.h"
#import "JDCustomTabBarItem.h"

@interface JDCustomTabBar ()

/**
 *  最中间的发微博按钮：
 */
@property (nonatomic, strong) UIButton *composeButton;
/**
 *  用于存放自定义item的数组：
 */
@property (nonatomic, strong) NSMutableArray *customItemsArray;

@end

@implementation JDCustomTabBar

-(NSMutableArray *)customItemsArray {
    if (!_customItemsArray) {
        _customItemsArray = [NSMutableArray array];
    }
    return _customItemsArray;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupCustomTabBar];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomTabBar];
    }
    return self;
}

-(void)setupCustomTabBar {
    [self createComposeButton];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.alpha = 0.85f;
}

/**
 *  重写item的setter方法，用将item的属性赋予自定的item(实质是UIButton)：
 *
 *  @param item
 */
-(void)setItem:(UITabBarItem *)item {
    _item = item;
    // 根据传入的item，对button进行赋值：
    JDCustomTabBarItem *customItem = [[JDCustomTabBarItem alloc] init];
    [customItem setImage:item.image forState:UIControlStateNormal];
    [customItem setImage:item.selectedImage forState:UIControlStateSelected];
    [customItem setTitle:item.title forState:UIControlStateNormal];
    [customItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [customItem setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [self addSubview:customItem];
    // 存入数组：
    [self.customItemsArray addObject:customItem];
}

/**
 *  创建发送按钮：
 */
-(void)createComposeButton {
    UIButton *composeBtn = [[UIButton alloc] init];
    [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [composeBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [composeBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [composeBtn sizeToFit];
    self.composeButton = composeBtn;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

@end
