//
//  JDMenuBar.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/27.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDMenuBar;

@protocol JDMenuBarDelegate <NSObject>

-(void)menuBarDidCancel:(JDMenuBar *)menuBar;

@end

@interface JDMenuBar : UIView

@property (nonatomic, weak) id<JDMenuBarDelegate> delegate;

/**
 *  让菜单条指向指定的控制器：
 *
 *  @param targetView  指定的控制器；
 *  @param contentView 显示内容的控制器。
 */
-(void)putTheMenuBarToTargetView:(UIView *)targetView withContentView:(UIView *)contentView;

@end
