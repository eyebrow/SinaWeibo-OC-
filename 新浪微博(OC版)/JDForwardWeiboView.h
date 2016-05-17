//
//  JDForwardWeiboView.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/17.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDStatusModel;

@interface JDForwardWeiboView : UIView

@property (nonatomic, strong) JDStatusModel *status;

@property (nonatomic, assign) CGFloat forwardHeight;

@end
