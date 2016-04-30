//
//  JDAccountModel.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/29.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDAccountModel.h"

@interface JDAccountModel ()

@end

@implementation JDAccountModel

/**
 *  归档和解档：
 */
MJCodingImplementation;

-(BOOL)saveAccountInfo {
    // 获取当前时间：
    NSDate *now = [NSDate date];
    self.expires_time = [now dateByAddingTimeInterval:[self.expires_in doubleValue]];
    return [NSKeyedArchiver archiveRootObject:self toFile:[@"account.data" appendDocmentDirectory]];
}

+(instancetype)getAccountInfo {
    JDAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[@"account.data" appendDocmentDirectory]];
    // 判断授权是否过期：
    NSDate *now = [NSDate date];
    // 如果授权过期则返回nil，让用户重新登录：
    if ([now compare:account.expires_time] != NSOrderedAscending) {
        return nil;
    }
    return account;
}

@end
