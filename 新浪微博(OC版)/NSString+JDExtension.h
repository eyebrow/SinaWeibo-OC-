//
//  NSString+JDExtension.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/29.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JDExtension)

/**
 *  追加文档目录：
 */
-(NSString *)appendDocmentDirectory;
/**
 *  追加缓存目录：
 */
-(NSString *)appendCacheDirectory;
/**
 *  追加临时文件目录：
 */
-(NSString *)appendTempDirectory;

@end
