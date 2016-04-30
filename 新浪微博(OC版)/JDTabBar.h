//
//  JDTabBar.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/24.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDButton, JDTabBar;

@protocol JDTabBarDelegate <NSObject>

/**
 *  点击按钮调用的代理：
 *
 *  @param tabBar 当前tabBar；
 *  @param button 点击的按钮；
 *  @param start  上一个按钮的tag；
 *  @param end    当前点击按钮的tag。
 */
-(void)tabBar:(JDTabBar *)tabBar didClickButton:(JDButton *)button from:(NSInteger)start to:(NSInteger)end;
/**
 *  点击中间的发微博按钮执行的代理：
 *
 *  @param tabBar
 *  @param addBtn 
 */
-(void)tabBar:(JDTabBar *)tabBar didClickAddButton:(UIButton *)addBtn;

@end

@interface JDTabBar : UIView

/**
 *  用于接收子控制器的tabBar属性：
 */
@property (nonatomic, strong) UITabBarItem *item;
/**
 *  代理：
 */
@property (nonatomic, weak) id<JDTabBarDelegate> delegate;

@end
