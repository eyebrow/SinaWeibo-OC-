//
//  JDCustomTabBar.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDCustomTabBar;

@protocol JDCustomTabBarDelegate <NSObject>

/**
 *  执行此代理方法，实现控制器之间的切换：
 *
 *  @param customTabBar self
 *  @param startPoint   上一个button的tag；
 *  @param endPoint     当前button的tag。
 */
-(void)customTabBar:(JDCustomTabBar *)customTabBar didClickWithStartPoint:(NSInteger)startPoint endPoint:(NSInteger)endPoint;
/**
 *  执行此代理方法，进入撰写微博界面：
 *
 *  @param customTabBar
 *  @param composeBtn   
 */
-(void)customTabBar:(JDCustomTabBar *)customTabBar didClickComposeButton:(UIButton *)composeBtn;

@end

@interface JDCustomTabBar : UIView

/**
 *  用于提取属性的item：
 */
@property (nonatomic, strong) UITabBarItem *item;
/**
 *  代理：
 */
@property (nonatomic, weak) id<JDCustomTabBarDelegate> delegate;

@end
