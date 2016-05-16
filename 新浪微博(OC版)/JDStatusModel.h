//
//  JDStatusModel.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDUserModel, JDStatusModel;

@interface JDStatusModel : NSObject

/**
 *  微博ID：
 */
@property (nonatomic, copy) NSString *idstr;
/**
 *  微博正文：
 */
@property (nonatomic, copy) NSString *text;
/**
 *  微博创建时间：
 */
@property (nonatomic, copy) NSString *created_at;
/**
 *  微博来源：
 */
@property (nonatomic, copy) NSString *source;
/**
 *  转发数；
 */
@property (nonatomic, strong) NSNumber *reposts_count;
/**
 *  评论数：
 */
@property (nonatomic, strong) NSNumber *comments_count;
/**
 *  赞数：
 */
@property (nonatomic, strong) NSNumber *attitudes_count;

/**
 *  用户模型：
 */
@property (nonatomic, strong) JDUserModel *user;
/**
 *  被转发的微博模型：
 */
@property (nonatomic, strong) JDStatusModel *retweeted_status;
/**
 *  微博配图的地址：
 */
@property (nonatomic, strong) NSArray *pic_urls;

@end
