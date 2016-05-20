//
//  JDNetworkTools.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/18.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class JDUserModel, JDStatusRequestModel, JDGetStatusModel, JDGetStatusResultModel;

/**
 *  正在请求时代用的block：
 *
 *  @param downloadProgress 下载进度。
 */
typedef void (^progress)(NSProgress *downloadProgress);
/**
 *  请求成功后调用的block：
 *
 *  @param responseObject 请求成功返回一个模型对象。
 */
typedef void (^success)(id object);
/**
 *  请求失败后调用的block：
 *
 *  @param error 失败信息。
 */
typedef void (^failure)(NSError *error);

@interface JDNetworkTools : AFHTTPSessionManager

/**
 *  网络工具类的单例：
 *
 *  @return 
 */
+(instancetype)shardNetworkTools;
/**
 *  加载用户数据：
 *
 *  @param progress
 *  @param success
 *  @param failure
 */
-(void)loadUserInfoWithProgress:(progress)progress andResutl:(success)success failure:(failure)failure;
/**
 *  加载更多微博信息：
 *
 *  @param progress
 *  @param success
 *  @param failure
 */
-(void)loadMoreWeiboStatusesWithProgress:(progress)progress andResult:(success)success failure:(failure)failure;
/**
 *  获取为读取的微博数量：
 *
 *  @param progress
 *  @param success
 *  @param failure
 */
-(void)getUnreadWeibosCountWithProgress:(progress)progress andResult:(success)success failure:(failure)failure;
/**
 *  获取授权信息：
 *
 *  @param code
 *  @param progress
 *  @param success
 *  @param failure  
 */
-(void)getAccessTokenWithCode:(NSString *)code andProgress:(progress)progress andResult:(success)success failure:(failure)failure;
/**
 *  发送新微博：
 *
 *  @param parameters
 *  @param progress
 *  @param success
 *  @param failure    
 */
-(void)sendNewStatusWithParameters:(JDStatusRequestModel *)statusRequest andProgress:(progress)progress andResult:(success)success failure:(failure)failure;
/**
 *  加载最新微博首页数据：
 *
 *  @param newStatus
 *  @param progress
 *  @param success
 *  @param failure
 */
-(void)loadHomeWeiboStatusesWithParameters:(JDGetStatusModel *)getStatus andProgress:(progress)progress andResult:(success)success failure:(failure)failure;

@end
