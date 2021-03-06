//
//  JDBaseWeiboView.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/17.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "JDPhotoModel.h"
#import "JDStatusModel.h"
#import "JDUserModel.h"
#import "JDWeiboPhotoCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface JDBaseWeiboView : UIView

@property (nonatomic, strong) JDStatusModel *status;

@end
