
//
//  JDComposeTextView.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/14.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDComposeTextView.h"

@interface JDComposeTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation JDComposeTextView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupComposeTextView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupComposeTextView];
    }
    return self;
}

-(void)setupComposeTextView {
    CGFloat marginX = 6;
    CGFloat marginY = -2;
    self.font = [UIFont systemFontOfSize:16.0f];
    self.alwaysBounceVertical = YES;
    
    UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, marginY, JDScreenWidth, 40)];
    [self addSubview:placeholderLabel];
    placeholderLabel.font = [UIFont systemFontOfSize:16.0f];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    self.placeholderLabel = placeholderLabel;
    
    // 监听self是否处于编辑状态：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textChanged {
    JDLog(@"文本框内文字有变化....");
    // 一旦有文字键入，则隐藏提示框：
    self.placeholderLabel.hidden = self.text.length > 0;
}

-(void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.placeholderLabel.text = placeholderText;
}

@end
