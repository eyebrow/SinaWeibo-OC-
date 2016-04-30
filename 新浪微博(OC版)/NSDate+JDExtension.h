//
//  NSDate+JDExtension.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/1.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JDExtension)

/**
 *  是否是今天：
 *
 *  @return
 */
-(BOOL)isToday;
/**
 *  是否是昨天：
 *
 *  @return
 */
-(BOOL)isYesterday;
/**
 *  是否是今年：
 *
 *  @return
 */
-(BOOL)isThisYear;
/**
 *  返回一个只有年月日的时间对象：
 *
 *  @return
 */
-(NSDate *)dateWithYMD;
/**
 *  获取与当前时间的差距：
 *
 *  @return 
 */
-(NSDateComponents *)dateWithCurrent;

@end
