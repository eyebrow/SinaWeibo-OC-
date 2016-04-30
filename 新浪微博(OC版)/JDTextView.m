//
//  JDTextView.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/4/3.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDTextView.h"

@interface JDTextView ()

/**
 *  用于显示提醒字样的label：
 */
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation JDTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTextView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTextView];
    }
    return self;
}

/**
 *  初始化控件：
 */
-(void)setupTextView {
    UILabel *placeholderLabel = [[UILabel alloc] init];
    [self addSubview:placeholderLabel];
    placeholderLabel.numberOfLines = 0;
    [placeholderLabel sizeToFit];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];
    placeholderLabel.x = 5;
    placeholderLabel.y = 7;
    
    self.font = [UIFont systemFontOfSize:15.0f];
    placeholderLabel.font = self.font;
    self.placeholderLabel = placeholderLabel;
    
    // 监听文本框变化：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  文本框内文字数量变化时调用：
 */
-(void)textChanged {
    // 如果文本框中有内容则隐藏placeholderLabel：
    self.placeholderLabel.hidden = self.text.length > 0;
}

/**
 *  重写setter方法，设置提示字样：
 *
 *  @param placeholder
 */
-(void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFit];
}

@end
