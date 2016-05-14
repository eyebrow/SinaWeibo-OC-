
//
//  JDStatusModel.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDStatusModel.h"
#import "JDPhotoModel.h"

@implementation JDStatusModel

// 指定数组中存放数据的类型：
+(NSDictionary *)mj_objectClassInArray {
    return @{@"pic_urls":[JDPhotoModel class]};
}

-(void)setSource:(NSString *)source {
    // 截取开始的位置：
    NSRange startRange = [source rangeOfString:@">"];
    NSInteger startIndex = startRange.location + 1;
    // 截取结束的位置：
    NSRange endRange = [source rangeOfString:@"</"];
    NSInteger endIndex = endRange.location;
    // 需要截取的字符串的长度：
    NSInteger length = endIndex - startIndex;
#warning 部分微博是没有来源的，没有来源就是@""，直接截取@""会导致程序报错，所以在截取之前应该判断。
    if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
        NSString *sourceStr = [source substringWithRange:NSMakeRange(startIndex, length)];
        _source = sourceStr;
    }
}

#warning 由于显示的时间是会变化的，所以此处不能在用setter方法了，而只能用getter方法。
-(NSString *)created_at {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 指定时区：
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 指定服务器返回时间的格式：
    formatter.dateFormat = @"EEE MMM  dd HH:mm:ss Z yyyy";
    // 通过格式将日期字符串转换为日期：
    NSDate *createDate = [formatter dateFromString:_created_at];
    
    // 判断时间：
    if ([createDate isThisYear]) {
        // 今年：
        if ([createDate isToday]) {
            // 今天：
            NSDateComponents *cmps = [createDate distanceFromNow];
            if (cmps.hour >= 1) {
                // 大于1小时：
                return [NSString stringWithFormat:@"%tu小时前", cmps.hour];
            } else if (cmps.minute > 1) {
                // 一小时以内：
                return [NSString stringWithFormat:@"%tu分钟前", cmps.minute];
            } else {
                // 更早：
                return @"刚刚";
            }
        } else if ([createDate isYesterday]) {
            // 昨天：
            formatter.dateFormat = @"昨天 HH时:mm分";
            return [formatter stringFromDate:createDate];
        } else {
            // 更早：
            formatter.dateFormat = @"MM月dd日 HH时:mm分";
            return [formatter stringFromDate:createDate];
        }
    } else {
        // 如果不是今年，那么就显示具体的年月日时间：
        formatter.dateFormat = @"yy年MM月dd日 HH时:mm分";
        return [formatter stringFromDate:createDate];
    }
}

@end
