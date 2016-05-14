
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

@end
