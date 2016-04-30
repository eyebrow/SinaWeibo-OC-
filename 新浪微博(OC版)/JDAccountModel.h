//
//  JDAccountModel.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/29.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDAccountModel : NSObject

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
 *  真正的过期时间：
 */
@property (nonatomic, strong) NSDate *expires_time;
/**
 *  用户头像地址：
 */
@property (nonatomic, copy) NSString *profile_image_url;

/**
 *  保存授权信息：
 */
-(BOOL)saveAccountInfo;
/**
 *  获取授权信息：
 *
 *  @return 授权模型
 */
+(instancetype)getAccountInfo;

@end
