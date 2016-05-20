//
//  JDStatusRequestModel.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/19.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDStatusRequestModel : NSObject

/**
 *  令牌：
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  微博文本：
 */
@property (nonatomic, copy) NSString *status;
/**
 *  微博配图：
 */
@property (nonatomic, strong) UIImage *image;

@end
