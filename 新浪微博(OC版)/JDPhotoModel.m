//
//  JDPhotoModel.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/30.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDPhotoModel.h"

@implementation JDPhotoModel

-(NSString *)bmiddle_pic {
    return [self.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}

@end
