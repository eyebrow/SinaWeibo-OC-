//
//  UIBarButtonItem+JDExtension.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/25.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "UIBarButtonItem+JDExtension.h"

@implementation UIBarButtonItem (JDExtension)

+(UIBarButtonItem *)crateBarButtonItemWithNormalImageName:(NSString *)norImageName andHighlightedImageName:(NSString *)highImageName andTarget:(id)target andAction:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    [button sizeToFit];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return barBtnItem;
}

@end
