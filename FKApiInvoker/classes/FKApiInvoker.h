//
//  FKApiInvoker.h
//  Pods
//
//  Created by CHAT on 2019/9/26.
//

#import <Foundation/Foundation.h>
#import "FKApiInvokerConfig.h"

//API环境
typedef NS_ENUM(NSUInteger, FKApiLevel) {
    FKApiLevel_dev = 0,    //开发
    FKApiLevel_qa = 1,     //qa，或者叫测试
    FKApiLevel_pre = 2,    //预生产
    FKApiLevel_prd =3,     //生产
};

@interface FKApiInvoker : NSObject
@property (nonatomic) FKApiLevel apiLevel;
@property (nonatomic, copy) void(^tokenExpiredBlk)(void);

+(instancetype) sharedInvoker;
-(void) configInvoker:(FKApiInvokerConfig*)config;

+(void) fire:(NSString*) method path:(NSString*) path param:(NSDictionary*)param headers:(NSDictionary*)headValue body:(id<NSObject>) bodyModel responseModelClass:(Class)modelClass success:(void(^)(id model)) successBlk failure:(void(^)(NSError * error)) failueBlk;

+(void) fireWithMockData:(NSData*)mockData method:(NSString*) method path:(NSString*) path param:(NSDictionary*)param headers:(NSDictionary*)headValue body:(id<NSObject>) bodyModel responseModelClass:(Class)modelClass success:(void(^)(id model)) successBlk failure:(void(^)(NSError * error)) failueBlk;
@end
