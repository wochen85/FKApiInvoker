# FKApiInvoker
iOS 平台网络接口调用封装

# 安装
```
pod 'FKApiInvoker'
```

# 使用
### 1. 初始化配置，可以放在Appdelegate的`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions`方法中，或者其他你认为合适的地方，

假设后台返回的json格式如下：
```
{"code":0,
"msg":"成功",
"data":{"name":"CHAT",
        "age":18}}
```
> 其中 code是错误码（0代表处理成功，127代表token过期），msg是提示消息，data 是具体的业务数据

那么做如下配置：

```
FKApiInvokerConfig* config = [[FKApiInvokerConfig alloc] initWithBaseUrls:@[@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org"] commonHeaders:@{@"test": @"test"} respCodeKey:@"code" respMsgKey:@"msg" respDataKey:@"data" successCode:0 tokenExpiredCode:127];
    [[FKApiInvoker sharedInvoker] configInvoker:config];
    [FKApiInvoker sharedInvoker].tokenExpiredBlk = ^{
        //token失效，跳转登录页面
    };
```
### 2. 调用后台API


```
[FKApiInvoker fire:@"post" path:@"/personinfo/login" param:nil headers:headers body:body responseModelClass:[LoginResp class] success:^(LoginResp* model) {
        //成功处理
    } failure:^(NSError *error) {
        //失败处理
    }];
```

### 3. 使用mock数据
```
[FKApiInvoker fireWithMockData:mockData method:@"post" path:@"/personinfo/login" param:nil headers:headers body:body responseModelClass:[LoginResp class] success:^(LoginResp* model) {
        //成功处理
    } failure:^(NSError *error) {
        //失败处理
    }];
```

# 其他情况

### 1. 后台返回的业务数据和错误码、错误消息平级：

```
{"code":0,
    "msg":"成功",
    "name":"CHAT",
    "age":18}
```
则在初始化配置的时候改成这种：
```
FKApiInvokerConfig* config = [[FKApiInvokerConfig alloc] initWithBaseUrls:@[@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org"] commonHeaders:@{@"test": @"test"} respCodeKey:@"code" respMsgKey:@"msg" respDataKey:nil successCode:0 tokenExpiredCode:127];
    [[FKApiInvoker sharedInvoker] configInvoker:config];
    [FKApiInvoker sharedInvoker].tokenExpiredBlk = ^{
        //token失效，跳转登录页面
    };
```
> 即respDataKey参数传nil

### 2. 如果通用头在初始化配置之后可能发生变化，这种情况常见于用户登录之后，通用头里面需要加入形如`token`的字段

那么调用如下方法：
```
[[FKApiInvoker sharedInvoker] configCommonHeaders:@{@"token": @"token string"}];
```

### 3. 需要做其他更加灵活的json格式的http请求？
可以直接使用我写的另一个库：
[JsonModelHttp](https://github.com/wochen85/JsonModelHttp)

事实上FKApiInvoker底层也是依赖的JsonModelHttp.
