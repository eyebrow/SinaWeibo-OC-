//
//  JDBaseWeiboView.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/8.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDStatusModel.h"
#import "JDImageCell.h"
#import "JDPhotoModel.h"

@class JDStatusModel;

@interface JDBaseWeiboView : UIView

/**
 *  微博数据模型：
 */
@property (nonatomic, strong) JDStatusModel *status;

@end
