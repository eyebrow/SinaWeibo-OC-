//
//  JDStatusModel.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/30.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDUserModel;

@interface JDStatusModel : NSObject

/** 字符串型的微博ID */
@property (nonatomic, copy) NSString *idstr;
/** 微博信息内容 */
@property (nonatomic, copy) NSString *text;
/** 微博创建时间 */
@property (nonatomic, copy) NSString *created_at;
/** 微博来源 */
@property (nonatomic, copy) NSString *source;

/** 转发数 */
@property (nonatomic, assign) NSNumber *reposts_count;
/** 评论数 */
@property (nonatomic, assign) NSNumber *comments_count;
/** 表态数(赞) */
@property (nonatomic, assign) NSNumber *attitudes_count;

/** 微博作者的用户信息字段 */
@property (nonatomic, strong) JDUserModel *user;

/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property (nonatomic, strong) JDStatusModel *retweeted_status;

/** 微博配图地址。多图时返回多图链接。无配图返回“[]” */
@property (nonatomic, strong) NSArray *pic_urls;

@end
