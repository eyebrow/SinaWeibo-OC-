//
//  JDAccountModel.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/13.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDAccountModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define kFilePath [@"account.data" getFilePathFromDocumentDirectory]

@implementation JDAccountModel

-(BOOL)svaeAccountToSandbox {
    // 模型存入沙盒：
    NSString *filePath = kFilePath;
    // 生成过期时间：
    self.expires_time = [[NSDate date] dateByAddingTimeInterval:self.expires_in.doubleValue];
    // 归档：
    return [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

+(instancetype)getAccountFromSandbox {
    NSString *filepath = kFilePath;
    JDAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    // 判断授权是否过期：
    // 如果当前时间已经大于了授权期限，则表示授权过期：
    if ([[NSDate date] compare:account.expires_time] == NSOrderedDescending) {
        // 授权过期则返回nil，提醒用户重新授权：
        return nil;
    }
    return account;
}

// 运行时代码，用于归档和解档：
MJCodingImplementation

@end
