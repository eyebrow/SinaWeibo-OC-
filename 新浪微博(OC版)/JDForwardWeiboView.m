//
//  JDForwardWeiboView.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/7.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDForwardWeiboView.h"
#import "JDUserModel.h"

#define kImagesColum 3
#define kImageHeight 90
#define kImageMargin 5

@interface JDForwardWeiboView ()

/**
 *  转发的微博内容：
 */
@property (weak, nonatomic) IBOutlet UILabel *forwardContent;
/**
 *  转发微博容器的高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwardConsHeight;
/**
 *  转发微博配图容器的高度：
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forwardImageConsHeight;
/**
 *  存放转发微博配图的容器：
 */
@property (weak, nonatomic) IBOutlet UICollectionView *forwardImageView;
/**
 *  是否是转发微博：
 */
@property (nonatomic, assign) BOOL isForward;

@end

@implementation JDForwardWeiboView

-(void)awakeFromNib {
    self.forwardContent.preferredMaxLayoutWidth = UIScreenSize.width - 10;
}

-(void)setStatus:(JDStatusModel *)status {
    [super setStatus:status];
    // 转发微博：
    if (self.status) {
        // 如果存在转发微博才调用此方法：
        self.hidden = NO;
        [self setupForwardWeiboWithStatus:self.status];
    } else {
        self.isForward = NO;
        self.hidden = YES;
        self.forwardConsHeight.constant = 0;
    }
}

/**
 *  初始化转发的微博：
 *
 *  @param status
 */
-(void)setupForwardWeiboWithStatus:(JDStatusModel *)status {
    self.forwardContent.text = status.text;
    NSString *content = [NSString stringWithFormat:@"@%@:%@", status.user.name, status.text];
    self.forwardContent.text = content;
    
    // 计算高度：
    self.forwardConsHeight.constant = [self.forwardContent systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 10;
    
    // 转发微博的配图：
    NSInteger imgsCount = status.pic_urls.count;
    if (imgsCount > 0) {
        // 有配图：
        NSInteger row = 0;
        if (imgsCount % kImagesColum == 0) {
            row = imgsCount / kImagesColum;
        } else {
            row = imgsCount / kImagesColum + 1;
        }
        // 计算高度：
        CGFloat imgsHeight = row * kImageHeight + (row - 1) * kImageMargin;
        self.forwardImageConsHeight.constant = imgsHeight;
        // 刷新显示配图区域：
        [self.forwardImageView reloadData];
        // 修改微博高度，在纯文本微博高度的基础上加上图片的高度：
        self.forwardConsHeight.constant += self.forwardImageConsHeight.constant + 15;
    } else {
        // 没有配图则不计算高度：
        self.forwardImageConsHeight.constant = 0;
    }
}

@end
