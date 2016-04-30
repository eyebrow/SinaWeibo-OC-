//
//  NSString+JDExtension.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/29.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "NSString+JDExtension.h"

@implementation NSString (JDExtension)

-(NSString *)appendTempDirectory {
    return [self appendDirectory:NSTemporaryDirectory()];
}

-(NSString *)appendCacheDirectory {
    return [self appendDirectory:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
}

-(NSString *)appendDocmentDirectory {
    return [self appendDirectory:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}

/**
 *  传入文档路径，追加在字符串前边：
 *
 *  @param directory
 *
 *  @return
 */
-(NSString *)appendDirectory:(NSString *)directory {
    return [directory stringByAppendingPathComponent:self];
}

@end
