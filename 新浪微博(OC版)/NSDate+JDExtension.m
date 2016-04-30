//
//  NSDate+JDExtension.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/1.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "NSDate+JDExtension.h"

@implementation NSDate (JDExtension)

-(BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // 获取当前时间的年月日：
    NSDateComponents *currentCom = [calendar components:unit fromDate:[NSDate date]];
    // 获取self时间的年月日：
    NSDateComponents *selfCom = [calendar components:unit fromDate:self];
    // 返回对比结果：
    return (currentCom.year == selfCom.year) && (currentCom.month == selfCom.month) && (currentCom.day == selfCom.day);
}

-(BOOL)isYesterday {
    // 创建日期：
    NSDate *currentDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *com = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:currentDate options:0];
    return com.day == 1;
}

-(BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    
    // 获取当前时间的年：
    NSDateComponents *currentCom = [calendar components:unit fromDate:[NSDate date]];
    // 获取self的年：
    NSDateComponents *selfCom = [calendar components:unit fromDate:self];
    return currentCom.year == selfCom.year;
}

-(NSDate *)dateWithYMD {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *str = [formatter stringFromDate:self];
    return [formatter dateFromString:str];
}

-(NSDateComponents *)dateWithCurrent {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
