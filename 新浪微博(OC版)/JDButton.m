//
//  JDButton.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/25.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDButton.h"

#define contenWidth contentRect.size.width
#define contentHeight contentRect.size.height

@interface JDButton ()

@property (nonatomic, weak) UIButton *tipButton;

@end

@implementation JDButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupButton];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupButton];
    }
    return self;
}

/**
 *  初始化按钮的一些属性：
 */
-(void)setupButton {
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
    // 创建提醒按钮：
    UIButton *tipBtn = [[UIButton alloc] init];
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
    [tipBtn setBackgroundImage:[UIImage imageNamed:@"main_badge_draft"] forState:UIControlStateHighlighted];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:tipBtn];
    tipBtn.hidden = YES;
    self.tipButton = tipBtn;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.tipButton.size = self.tipButton.currentBackgroundImage.size;
    self.tipButton.y = 0;
    self.tipButton.x = self.width - self.tipButton.width;
}

/**
 *  为按钮的属性赋值：
 *
 *  @param item
 */
-(void)setItem:(UITabBarItem *)item {
    _item = item;
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setTitle:item.title forState:UIControlStateNormal];
    
    // 利用KVO监听tabbarItem属性的改变：
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  被监听对象的某个属性值改变时调用：
 *
 *  @param keyPath 被监听的属性；
 *  @param object  被监听的对象；
 *  @param change  改变的值；
 *  @param context 监听时传入的参数
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    JDLog(@"%s", __func__);
    NSNumber *unreadCount = change[@"new"];
    
    if (unreadCount.integerValue > 0) {
        self.tipButton.hidden = NO;
        if (unreadCount.integerValue > 99) {
            [self.tipButton setTitle:@"N" forState:UIControlStateNormal];
        } else {
            [self.tipButton setTitle:[unreadCount description] forState:UIControlStateNormal];
        }
    } else {
        self.tipButton.hidden = YES;
    }
}

-(void)dealloc {
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
}

/**
 *  重写highlighted方法，去掉按钮点击时的一些耗时操作：
 *
 *  @param highlighted
 */
-(void)setHighlighted:(BOOL)highlighted {
//    DDLogDebug(@"%s", __func__);
}

/**
 *  自定义按钮图片的位置：
 *
 *  @param contentRect
 *
 *  @return
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    CGFloat imgWidth = contenWidth;
    CGFloat imgHight = contentHeight * 0.6;
    return CGRectMake(imgX, imgY, imgWidth, imgHight);
}

/**
 *  自定义按钮标题的位置：
 *
 *  @param contentRect
 *
 *  @return 
 */
-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleY = contentHeight * 0.6;
    CGFloat titleWidth = contenWidth;
    CGFloat titleHeight = contentHeight - contentHeight * 0.6;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
