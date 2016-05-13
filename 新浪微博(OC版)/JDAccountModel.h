//
//  JDAccountModel.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/13.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDAccountModel : NSObject

/**
 "access_token" = "2.00YZiQPG0NblGWd1f815e6a40ecXFR";
 "expires_in" = 157679999;
 "remind_in" = 157679999;
 uid = 5722426620;
 */

/**
 *  访问令牌：
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  xx秒后过期：
 */
@property (nonatomic, strong) NSNumber *expires_in;
/**
 *  xx秒后提醒过期：
 */
@property (nonatomic, strong) NSNumber *remind_in;
/**
 *  用户ID：
 */
@property (nonatomic, strong) NSNumber *uid;
/**
 *  真实过期时间：
 */
@property (nonatomic, strong) NSDate *expires_time;

/**
 *  保存授权模型到沙盒：
 *
 *  @return
 */
-(BOOL)svaeAccountToSandbox;

/**
 *  从沙盒获取授权模型：
 *
 *  @return
 */
+(instancetype)getAccountFromSandbox;

@end
