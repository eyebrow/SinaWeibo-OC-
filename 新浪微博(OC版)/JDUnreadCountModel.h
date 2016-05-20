//
//  JDUnreadCountModel.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/19.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDUnreadCountModel : NSObject

/**
 *  新微博未读数
 */
@property (nonatomic, assign) NSNumber *status;
/**
 *  新粉丝数
 */
@property (nonatomic, assign) NSNumber *follower;
/**
 *  新评论数
 */
@property (nonatomic, assign) NSNumber *cmt;
/**
 *  新私信数
 */
@property (nonatomic, assign) NSNumber *dm;
/**
 *  新提及我的微博数
 */
@property (nonatomic, assign) NSNumber *mention_cmt;
/**
 *  新提及我的评论数
 */
@property (nonatomic, assign) NSNumber *mention_status;

@end
