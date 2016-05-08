//
//  JDCustomTabBarItem.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDCustomTabBarItem.h"

// self的宽度：
#define kContentWidth contentRect.size.width
// self的高度：
#define kContentHeight contentRect.size.height

@implementation JDCustomTabBarItem

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupCustomTabBarItem];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCustomTabBarItem];
    }
    return self;
}

/**
 *  初始化自定义item：
 */
-(void)setupCustomTabBarItem {
    // 标题：
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    // 图片：
    self.imageView.contentMode = UIViewContentModeCenter;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

/**
 *  重写setter方法，为按钮设置属性：
 *
 *  @param item
 */
-(void)setItem:(UITabBarItem *)item {
    _item = item;
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setTitle:item.title forState:UIControlStateNormal];
}

/**
 *  因为按钮点击时，系统会默认调用这个方法进行一些操作，现在取消这些操作只需重写此方法即可：
 *
 *  @param highlighted
 */
-(void)setHighlighted:(BOOL)highlighted {
//    JDLog(@"%s", __func__);
}

#warning 修改按钮标题和图片位置时，必须用方法传入的contentRect，而不能直接用self，否则方法无效。
// 修改按钮标题的位置：
-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat width = kContentWidth;
    CGFloat height = kContentHeight - kContentHeight * 0.65;
    CGFloat x = 0;
    CGFloat y = kContentHeight * 0.58;
    return CGRectMake(x, y, width, height);
}

// 修改按钮图片的位置：
-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = kContentWidth;
    CGFloat height = kContentHeight * 0.58;
    CGFloat x = 0;
    CGFloat y = 0;
    return CGRectMake(x, y, width, height);
}

@end
