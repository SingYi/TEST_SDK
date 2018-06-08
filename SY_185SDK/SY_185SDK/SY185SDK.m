//
//  SY185SDK.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "SY185SDK.h"
#import "SYPayController.h"
#import "LoginController.h"
#import "SY_GMSDK.h"
#import "SYFloatViewController.h"
#import "SDK_ADImage.h"

@interface SY185SDK () <LoginControllerDeleagete, SYfloatViewDelegate, SYPayControllerDeleagete, GMFunctionDelegate, ADImageDelegate>

@property (nonatomic, weak) id<SY185SDKDelegate> delegate;

@end

static SY185SDK *sdk = nil;

@implementation SY185SDK

+ (SY185SDK *)sharedSDK {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sdk == nil) {
            sdk = [[SY185SDK alloc] init];
        }
    });
    return sdk;
}

#pragma mark - sdk init

+ (void)initWithAppID:(NSString *)appID Appkey:(NSString *)appkey Delegate:(id)delegate UseWindow:(BOOL)useWindow {
    SDKLOG(@"init start");
    //设置代理
    [SY185SDK sharedSDK].delegate = delegate;

    //请求映射 url
    [[MapModel sharedModel] getMapUrl:nil];

    //是否使用 window
    [SDKModel sharedModel].useWindow = useWindow;

    //设置 appkey
    [SDKModel sharedModel].AppKey = appkey;

    //初始化 app
    SDK_START_ANIMATION;
    [[SDKModel sharedModel] initWithApp:appID Appkey:appkey completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        //返回初始化结果

        if (success) {
            SDKLOG(@"init success");
            syLog(@"init content === %@",content);
            //保存数据
            [[SDKModel sharedModel] setAllPropertyWithDict:SDK_CONTENT_DATA];
            [SDKModel sharedModel].AppID = appID;
            [SDKModel sharedModel].AppKey = appkey;
            //设置是否加速
            [SYFloatViewController sharedController].allowSpeed = [SDKModel sharedModel].is_accelerate.boolValue;
            [SYFloatViewController sharedController].delegate = [SY185SDK sharedSDK];
            /** 用户登出 */
            SDK_USER_SELF_LOGOUT(@"0");
            /** 显示广告图片 */
            BOOL showAdImage = [SDK_ADImage showADImageWithDelegate:[SY185SDK sharedSDK] andStatus:content[@"status"]];
            if (showAdImage == NO) {
                /** 发送回调 */
                [SY185SDK returnM185SDkInitResuldWithSucces:success andStatus:content[@"status"]];
            }
        } else {
            NSString *status = content[@"status"];
            if (status.integerValue == 404) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    SDKLOG(@"time out reinit");
                    [SY185SDK initWithAppID:appID Appkey:appkey Delegate:delegate UseWindow:useWindow];
                });
            } else {
                SDKLOG(@"init failure");
                [SY185SDK returnM185SDkInitResuldWithSucces:success andStatus:content[@"status"]];
            }
        }
        SDKLOG(@"init end");
    }];
}


#pragma mark  - init method
/** 隐藏广告业 */
- (void)m185ADImage:(SDK_ADImage *)ADImage respondsToCloseButton:(id)info {
    /** 发送回调 */
    [SY185SDK returnM185SDkInitResuldWithSucces:YES andStatus:info];
}


/** 返回初始化结果代理 */
+ (void)returnM185SDkInitResuldWithSucces:(BOOL)success andStatus:(NSString *)status {
    SDKLOG(@"init call back start");
    NSDictionary *dict = nil;
    if (success && status.integerValue == 1) {
        success = YES;
        dict = @{@"status":@"1",@"状态":@"初始化成功"};
    } else {
        success = NO;
        dict = @{@"status":@"0",@"状态":@"初始化失败"};
    }

    if (sdk && sdk.delegate && [sdk.delegate respondsToSelector:@selector(m185SDKInitCallBackWithSuccess:withInformation:)]) {
        [sdk.delegate m185SDKInitCallBackWithSuccess:success withInformation:dict];
    }
    SDKLOG(@"init call back end");
}

#pragma mark - logout
+ (void)signOut {
    SDKLOG(@"external sign out");
    [[SYFloatViewController sharedController] signOut];
    [SY_GMSDK logOut];
}

#pragma mark - float delegate user logout
- (void)userSignOut {
    [SY_GMSDK logOut];
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKLogOutCallBackWithSuccess:withInformation:)]) {
        [self.delegate m185SDKLogOutCallBackWithSuccess:YES withInformation:@{@"msg":@"user sign out"}];
    }
}

#pragma mark - use window
+ (void)SDKUseWindow:(BOOL)useWindow {
    [SDKModel sharedModel].useWindow = useWindow;
}

#pragma mark - showLoginView
+ (BOOL)showLoginView {
    SDKLOG(@"show float view");
    if ([SDKModel sharedModel].AppID) {
        [LoginController showLoginViewUseTheWindow:[SDKModel sharedModel].useWindow WithDelegate:sdk];
    } else {
        SDK_MESSAGE(@"正在初始化或未接入网络,请稍后尝试");
    }
    return YES;
}

