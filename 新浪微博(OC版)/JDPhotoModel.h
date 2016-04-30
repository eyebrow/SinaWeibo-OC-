//
//  JDPhotoModel.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/30.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDPhotoModel : NSObject

/** 缩略图 */
@property (nonatomic, copy) NSString *thumbnail_pic;
/**
 *  中等图：
 */
@property (nonatomic, copy) NSString *bmiddle_pic;

@end
