//
//  ViewController.m
//  FKApiInvoker
//
//  Created by CHAT on 2019/9/26.
//  Copyright © 2019 CHAT. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <FKApiInvoker/FKApiInvoker.h>
#import "respModel/RespModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)mockSuccess:(id)sender {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"successData" ofType:@"json"];
    NSData* mockData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    [self fireWithMockData:mockData];
}

- (IBAction)mockFailure:(id)sender {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"failureData" ofType:@"json"];
    NSData* mockData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    [self fireWithMockData:mockData];
}

- (IBAction)mockTokenExpired:(id)sender
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"tokenExpiredData" ofType:@"json"];
    NSData* mockData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    [self fireWithMockData:mockData];
}

- (IBAction)mockArrResp:(id)sender {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"successArrData" ofType:@"json"];
    NSData* mockData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    
    [SVProgressHUD show];
    [FKApiInvoker fireWithMockData:mockData method:@"get" path:@"/get" param:@{@"aaa": @"bbb"} headers:@{@"hhh": @"ggg"} body:nil responseModelClass:[RespModel class] success:^(NSArray<RespModel*>* arr) {
        NSMutableString* tipStr = @"".mutableCopy;
        for (RespModel* model in arr) {
            [tipStr appendFormat:@"%@: %@\n", model.name, @(model.age)];
        }
        [SVProgressHUD showSuccessWithStatus:tipStr];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

-(void) fireWithMockData:(NSData*) mockData
{
    [SVProgressHUD show];
    [FKApiInvoker fireWithMockData:mockData method:@"get" path:@"/get" param:@{@"aaa": @"bbb"} headers:@{@"hhh": @"ggg"} body:nil responseModelClass:[RespModel class] success:^(RespModel* model) {
        [SVProgressHUD showSuccessWithStatus:model.description];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     1. 因为demo里使用mock数据，不会真正发起网络请求，所以BaseUrls、commonHeaders
     这两个参数没有用到，随便写也可以，但是非mock数据的话，要配置好这两个参数
     
     2. 注意这里的respCodeKey、respMsgKey、respDataKey是和mock数据里的key对应的，
     请根据你自己的API接口返回数据做调整
     */
    FKApiInvokerConfig* config = [[FKApiInvokerConfig alloc] initWithBaseUrls:@[@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org",@"http://www.httpbin.org"] commonHeaders:@{@"test": @"test"} respCodeKey:@"code" respMsgKey:@"msg" respDataKey:@"data" successCode:0 tokenExpiredCode:127];
    [[FKApiInvoker sharedInvoker] configInvoker:config];
    [FKApiInvoker sharedInvoker].tokenExpiredBlk = ^{
        //token失效，跳转登录
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:vc animated:YES completion:nil];
    };
}


@end
