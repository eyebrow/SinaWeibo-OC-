//
//  JDWeiboCell.h
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/5.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDStatusModel;

@interface JDWeiboCell : UITableViewCell

/**
 *  微博数据模型：
 */
@property (nonatomic, strong) JDStatusModel *status;

/**
 *  返回cell的真实高度：
 *
 *  @param status
 *
 *  @return
 */
-(CGFloat)getCellRealHeightWithStatus:(JDStatusModel *)status;

@end
