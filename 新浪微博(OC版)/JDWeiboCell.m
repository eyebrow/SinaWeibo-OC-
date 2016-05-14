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

@implementation JDWeiboCell

+(instancetype)getWeiboCellWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"WEIBOCELL";
    JDWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    return cell;
}

-(void)setStatus:(JDStatusModel *)status {
    _status = status;
    JDUserModel *user = status.user;
    self.textLabel.text = user.name;
    self.detailTextLabel.text = status.created_at;
#warning 此处加载图片一定要设置展位图，否则imageView的frame初始时为0，必须下拉一下tableView系统再帮你设置。
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
}

@end
