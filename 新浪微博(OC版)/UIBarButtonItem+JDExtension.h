//
//  UIBarButtonItem+JDExtension.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/25.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JDExtension)

/**
 *  根据图片素材，创建自定义的barButtonItem：
 *
 *  @param norImageName  图片1；
 *  @param highImageName 图片2；
 *  @param target        目标；
 *  @param action        执行的方法。
 *
 *  @return 
 */
+(UIBarButtonItem *)crateBarButtonItemWithNormalImageName:(NSString *)norImageName andHighlightedImageName:(NSString *)highImageName andTarget:(id)target andAction:(SEL)action;

@end
