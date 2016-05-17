//
//  JDWeiboCell.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDWeiboCell.h"
#import "JDUserModel.h"
#import "JDStatusModel.h"
#import "JDWeiboPhotoCell.h"
#import "JDOriginalWeiboView.h"
#import "JDForwardWeiboView.h"
#import "JDWeiboBottomView.h"

// 间隙：
#define kMargin 8

@interface JDWeiboCell ()

/**
 *  原创微博view：
 */
@property (weak, nonatomic) IBOutlet JDOriginalWeiboView *originalWeiboView;
/**
 *  转发微博view：
 */
@property (weak, nonatomic) IBOutlet JDForwardWeiboView *forwardWeiboView;
/**
 *  底部视图view：
 */
@property (weak, nonatomic) IBOutlet JDWeiboBottomView *weiboBottomView;

@end

@implementation JDWeiboCell

-(void)awakeFromNib {
    // cell不可点击：
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)getWeiboCellWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"WEIBOCELL";
    JDWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    return cell;
}

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    self.originalWeiboView.status = status;
    self.forwardWeiboView.status = status;
    self.weiboBottomView.status = status;
    
    // 判断是否有转发微博：
    if (status.retweeted_status) {
        self.forwardWeiboView.hidden = NO;
    } else {
        // 如果没有则隐藏转发微博view，并且把view的高度设置为0:
        self.forwardWeiboView.hidden = YES;
        self.forwardWeiboView.forwardHeight = 0;
    }
}


/**
 *  返回cell的高度，此方法在homeController中计算rowHeight时调用：
 *
 *  @param status
 *
 *  @return 
 */
-(CGFloat)getCellHeightWithStatus:(JDStatusModel *)status {
    self.status = status;
    [self layoutIfNeeded];
    // 取出底部视图的高度：
    return CGRectGetMaxY(self.weiboBottomView.frame) + kMargin * 2;
}

@end
