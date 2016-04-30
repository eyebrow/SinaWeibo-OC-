//
//  JDTabBar.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDTabBar.h"
#import "JDButton.h"

// tabBar上的按钮总数：
#define kButtonsCount 5

@interface JDTabBar ()

/**
 *  用于记录当前被点击的按钮：
 */
@property (nonatomic, weak) JDButton *currentBtn;
/**
 *  加号按钮：
 */
@property (nonatomic, weak) UIButton *addBtn;
/**
 *  用于存储创建的按钮：
 */
@property (nonatomic, strong) NSMutableArray *btnsArray;

@end

@implementation JDTabBar

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTabBar];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTabBar];
    }
    return self;
}

/**
 *  懒加载：
 *
 *  @return
 */
-(NSMutableArray *)btnsArray {
    if (!_btnsArray) {
        _btnsArray = [NSMutableArray array];
    }
    return _btnsArray;
}

/**
 *  初始化自定义tabBar的一些属性：
 */
-(void)setupTabBar {
    [self setBackgroundColor:JDColor2(255, 251, 240, 0.9f)];
    [self createAddButton];
}

/**
 *  创建tabBar上的按钮：
 */
-(void)setItem:(UITabBarItem *)item {
    _item = item;
    JDButton *itemBtn = [[JDButton alloc] init];
    itemBtn.item = item;
    [self addSubview:itemBtn];
    [itemBtn addTarget:self action:@selector(clickToSwitchToOtherViewController:) forControlEvents:UIControlEventTouchDown];
    // 将创建的button存入数组：
    itemBtn.tag = self.btnsArray.count;
    // 默认第一个按钮选中：
    if (itemBtn.tag == 0) {
        [self clickToSwitchToOtherViewController:itemBtn];
    }
    [self.btnsArray addObject:itemBtn];
}

/**
 *  点击按钮选中，并且调用代理切换到对应的控制器：
 *
 *  @param itemBtn
 */
-(void)clickToSwitchToOtherViewController:(JDButton *)itemBtn {
    // 执行代理：
    if ([self.delegate respondsToSelector:@selector(tabBar:didClickButton:from:to:)]) {
        [self.delegate tabBar:self didClickButton:itemBtn from:self.currentBtn.tag to:itemBtn.tag];
    }
    
    // 按钮选中状态：
    self.currentBtn.selected = NO;
    itemBtn.selected = YES;
    self.currentBtn = itemBtn;
    
    // 按钮缩放动画效果：
    [UIView animateWithDuration:0.16f animations:^{
        // sx和sy如果等于1为不缩放，默认为1：
        itemBtn.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.16f animations:^{
            itemBtn.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.16f animations:^{
                itemBtn.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            }];
        }];
    }];
}

/**
 *  设置按钮的尺寸：
 */
-(void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger index = 0;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnWidth = self.width / kButtonsCount;
    CGFloat btnHeight = self.height;
    
    for (JDButton *itemBtn in self.subviews) {
        // 循环添加除加号外的所有按钮：
        if (itemBtn.tag != 999) {
            btnX = btnWidth * index;
            itemBtn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
            // 为中间的加号按钮空出位置：
            if (index == 1) {
                index++;
                // 计算下一个按钮的x值：
                btnX = btnWidth * index;
            }
            index++;
        }
    }
    
    // 为加号按钮设置尺寸：
    self.addBtn.centerX = self.width * 0.5;
    self.addBtn.centerY = self.height * 0.5;
    self.addBtn.size = self.addBtn.currentBackgroundImage.size;
}

/**
 *  创建中间的加号按钮：
 */
-(void)createAddButton {
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [addBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [self addSubview:addBtn];
    addBtn.tag = 999;
    
    self.addBtn = addBtn;
    [addBtn addTarget:self action:@selector(clickToIntoComposePage:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  点击进入发送微博的界面：
 *
 *  @param addBtn
 */
-(void)clickToIntoComposePage:(UIButton *)addBtn {
    if ([self.delegate respondsToSelector:@selector(tabBar:didClickAddButton:)]) {
        [self.delegate tabBar:self didClickAddButton:addBtn];
    }
}

@end
