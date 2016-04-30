//
//  JDMenuBar.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/27.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDMenuBar.h"

@interface JDMenuBar () {
    UIWindow *_window;
    UIViewController *_contentVC;
}

/**
 *  蒙板：
 */
@property (nonatomic, weak) UIButton *coverBtn;

@end

@implementation JDMenuBar

-(void)putTheMenuBarToTargetView:(UIView *)targetView withContentView:(UIView *)contentView {
//    _contentView = contentView;
    /**
     为了确保window的优先级，让弹出的菜单条始终在最上面，所以这里创建一个新window。
     */
    _window = [[UIWindow alloc] initWithFrame:UIScreenBounds];
    _window.hidden = NO;
    // 设置优先级：
    _window.windowLevel = UIWindowLevelAlert;
    
    // 创建蒙板：
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:UIScreenBounds];
    [_window addSubview:coverBtn];
    [coverBtn addTarget:self action:@selector(clickToCancelTheMenuBar:) forControlEvents:UIControlEventTouchUpInside];
    self.coverBtn = coverBtn;
    
    // 设置contentView的内边距：
    contentView.x = 10;
    contentView.y = 15;
    
    // 将targetView的坐标转换到和menuImageView同一个坐标系：
    CGRect resultFrame = [_window convertRect:targetView.frame fromView:targetView.superview];
    CGPoint resultPoint = [_window convertPoint:targetView.center fromView:targetView.superview];
    
    // 创建菜单：
    CGFloat width = CGRectGetMaxX(contentView.frame) + contentView.x;
    CGFloat height = CGRectGetMaxY(contentView.frame) + contentView.y;
    UIImageView *menuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    menuImageView.y = CGRectGetMaxY(resultFrame) + 2;
    menuImageView.centerX = resultPoint.x;
    menuImageView.userInteractionEnabled = YES;
    menuImageView.image = [UIImage imageNamed:@"popover_background"];
    
    // 添加：
    [_window addSubview:coverBtn];
    [coverBtn addSubview:menuImageView];
    [menuImageView addSubview:contentView];
}

/**
 *  点击取消菜单栏：
 *
 *  @param sender
 */
-(void)clickToCancelTheMenuBar:(UIButton *)sender {
    JDLog(@"%s", __func__);
    _window = nil;
    [self.coverBtn removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(menuBarDidCancel:)]) {
        [self.delegate menuBarDidCancel:self];
    }
}

@end
