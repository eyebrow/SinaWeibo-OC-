//
//  UIImage+JDExtension.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/25.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "UIImage+JDExtension.h"

@implementation UIImage (JDExtension)

+(UIImage *)getOriginalImgaeWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
