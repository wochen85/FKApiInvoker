//
//  FKApiInvokerConfig.h
//  Pods-FKApiInvoker
//
//  Created by CHAT on 2019/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FKApiInvokerConfig : NSObject
- (instancetype)initWithBaseUrls:(NSArray<NSString*>*)baseUrls
                         commonHeaders:(NSDictionary*)commonHeaders
                         respCodeKey:(NSString*)respCodeKey
                         respMsgKey:(NSString*)respMsgKey
                         respDataKey:(NSString*)respDataKey
                         successCode:(NSInteger)successCode
                         tokenExpiredCode:(NSInteger)tokenExpiredCode;

//baseUrls
@property (nonatomic, strong) NSArray<NSString*>* baseUrls;
//通用请求头
@property (nonatomic, copy) NSDictionary* commonHeaders;
//状态码对应的key
@property (nonatomic, copy) NSString* respCodeKey;
//提示信息对应的key
@property (nonatomic, copy) NSString* respMsgKey;
//具体数据对应的key
@property (nonatomic, copy) NSString* respDataKey;
//响应成功对应的错误码
@property (nonatomic) NSInteger successCode;
//token过期对应的错误码
@property (nonatomic) NSInteger tokenExpiredCode;
@end

NS_ASSUME_NONNULL_END
