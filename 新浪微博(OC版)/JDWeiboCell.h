//
//  JDWeiboCell.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDStatusModel;

@interface JDWeiboCell : UITableViewCell

@property (nonatomic, strong) JDStatusModel *status;

+(instancetype)getWeiboCellWithTableView:(UITableView *)tableView;

@end
