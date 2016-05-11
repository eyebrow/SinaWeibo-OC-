//
//  JDWelcomeView.h
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDWelcomeView : UIView

/**
 *  图标图片名：
 */
@property (nonatomic, copy) NSString *iconImageName;
/**
 *  信息文字：
 */
@property (nonatomic, copy) NSString *infoText;
/**
 *  是否隐藏wheelImageView：
 */
@property (nonatomic, assign, getter=isWheelHidden) BOOL wheelHidden;
/**
 *  infoLable顶部的距离：
 */
@property (nonatomic, assign) CGFloat infoTop;

/**
 *  快速加载xib：
 *
 *  @return 
 */
+(instancetype)getWelcomeViewFromXib;

-(void)startRevolve;
-(void)stopRevolve;

@end
