//
//  JDUserModel.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger) {
    // 没有认证：
    JDUserVerifiedTypeNone = -1,
    // 黄v：
    JDUserVerifiedTypePersonal = 0,
    // 蓝v：
    JDUserVerifiedTypeEnterprice = 2,
    // 媒体：
    JDUserVerifiedTypeMedia = 3,
    // 网站：
    JDUserVerifiedTypeWebsite = 5,
    // 达人：
    JDUserVerifiedTypeDaRen = 220
} JDUserVerifiedType;

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
 *  认证类型：
 */
@property (nonatomic, assign) JDUserVerifiedType verified_type;

/**
 *  判断是不是会员：
 *
 *  @return
 */
-(BOOL)isVip;

@end
