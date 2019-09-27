//
//  FKApiInvoker.m
//  Pods
//
//  Created by CHAT on 2019/9/26.
//

#import "FKApiInvoker.h"
#import <JsonModelHttp/JsonModelHttp.h>
#import <YYModel/YYModel.h>

NSString* const FKApiLevelDefaultsKey = @"com.fkapi.apilevel";
NSString* const FKApiLevelErrDomain = @"com.fkapi.error";

@interface FKApiInvoker()
@property (nonatomic, strong) FKApiInvokerConfig* config;
@end

@implementation FKApiInvoker

+(void) fire:(NSString*) method path:(NSString*) path param:(NSDictionary*)param headers:(NSDictionary*)headValue body:(id<NSObject>) bodyModel responseModelClass:(Class)modelClass success:(void(^)(id model)) successBlk failure:(void(^)(NSError * error)) failueBlk
{
    [[FKApiInvoker sharedInvoker] fireWithMockData:nil method:method path:path param:param headers:headValue body:bodyModel responseModelClass:modelClass success:successBlk failure:failueBlk];
}

/*-(Class) baseRespClass
{
    const char* className = "FKBaseRespModel";
    Class baseRespClass = objc_getClass(className);
    if (!baseRespClass)
    {
        Class superClass = [NSObject class];
        baseRespClass = objc_allocateClassPair(superClass, className, 0);
        
        //code 属性
        objc_property_attribute_t typeCode = { "T", "@\"NSInteger\"" };//T：类型
        objc_property_attribute_t nonatomicCode = { "N", "" }; // N：nonatomic
        objc_property_attribute_t attributsCode[] = { typeCode, nonatomicCode };
        BOOL ret = class_addProperty(baseRespClass, self.config.respCodeKey.UTF8String, attributsCode, 2);
        NSParameterAssert(ret);
        
        //msg 属性
        objc_property_attribute_t typeMsg = { "T", "@\"NSString\"" };//T：类型
        objc_property_attribute_t ownershipMsg = { "C", "" }; // C：copy
        objc_property_attribute_t nonatomicMsg = { "N", "" }; // N：nonatomic
        objc_property_attribute_t attributsMsg[] = { typeMsg, ownershipMsg, nonatomicMsg };
        ret = class_addProperty(baseRespClass, self.config.respMsgKey.UTF8String, attributsMsg, 3);
        NSParameterAssert(ret);
        
        //msg 属性
        objc_property_attribute_t typeData = { "T", "@\"id\"" };//T：类型
        objc_property_attribute_t ownershipData = { "S", "" }; //
        objc_property_attribute_t nonatomicData = { "N", "" }; // N：nonatomic
        objc_property_attribute_t attributsMsgData[] = { typeData, ownershipData, nonatomicData };
        ret = class_addProperty(baseRespClass, self.config.respDataKey.UTF8String, attributsMsgData, 3);
        NSParameterAssert(ret);
    }
    return baseRespClass;
}*/

-(void) fireWithMockData:(NSData*)mockData method:(NSString*) method path:(NSString*) path param:(NSDictionary*)param headers:(NSDictionary*)headValue body:(id<NSObject>) bodyModel responseModelClass:(Class)modelClass success:(void(^)(id model)) successBlk failure:(void(^)(NSError * error)) failueBlk
{
    NSAssert(nil != self.config, @"缺少配置，请先调用configInvoker进行配置");
    NSString* url = [NSString stringWithFormat:@"%@%@", [self baseUrl], path];
    NSDictionary* realHeaders = [self realHeaders:headValue];
    
    [JsonModelHttp fireWithMockData:mockData method:method url:url param:param headers:realHeaders body:bodyModel responseModelClass:nil success:^(NSDictionary* respDic) {
        
        //格式不是json
        if (![respDic isKindOfClass:[NSDictionary class]])
        {
            NSError* err = [[NSError alloc] initWithDomain:FKApiLevelErrDomain code:-10000 userInfo:@{NSLocalizedDescriptionKey:@"响应格式有误"}];
            !failueBlk?:failueBlk(err);
            return;
        }
        
        NSNumber* respCodeNum = respDic[self.config.respCodeKey];
        NSInteger respCode = [respCodeNum integerValue];
        NSString* msg = respDic[self.config.respMsgKey];
        //失败
        if (!respCodeNum || respCode != self.config.successCode)
        {
            NSError* err = [[NSError alloc] initWithDomain:FKApiLevelErrDomain code:respCode userInfo:@{NSLocalizedDescriptionKey:msg?:@"请求失败"}];
            !failueBlk?:failueBlk(err);
            
            //token到期通知
            if (respCode == self.config.tokenExpiredCode){
                !self.tokenExpiredBlk?:self.tokenExpiredBlk();
            }
            return;
        }
        
        //成功
        id dataModel = respDic[self.config.respDataKey];
        if (modelClass)
        {
            //对象
            if ([dataModel isKindOfClass:[NSDictionary class]])
            {
                dataModel = [modelClass yy_modelWithJSON:dataModel];
            }
            //数组
            else if ([dataModel isKindOfClass:[NSArray class]])
            {
                dataModel = [NSArray yy_modelArrayWithClass:modelClass json:dataModel];
            }
        }
        !successBlk?:successBlk(dataModel);
    } failure:^(NSError *error) {
        NSError* err = [[NSError alloc] initWithDomain:FKApiLevelErrDomain code:error.code userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription}];
        !failueBlk?:failueBlk(err);
    }];
}

+(void) fireWithMockData:(NSData*)mockData method:(NSString*) method path:(NSString*) path param:(NSDictionary*)param headers:(NSDictionary*)headValue body:(id<NSObject>) bodyModel responseModelClass:(Class)modelClass success:(void(^)(id model)) successBlk failure:(void(^)(NSError * error)) failueBlk
{
    [[FKApiInvoker sharedInvoker] fireWithMockData:mockData method:method path:path param:param headers:headValue body:bodyModel responseModelClass:modelClass success:successBlk failure:failueBlk];
}

-(NSDictionary*) realHeaders:(NSDictionary*) headers
{
    NSMutableDictionary* realHeaders = (self.config.commonHeaders?:@{}).mutableCopy;
    for (NSString* key in headers.allKeys) {
        realHeaders[key] = realHeaders[key];
    }
    return realHeaders;
}

-(NSString*) baseUrl
{
    return self.config.baseUrls[self.apiLevel];
}

static FKApiInvoker* __fkApiInvoker = nil;
+(instancetype) sharedInvoker
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __fkApiInvoker = [[super allocWithZone:NULL] init];
    });
    return __fkApiInvoker;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInvoker];
}

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNumber* apilevelNum = [[NSUserDefaults standardUserDefaults] objectForKey:FKApiLevelDefaultsKey];
        if (apilevelNum != nil) {
            _apiLevel = [apilevelNum integerValue];
        } else {
            _apiLevel = FKApiLevel_prd;
        }
    }
    return self;
}

@end
