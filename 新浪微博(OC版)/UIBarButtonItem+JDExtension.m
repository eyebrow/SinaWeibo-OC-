//
//  UIBarButtonItem+JDExtension.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/9.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "UIBarButtonItem+JDExtension.h"

@implementation UIBarButtonItem (JDExtension)

+(UIBarButtonItem *)createBarButtonItemWithTitle:(NSString *)title normalImageName:(NSString *)norImageName highlightedImageName:(NSString *)highImageName target:(id)target action:(SEL)selector {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

@end
