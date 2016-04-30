//
//  JDOAuthController.m
//  新浪微博(OC版)
//
//  Created by Chiang on 16/3/28.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDOAuthController.h"
#import "JDAccountModel.h"
#import "JDNewFeatureController.h"
#import "JDWelcomeController.h"

#define JDAuthorizeURL @"https://api.weibo.com/oauth2/authorize"
#define JDClient_ID @"1885018458"
#define JDRedirect_URI @"http://ios.itcast.cn"
#define JDAccess_TokenURL @"https://api.weibo.com/oauth2/access_token"
#define JDClient_Secret @"600be2677d35d9f023868520f02884ae"

@interface JDOAuthController () <UIWebViewDelegate>

@end

@implementation JDOAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToCancel)];
    
    [self loadOAuthPage];
}

/**
 *  加载授权界面：
 */
-(void)loadOAuthPage {
#warning 倘若发生" NSURLSession/NSURLConnection HTTP load failed (kCFStreamErrorDomainSSL, -9802) "的bug，这是由于网站证书的加密算法没有达到Apple的要求。需要在info.plist中配置 " NSAppTransportSecurity、NSExceptionDomains，NSIncludesSubdomains、NSExceptionRequiresForwardSecrecy、NSExceptionAllowInsecureHTTPLoads "。
    
    // 拼接url：
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", JDAuthorizeURL, JDClient_ID, JDRedirect_URI];
    NSLog(@"%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 通过url加载页面：
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    [webView loadRequest:request];
}

/**
 *  控制器创建完毕时调用：
 */
-(void)loadView {
    self.view = [[UIWebView alloc] init];
}

/**
 *  点击返回：
 */
-(void)clickToCancel {
    JDLog(@"%s", __func__);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

/**
 *  开始加载时调用：
 *
 *  @param webView
 */
-(void)webViewDidStartLoad:(UIWebView *)webView {
    // 提示用户等待：
    [SVProgressHUD showWithStatus:@"正在加载...."];
}

/**
 *  加载完成时调用：
 *
 *  @param webView
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

/**
 *  错误时调用：
 *
 *  @param webView
 *  @param error   
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

/**
 *  只要webView有发送请求就会调用：
 *
 *  @param webView
 *  @param request
 *  @param navigationType
 *
 *  @return
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 判断是否请求成功：
    NSString *urlStr = request.URL.absoluteString;
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length > 0 && range.location != NSNotFound) {
        // 截取requestToken，换得AccessToken：
        NSUInteger start = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:start];
        [self getAccessTokenWithRequestTokenFromCode:code];
        return NO;
    }
    return YES;
}

/**
 *  根据code截取到requestToken，换取AccessToken：
 *
 *  @param code
 */
-(void)getAccessTokenWithRequestTokenFromCode:(NSString *)code {
    JDLog(@"%@", code);
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
    // 封装请求参数：
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"client_id"] = JDClient_ID;
    parameters[@"client_secret"] = JDClient_Secret;
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"code"] = code;
    parameters[@"redirect_uri"] = JDRedirect_URI;
    // 创建网络请求管理对象：
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 让AFN支持text/plain类型：
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // 发送post请求：
    [manager POST:JDAccess_TokenURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JDLog(@"换取Token成功 <+++> %@", responseObject);
        // 存储授权返回的信息到模型：
        JDAccountModel *account = [JDAccountModel mj_objectWithKeyValues:responseObject];
        // 归档：
        [account saveAccountInfo];
        
        // 为window选择root控制器：
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window chooseRootViewController];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JDLog(@"换取Token失败 <---> %@", error);
    }];
}

@end
