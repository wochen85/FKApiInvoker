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

NS_ASSUME_NONNULL_BEGIN

@interface FKApiInvoker : NSObject
@property (nonatomic) FKApiLevel apiLevel;
-(void) configInvoker:(FKApiInvokerConfig*)config;
@end

NS_ASSUME_NONNULL_END
