//
//  NSDate+JDExtension.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JDExtension)

/**
 *  是否今天：
 *
 *  @return
 */
-(BOOL)isToday;
/**
 *  是否昨天：
 *
 *  @return
 */
-(BOOL)isYesterday;
/**
 *  是否今年：
 *
 *  @return
 */
-(BOOL)isThisYear;
/**
 *  返回一个只有年月日的时间：
 *
 *  @return
 */
-(NSDate *)dateWithYMD;
/**
 *  返回与当前时间的差距：
 *
 *  @return
 */
-(NSDateComponents *)distanceFromNow;

@end
