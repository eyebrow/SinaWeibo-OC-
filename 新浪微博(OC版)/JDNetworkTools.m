
//
//  JDNetworkTools.m
//  新浪微博(OC版)
//
//  Created by JiangDi on 16/5/18.
//  Copyright © 2016年 Google. All rights reserved.
//

#import "JDNetworkTools.h"
#import "JDAccountModel.h"
#import "JDUserModel.h"
#import "JDUnreadCountModel.h"
#import "JDStatusRequestModel.h"
#import "JDStatusModel.h"
#import "JDGetStatusModel.h"
#import "JDGetStatusResultModel.h"

#define JDWeiboBaseURL [NSURL URLWithString:@"https://api.weibo.com/"]
// 获取未读数
#define JDUnreadCountURL @"https://rm.api.weibo.com/2/remind/unread_count.json"
// 获取用户信息
#define JDUserInfoURL @"2/users/show.json"
// APPkey
#define JDClientID @"474455695"
// App Secret
#define JDClientSecret @"ecb665fe78736e713b4043ddf24e4a7d"
// 回调地址
#define JDRedirectURI  @"http://ios.itcast.cn"
// 授权地址
#define JDAccessTokenURL @"oauth2/access_token"
// 发送文本微博
#define JDSendStatusTextURL @"https://api.weibo.com/2/statuses/update.json"
// 发送图片微博
#define JDSendStatusImageURL @"https://upload.api.weibo.com/2/statuses/upload.json"
// 获取微博数据
#define JDHomeStatusURL @"https://api.weibo.com/2/statuses/home_timeline.json"

@implementation JDNetworkTools

+(instancetype)shardNetworkTools {
    /**
     *  单例模式设计：
     */
    static JDNetworkTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[JDNetworkTools alloc] initWithBaseURL:JDWeiboBaseURL sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain" ,@"application/json", @"text/json", @"text/javascript", nil];
    });
    return tools;
}

-(void)loadUserInfoWithProgress:(progress)progress andResutl:(success)success failure:(failure)failure {
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    [self GET:JDUserInfoURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            // 将返回的json数据转换为模用户模型：
            JDUserModel *user = [JDUserModel mj_objectWithKeyValues:responseObject];
            success(user);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)loadMoreWeiboStatusesWithProgress:(progress)progress andResult:(success)success failure:(failure)failure {
    
}

-(void)getUnreadWeibosCountWithProgress:(progress)progress andResult:(success)success failure:(failure)failure {
    JDAccountModel *account = [JDAccountModel getAccountFromSandbox];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = account.access_token;
    parameters[@"uid"] = account.uid;
    
    [self GET:JDUnreadCountURL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            JDUnreadCountModel *unreadCount = [JDUnreadCountModel mj_objectWithKeyValues:responseObject];
            success(unreadCount);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)getAccessTokenWithCode:(NSString *)code andProgress:(progress)progress andResult:(success)success failure:(failure)failure {
    // 封装请求参数：
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"client_id"] = JDClientID;
    parameters[@"client_secret"] = JDClientSecret;
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"code"] = code;
    parameters[@"redirect_uri"] = JDRedirectURI;
    
    // 发送POST请求：
    [self POST:JDAccessTokenURL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            JDAccountModel *account = [JDAccountModel mj_objectWithKeyValues:responseObject];
            success(account);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)sendNewStatusWithParameters:(JDStatusRequestModel *)statusRequest andProgress:(progress)progress andResult:(success)success failure:(failure)failure {
    [SVProgressHUD show];
    if (statusRequest.image != nil) {
        // 微博带图片：
        [self POST:JDSendStatusImageURL parameters:statusRequest.mj_keyValues constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *photoData = UIImagePNGRepresentation(statusRequest.image);
            // 上传图片文件：
#warning 文件上传必须是上传二进制数据，不能直接传字典。
            [formData appendPartWithFileData:photoData name:@"pic" fileName:@"photo" mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                JDStatusModel *status = [JDStatusModel mj_objectWithKeyValues:responseObject];
                success(status);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
            if (failure) {
                failure(error);
            }
        }];
    } else {
        // 微博只有文字：
        [self POST:JDSendStatusTextURL parameters:statusRequest.mj_keyValues progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                JDStatusModel *status = [JDStatusModel mj_objectWithKeyValues:responseObject];
                success(status);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    [SVProgressHUD dismiss];
}

-(void)loadHomeWeiboStatusesWithParameters:(JDGetStatusModel *)getStatus andProgress:(progress)progress andResult:(success)success failure:(failure)failure {
    [self GET:JDHomeStatusURL parameters:getStatus.mj_keyValues progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            JDGetStatusResultModel *getStatusResult = [JDGetStatusResultModel mj_objectWithKeyValues:responseObject];
            success(getStatusResult);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
