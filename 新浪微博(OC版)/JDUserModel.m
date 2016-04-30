//
//  JDUserModel.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/30.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDUserModel.h"

@implementation JDUserModel

-(BOOL)isVip {
    return self.mbtype.intValue > 2;
}

@end
