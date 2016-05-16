



//
//  JDUserModel.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDUserModel.h"

@implementation JDUserModel

-(BOOL)isVip {
    return self.mbtype.integerValue > 2;
}

@end
