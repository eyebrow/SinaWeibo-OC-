
//
//  JDGetStatusResultModel.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/19.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDGetStatusResultModel.h"
#import "JDStatusModel.h"

@implementation JDGetStatusResultModel

+(NSDictionary *)mj_objectClassInArray {
    return @{@"statuses": [JDStatusModel class]};
}

@end
