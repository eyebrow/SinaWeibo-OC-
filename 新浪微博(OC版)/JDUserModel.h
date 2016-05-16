//
//  JDUserModel.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDUserModel : NSObject

/**
 *  用户ID：
 */
@property (nonatomic, copy) NSString *idstr;
/**
 *  用户昵称：
 */
@property (nonatomic, copy) NSString *name;
/**
 *  用户头像：
 */
@property (nonatomic, copy) NSString *profile_image_url;
/**
 *  会员等级：
 */
@property (nonatomic, strong) NSNumber *mbrank;
/**
 *  会员类型：
 */
@property (nonatomic, strong) NSNumber *mbtype;

/**
 *  判断是不是会员：
 *
 *  @return
 */
-(BOOL)isVip;

@end
