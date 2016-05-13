//
//  NSString+JDExtension.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/13.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JDExtension)

/**-----------返回文件路径：-----------*/
-(NSString *)getFilePathFromDocumentDirectory;
-(NSString *)getFilePathFromCachesDirectory;
-(NSString *)getFilePathFromTemporaryDirectory;

/**
 *  根据传入的路径类型，返回文件路径：
 *
 *  @param directory 路径类型。
 *
 *  @return
 */
-(NSString *)appendFilePathWithDirectory:(NSString *)directory;

@end
