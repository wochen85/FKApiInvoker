//
//  RespModel.m
//  FKApiInvoker
//
//  Created by CHAT on 2019/9/27.
//  Copyright © 2019 CHAT. All rights reserved.
//

#import "RespModel.h"
#import <YYModel/YYModel.h>

@implementation RespModel
- (NSString *)description
{
    NSDictionary* dic = [self yy_modelToJSONObject];
    NSData* data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return str;
}
@end
