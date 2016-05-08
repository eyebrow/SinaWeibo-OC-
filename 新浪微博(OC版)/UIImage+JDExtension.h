//
//  UIImage+JDExtension.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JDExtension)

/**
 *  获得原始图片：
 *
 *  @param image 需要修改的图片。
 *
 *  @return 修改完成的图片。
 */
-(UIImage *)getOriginalImage;

@end
