# FKApiInvoker
iOS 平台网络接口调用封装

# 安装
```
pod 'FKApiInvoker'
```

# 使用
1. 初始化配置，可以放在Appdelegate的`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions`方法中，或者其他你认为合适的地方

```
FKApiInvokerConfig* config = [[FKApiInvokerConfig alloc] initWithBaseUrls:@[@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org"] commonHeaders:@{@"test": @"test"} respCodeKey:@"code" respMsgKey:@"msg" respDataKey:@"data" successCode:0 tokenExpiredCode:127];
    [[FKApiInvoker sharedInvoker] configInvoker:config];
    [FKApiInvoker sharedInvoker].tokenExpiredBlk = ^{
        //token失效，跳转登录页面
    };
```
2. 调用后台API

```
[FKApiInvoker fire:@"post" path:@"/personinfo/login" param:nil headers:headers body:body responseModelClass:[LoginResp class] success:^(LoginResp* model) {
        //成功处理
    } failure:^(NSError *error) {
        //失败处理
    }];
```
