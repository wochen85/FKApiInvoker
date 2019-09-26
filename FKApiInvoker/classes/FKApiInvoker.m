//
//  FKApiInvoker.m
//  Pods
//
//  Created by CHAT on 2019/9/26.
//

#import "FKApiInvoker.h"

NSString *const FKApiLevelDefaultsKey = @"com.fkapi.apilevel";

@interface FKApiInvoker()
@property (nonatomic, strong) FKApiInvokerConfig* config;
@end

@implementation FKApiInvoker
-(void) configInvoker:(FKApiInvokerConfig*)config
{
    NSAssert(config.baseUrls.count==4, @"baseUrls个数为4个，依次为开发、qa、预生产、生产，如果某个环境用不到，传空字符串即可");
    NSAssert(config.respCodeKey.length, @"respCodeKey不能为空");
    NSAssert(config.respMsgKey.length, @"respMsgKey不能为空");
    _config = config;
}

- (void)setApiLevel:(FKApiLevel)apiLevel{
    NSAssert(apiLevel<=FKApiLevel_prd && apiLevel>=FKApiLevel_dev, @"apiLevel错误");
    _apiLevel = apiLevel;
    [[NSUserDefaults standardUserDefaults] setObject:@(_apiLevel) forKey:FKApiLevelDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
