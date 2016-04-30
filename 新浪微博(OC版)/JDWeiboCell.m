//
//  JDWeiboCell.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/5.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWeiboCell.h"
#import "JDStatusModel.h"
#import "JDOriginalWeiboView.h"
#import "JDForwardWeiboView.h"
#import "JDWeiboToolsView.h"

@interface JDWeiboCell ()
/**
 *  封装原创微博的容器：
 */
@property (weak, nonatomic) IBOutlet JDOriginalWeiboView *originalWeiboView;
@property (weak, nonatomic) IBOutlet JDForwardWeiboView *forwardWeiboView;
@property (weak, nonatomic) IBOutlet JDWeiboToolsView *weiboToolsView;

@end

@implementation JDWeiboCell

-(void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

/**
 *  重写setter方法，初始化cell的数据：
 *
 *  @param status
 */
-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    self.originalWeiboView.status = status;
    self.forwardWeiboView.status = status.retweeted_status;
    self.weiboToolsView.status = status;
}

// 返回高度：
-(CGFloat)getCellRealHeightWithStatus:(JDStatusModel *)status {
    self.status = status;
    [self layoutIfNeeded];
    
    return CGRectGetMaxY(self.weiboToolsView.frame) + 10;
}

@end
