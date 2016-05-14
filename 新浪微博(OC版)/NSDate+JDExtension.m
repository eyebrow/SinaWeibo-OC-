
//
//  NSDate+JDExtension.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "NSDate+JDExtension.h"

@implementation NSDate (JDExtension)

-(BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    // 获取当前时间的年月日：
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 获取self时间的年月日：
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return (nowCmps.year == selfCmps.year) && (nowCmps.month == nowCmps.month) && (nowCmps.day == selfCmps.day);
}

-(BOOL)isYesterday {
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    NSDate *selfDate = [self dateWithYMD];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

-(BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    return nowCmps.year == selfCmps.year;
}

-(NSDate *)dateWithYMD {
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fm stringFromDate:self];
    return [fm dateFromString:selfStr];
}

-(NSDateComponents *)distanceFromNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

@end
