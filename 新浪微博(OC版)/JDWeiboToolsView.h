//
//  JDWeiboToolsView.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/7.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDStatusModel;

@interface JDWeiboToolsView : UIView

/**
 *  微博数据模型：
 */
@property (nonatomic, strong) JDStatusModel *status;

@end
