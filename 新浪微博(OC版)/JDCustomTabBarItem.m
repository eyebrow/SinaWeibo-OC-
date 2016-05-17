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

@interface JDCustomTabBarItem ()

@property (nonatomic, weak) UIButton *badgeButton;

@end

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
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    // 图片：
    self.imageView.contentMode = UIViewContentModeCenter;
    // 添加提示按钮：
    UIButton *badgeBtn = [[UIButton alloc] init];
    [badgeBtn setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
    [self addSubview:badgeBtn];
    badgeBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    badgeBtn.hidden = YES;
    self.badgeButton = badgeBtn;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.badgeButton.size = self.badgeButton.currentBackgroundImage.size;
    self.badgeButton.y = 0;
    self.badgeButton.x = self.width - self.badgeButton.width;
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
    
    // 利用KVO监听item值的改变：
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)dealloc {
    [_item removeObserver:self forKeyPath:@"badgeValue"];
}

/**
 *  被监听对象的值改变时代用此方法：
 *
 *  @param keyPath 被监听的属性；
 *  @param object  被监听的对象；
 *  @param change  改变的值；
 *  @param context 监听时传入的参数。
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    JDLog(@"%@", change);
    NSNumber *unreadsCount = change[@"new"];
    if (unreadsCount.integerValue > 0) {
        self.badgeButton.hidden = NO;
        if (unreadsCount.integerValue > 99) {
            [self.badgeButton setTitle:@"N" forState:UIControlStateNormal];
        } else {
            [self.badgeButton setTitle:[unreadsCount description] forState:UIControlStateNormal];
        }
    } else {
        self.badgeButton.hidden = YES;
    }
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
    CGFloat height = kContentHeight * 0.65;
    CGFloat x = 0;
    CGFloat y = 0;
    return CGRectMake(x, y, width, height);
}

@end
