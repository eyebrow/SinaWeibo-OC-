//
//  UIImage+JDExtension.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "UIImage+JDExtension.h"

@implementation UIImage (JDExtension)

-(UIImage *)getOriginalImage {
    UIImage *image = [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
