
//
//  JDLoginController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDLoginController.h"

#define kAuthorizeURL @"https://api.weibo.com/oauth2/authorize"
#define kClientID @"474455695"
#define kRedirectURI @"http://ios.itcast.cn"

@interface JDLoginController ()

@property (nonatomic, weak) UIWebView *loginWebView;

@end

@implementation JDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginController];
}

-(void)loadView {
    UIWebView *loginWebView = [[UIWebView alloc] init];
    self.view = loginWebView;
    self.loginWebView = loginWebView;
}

-(void)setupLoginController {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCloseLoginPage:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自动填充账户" style:UIBarButtonItemStylePlain target:self action:@selector(clickToAutoFillUsernameAndPassword:)];
    self.title = @"新浪微博用户授权";
    
    // 加载登录授权界面：
    [self loadLoginPage];
}

-(void)loadLoginPage {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", kAuthorizeURL, kClientID, kRedirectURI]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIWebView *loginWebView = (UIWebView *)self.view;
    [loginWebView loadRequest:request];
}

/**
 *  点击关闭登录授权页面：
 *
 *  @param sender
 */
-(void)clickToCloseLoginPage:(UIBarButtonItem *)sender {
    JDLog(@"点击了关闭登录页面按钮....");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击自动填写用户名和密码：
 *
 *  @param sender
 */
-(void)clickToAutoFillUsernameAndPassword:(UIBarButtonItem *)sender {
    JDLog(@"点击了自动填写账户的按钮....");
    // 执行一段JS代码用于自动填充用户名和密码：
    NSString *jsStr = @"document.getElementById('userId').value = '18502860517' , document.getElementById('passwd').value = 'w2owr@sdojjiangD';";
    [self.loginWebView stringByEvaluatingJavaScriptFromString:jsStr];
}

@end
