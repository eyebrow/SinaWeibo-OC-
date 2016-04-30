//
//  JDUserModel.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/30.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger) {
    JDUserVerifiedNone = -1, // 普通用户；
    JDUserVerifiedSelf = 0, // 个人认证；
    JDUSerVerifiedEnterprise = 2, // 企业认证；
    JDUSerVerifiedMeida = 3, // 媒体平台；
    JDUSerVerifiedWebsite = 5, // 门户网站；
    JDUserVerifiedExpert = 220 // 微博达人。
} JDUserVerifiedType;

@interface JDUserModel : NSObject

/** 字符串型的用户UID */
@property (nonatomic, copy) NSString *idstr;
/** 友好显示名称 */
@property (nonatomic, copy) NSString *name;
/** 用户头像地址（中图），50×50像素 */
@property (nonatomic, copy) NSString *profile_image_url;
/**
 *  会员等级：
 */
@property (nonatomic, copy) NSNumber *mbrank;
/**
 *  会员类型，大于2就是会员：
 */
@property (nonatomic, copy) NSNumber *mbtype;
/**
 *  微博认证类型：
 */
@property (nonatomic, assign) JDUserVerifiedType verified_type;

/**
 *  判断是否会员：
 *
 *  @return
 */
-(BOOL)isVip;

@end