#pragma mark - pay
+ (void)payStartWithServerID:(NSString *)serverID serverName:(NSString *)serverName roleID:(NSString *)roleID roleName:(NSString *)roleName productID:(NSString *)productID productName:(NSString *)productName amount:(NSString *)amount extension:(NSString *)extension {

    [SYPayController payStartWithServerID:serverID serverName:serverName roleID:roleID roleName:roleName productID:productID productName:productName amount:amount extension:extension Delegate:[SY185SDK sharedSDK]];

}

#pragma mark - loginDelegate
- (void)loginController:(LoginController *)loginController loginSuccess:(BOOL)success withStatus:(NSDictionary *)dict {
    SDKLOG(@"login call back start");
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKLoginCallBackWithSuccess:withInformation:)]) {
        [self.delegate m185SDKLoginCallBackWithSuccess:success withInformation:dict];
    }


    if (success) {

//        syLog(@"======== %@",[SDKModel sharedModel].isdisplay_buoy);
        syLog(@"channel = %@",[SDKModel sharedModel].channel);

#warning show float view
        if ([SDKModel sharedModel].isdisplay_buoy.boolValue) {
            [SY185SDK showFloatView];
        }
    }


    SDKLOG(@"login call back end");
}

#pragma mark - pay delegate
- (void)m185_PayDelegateWithPaySuccess:(BOOL)success WithInformation:(NSDictionary *)dict {
    SDKLOG(@"pay call back start");
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKRechargeCallBackWithSuccess:withInformation:)]) {
        [self.delegate m185SDKRechargeCallBackWithSuccess:success withInformation:dict];
    }
    SDKLOG(@"pay call back end");
}

#pragma mark - float view
+ (void)showFloatView {
    [SYFloatViewController showFloatView];
}


#pragma mark - ================================================================================
#pragma mark - GM SDK
+ (void)initGMFunctionWithServerid:(NSString *)serverID
                        ServerName:(NSString *)serverName
                            RoleID:(NSString *)roleID
                          RoleName:(NSString *)roleName {

    if ([SDKModel sharedModel].AppID == nil || [[SDKModel sharedModel].AppID isEqualToString:@""]) {
        SDK_MESSAGE(@"GM 权限初始化失败\nSDK 尚未初始化");
        return;
    }

    if ([SDKModel sharedModel].AppKey == nil || [[SDKModel sharedModel].AppKey isEqualToString:@""]) {
        SDK_MESSAGE(@"GM 权限初始化失败\nSDK 尚未初始化");
        return;
    }

    if ([UserModel currentUser].username == nil || [[UserModel currentUser].username isEqualToString:@""]) {
        SDK_MESSAGE(@"用户尚未登录");
        return;
    }

    if ([UserModel currentUser].uid == nil || [[UserModel currentUser].uid isEqualToString:@""]) {
        SDK_MESSAGE(@"用户尚未登录");
        return;
    }

    [SY_GMSDK initGM_SDKWithAppid:[SDKModel sharedModel].AppID AppKey:[SDKModel sharedModel].AppKey Channel:SDK_GETCHANNELID Serverid:serverID ServerName:serverName UserName:[UserModel currentUser].username Uid:SDK_GETUID Role_di:roleID Role_name:roleName InitUrl:[MapModel sharedModel].GM_INIT PropListUrl:[MapModel sharedModel].GM_GET_PROP SendPropUrl:[MapModel sharedModel].GM_SEND_PROP UseWindow:[SDKModel sharedModel].useWindow Delegate:[SY185SDK sharedSDK]];
}

#pragma mark - GM SDK delegate
/** 初始化成功回调 */
- (void)GMSDK:(SY_GMSDK *)sdk initSuccess:(BOOL)success {
    if (success) {
        SDKLOG(@"GM fuction initialize success");
    } else {
        SDKLOG(@"GM function initialize failure");
    }
}

/** 发起支付回调 */
- (void)GMSDKPayStartServerID:(NSString *)serverID
   serverName:(NSString *)serverName
       roleID:(NSString *)roleID
     roleName:(NSString *)roleName
    productID:(NSString *)productID
  productName:(NSString *)productName
       amount:(NSString *)amount
    extension:(NSString *)extension {

    [SYPayController GMPayStartWithServerID:serverID serverName:serverName roleID:roleID roleName:roleName productID:productID productName:productName amount:amount extension:extension Delegate:[SY185SDK sharedSDK]];
}

/** 发送道具成功的回调 */
- (void)GMSDK:(SY_GMSDK *)sdk SendPropsSuccess:(BOOL)success WithInfo:(NSDictionary *)dict {
    if (self.delegate && [self.delegate respondsToSelector:@selector(m185SDKGMFunctionSendPropsCallBackWithSuccess:withInformation:)]) {
        [self.delegate m185SDKGMFunctionSendPropsCallBackWithSuccess:YES withInformation:dict];
    }
}


@end












