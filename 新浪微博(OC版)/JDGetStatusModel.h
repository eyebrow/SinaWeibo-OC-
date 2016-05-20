//
//  JDGetStatusModel.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/19.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDGetStatusModel : NSObject

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, strong) NSNumber *since_id;
@property (nonatomic, strong) NSNumber *max_id;
@property (nonatomic, strong) NSNumber *count;

@end
