//
//  JDStatusModel.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/30.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDStatusModel.h"
#import "JDPhotoModel.h"

@implementation JDStatusModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"pic_urls":[JDPhotoModel class]};
}

/**
 *  重写微博来源的setter方法，截取一部分来源字符串：
 *
 *  @param source
 */
-(void)setSource:(NSString *)source {
    _source = source;
    NSRange startRange = [_source rangeOfString:@">"];
    NSInteger startIndex = startRange.location + 1;
    NSRange endRange = [_source rangeOfString:@"</"];
    NSInteger length = endRange.location - startIndex;
#warning 有些微博没有来源，所以在截取前必须判断这个有没有微博来源，如果截取没有微博来源的微博，那么会造成程序崩溃。
    if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
        NSString *str = [_source substringWithRange:NSMakeRange(startIndex, length)];
        _source = str;
    }
}

-(NSString *)created_at {
    // 将服务器返回的字符串转换为NSDate：
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM  dd HH:mm:ss Z yyyy";
#warning 如果是真机，还需要设置时区。
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *createDate = [formatter dateFromString:_created_at];
    
    if ([createDate isThisYear]) {
        // 今年：
        if ([createDate isToday]) {
            // 今天：
            // 返回与当前时间的差距：
            NSDateComponents *com = [createDate dateWithCurrent];
            if (com.hour >= 1) {
                // 其它小时：
                return [NSString stringWithFormat:@"%tu小时前", com.hour];
            } else if (com.minute > 1) {
                // 一小时以内：
                return [NSString stringWithFormat:@"%tu分钟前", com.minute];
            } else {
                // 刚刚：
                return @"刚刚";
            }
        } else if ([createDate isYesterday]) {
            // 昨天：
            formatter.dateFormat = @"昨天  HH时:mm分";
            return [formatter stringFromDate:createDate];
        } else {
            // 其它：
            formatter.dateFormat = @"MM月dd日  HH时:mm分";
            return [formatter stringFromDate:createDate];
        }
    } else {
        // 非今年：
        formatter.dateFormat = @"yy年MM月dd日  HH时:mm分";
        return [formatter stringFromDate:createDate];
    }
}

@end
