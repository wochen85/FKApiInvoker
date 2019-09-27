//
//  FKApiInvokerConfig.m
//  Pods-FKApiInvoker
//
//  Created by CHAT on 2019/9/26.
//

#import "FKApiInvokerConfig.h"

@implementation FKApiInvokerConfig
- (instancetype)initWithBaseUrls:(NSArray<NSString*>*)baseUrls
                   commonHeaders:(NSDictionary*)commonHeaders
                     respCodeKey:(NSString*)respCodeKey
                      respMsgKey:(NSString*)respMsgKey
                     respDataKey:(NSString*)respDataKey
                     successCode:(NSInteger)successCode
                    tokenExpiredCode:(NSInteger)tokenExpiredCode;
{
    self = [super init];
    if (self) {
        _baseUrls = baseUrls;
        _commonHeaders = commonHeaders;
        _respCodeKey = respCodeKey;
        _respMsgKey = respMsgKey;
        _respDataKey = respDataKey;
        _successCode = successCode;
        _tokenExpiredCode = tokenExpiredCode;
    }
    return self;
}
@end
