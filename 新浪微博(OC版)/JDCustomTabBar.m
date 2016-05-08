
//
//  JDCustomTabBar.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDCustomTabBar.h"
#import "JDCustomTabBarItem.h"

// self中一共有5个按钮：
#define kButtonsCount 5

@interface JDCustomTabBar ()

/**
 *  最中间的撰写微博按钮：
 */
@property (nonatomic, strong) UIButton *composeButton;
/**
 *  用于存放自定义item的数组：
 */
@property (nonatomic, strong) NSMutableArray *customItemsArray;
/**
 *  当前选中的button：
 */
@property (nonatomic, strong) UIButton *currentButton;

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

/**
 *  初始化自定义tabBar：
 */
-(void)setupCustomTabBar {
    [self createComposeButton];
    [self setBackgroundColor:[UIColor whiteColor]];
    self.alpha = 0.9f;
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
    customItem.item = item;
    [self addSubview:customItem];
    // 事件监听：
    [customItem addTarget:self action:@selector(clickToSwitchOtherViewController:) forControlEvents:UIControlEventTouchDown];
    // 存入数组：
    [self.customItemsArray addObject:customItem];
    // 默认首页按钮被选中：
    if (self.customItemsArray.count == 1) {
        [self clickToSwitchOtherViewController:customItem];
    }
}

/**
 *  点击选中按钮，并切换至相应控制器：
 *
 *  @param sender
 */
-(void)clickToSwitchOtherViewController:(UIButton *)sender {
    self.currentButton.selected = NO;
    sender.selected = YES;
    self.currentButton = sender;
}

/**
 *  创建撰写微博按钮：
 */
-(void)createComposeButton {
    UIButton *composeBtn = [[UIButton alloc] init];
    [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [composeBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [composeBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [composeBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:composeBtn];
    self.composeButton = composeBtn;
    // 事件监听：
    [composeBtn addTarget:self action:@selector(clickToComposeNewWeibo:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickToComposeNewWeibo:(UIButton *)sender {
    JDLog(@"点击了写微博的按钮....");
}

-(void)layoutSubviews {
    [super layoutSubviews];
    // 遍历self，拿到self中的所有子控件(自定义的item)，并设置尺寸：
    NSInteger index = 0;
    CGFloat width = self.width / kButtonsCount;
    CGFloat height = self.height;
    CGFloat x = 0;
    CGFloat y = 0;
    for (UIView *subview in self.subviews) {
#warning 由于不能保证self中的子控件就一定是JDCustomTabBarItem类型，所以必须进行判断后再设置，否则会引起位置错误。
        if ([subview isKindOfClass:[JDCustomTabBarItem class]]) {
            x = index * width;
            subview.frame = CGRectMake(x, y, width, height);
            // 为最中间的按钮空出位置：
            if (index == 1) {
                index++;
                x = index * width;
            }
            index++;
        }
    }
    // 设置中间按钮的位置：
    self.composeButton.centerX = self.centerX;
    self.composeButton.y = (self.height - self.composeButton.height) * 0.5;
    [self.composeButton sizeToFit];
}

@end
