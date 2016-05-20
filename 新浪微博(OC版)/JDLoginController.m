
//
//  JDLoginController.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/11.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDLoginController.h"
#import "JDAccountModel.h"
#import "JDNewFeatureController.h"
#import "JDWelcomeController.h"
#import "JDNetworkTools.h"

#define JDAuthorizeURL @"https://api.weibo.com/oauth2/authorize"
#define JDClientID @"474455695"
#define JDRedirectURI  @"http://ios.itcast.cn"

@interface JDLoginController () <UIWebViewDelegate>

/**
 *  用于加载授权界面的webView：
 */
@property (nonatomic, weak) UIWebView *loginWebView;

@end

@implementation JDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginController];
}

-(void)loadView {
    // 将控制器view替换为webView：
    UIWebView *loginWebView = [[UIWebView alloc] init];
    self.view = loginWebView;
    loginWebView.delegate = self;
    self.loginWebView = loginWebView;
}

-(void)setupLoginController {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCloseLoginPage:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"自动填充账户" style:UIBarButtonItemStylePlain target:self action:@selector(clickToAutoFillUsernameAndPassword:)];
    self.title = @"新浪微博用户授权";
    
    // 加载登录授权界面：
    [self loadLoginPage];
}

/**
 *  加载登录授权页面：
 */
-(void)loadLoginPage {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", JDAuthorizeURL, JDClientID, JDRedirectURI]];
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

#pragma mark - UIWebViewDelegate:

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

// 加载完后但发生错误时调用：
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

// 每一次发送请求都会调用此方法，返回YES为允许加载：
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // code=ae5ca14e5de18a974c1123d398bb016f
    JDLog(@"%@", request.URL.absoluteString);
    NSString *urlStr = request.URL.absoluteString;
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length > 0 && range.location != NSNotFound) {
        JDLog(@"授权成功....");
        NSUInteger startIndex = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:startIndex];
        JDLog(@"code = %@", code);
        [self getAccessTokenWithCode:code];
        return NO;
    } else {
        JDLog(@"授权失败....");
        return YES;
    }
}

/**
 *  根据授权成功返回的code获取access_token：
 *
 *  @param code
 */
-(void)getAccessTokenWithCode:(NSString *)code {
    /**
     必选	类型及范围	说明
     client_id	true	string	申请应用时分配的AppKey。
     client_secret	true	string	申请应用时分配的AppSecret。
     grant_type	true	string	请求的类型，填写authorization_code
     
     grant_type为authorization_code时
     必选	类型及范围	说明
     code	true	string	调用authorize获得的code值。
     redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
     */
    
    JDNetworkTools *tools = [JDNetworkTools shardNetworkTools];
    [tools getAccessTokenWithCode:code andProgress:^(NSProgress *downloadProgress) {
    } andResult:^(id object) {
        JDLog(@"请求成功.... %@", object);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window chooseRootViewController];
        // 字典转模型：
        JDAccountModel *account = (JDAccountModel *)object;
        BOOL result = [account svaeAccountToSandbox];
        if (result) {
            JDLog(@"保存授权信息成功....");
        }
    } failure:^(NSError *error) {
        JDLog(@"请求失败.... %@", error);
    }];
}

@end
