//
//  UIBarButtonItem+JDExtension.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JDExtension)

/**
 *  根据提供的属性，创建barButtonItem：
 *
 *  @param title         标题；
 *  @param norImageName  普通图片；
 *  @param highImageName 高亮图片；
 *  @param target        目标；
 *  @param selector      执行的方法。
 *
 *  @return UIBarButtonItem。
 */
+(UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)norImageName highlightedImageName:(NSString *)highImageName target:(id)target action:(SEL)selector;

@end
