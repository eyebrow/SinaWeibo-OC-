//
//  NSString+JDExtension.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/13.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "NSString+JDExtension.h"

@implementation NSString (JDExtension)

-(NSString *)getFilePathFromDocumentDirectory {
    return [self appendFilePathWithDirectory:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
}

-(NSString *)getFilePathFromCachesDirectory {
    return [self appendFilePathWithDirectory:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
}

-(NSString *)getFilePathFromTemporaryDirectory {
    return [self appendFilePathWithDirectory:NSTemporaryDirectory()];
}

-(NSString *)appendFilePathWithDirectory:(NSString *)directory {
    return [directory stringByAppendingPathComponent:self];
}

@end
