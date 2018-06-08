//
//  SY185SDK.h
//  SY_185SDK
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SY185SDKDelegate <NSObject>

/**
 *  SDK初始化回调:
 *  初始化成功后可以掉起登录页面,否则无法掉起登录页面;
 */
- (void)m185SDKInitCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

/**
 *  登录的回调:
 *  成功: success 返回 true,dict 里返回 username 和 userToken
 *  失败: success 返回 false,dict 里返回 error message
 */
- (void)m185SDKLoginCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

/**
 *  登出的回调:
 *  这个回调是从 SDK 登出的回调
 */
- (void)m185SDKLogOutCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nullable)dict;

/**
 *  充值回调
 */
- (void)m185SDKRechargeCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;

/**
 *  GM 权限发送道具成功回调
 */
- (void)m185SDKGMFunctionSendPropsCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict;


@end

@interface SY185SDK : NSObject

/**
 *  SDK初始化:
 *  初始化设置接收回调的代理,不能为空,
 *  cocos2d 引擎游戏推荐不使用 window -> useWindow : NO;  u3d 引擎推荐使用 window : useWindow : YES
 *  具体显示情况,请根据开发中实际遇到的问题选择设置是否使用 window
 */
+ (void)initWithAppID:(NSString * _Nonnull)appID
               Appkey:(NSString * _Nonnull)appkey
             Delegate:(id<SY185SDKDelegate> _Nonnull)delegate
            UseWindow:(BOOL)useWindow;


/** 加载登录页面: */
+ (BOOL)showLoginView;

/** 登出: */
+ (void)signOut;

/** 是否使用 window */
+ (void)SDKUseWindow:(BOOL)useWindow;


/**
 *  发起支付:
 *  serverID \ serverName     : 服务器 ID \ 服务器名称
 *  roleID \ roleName         : 角色 ID \ 角色名称
 *  productID \ productName   : 产品 ID \ 产品名称
 *  amount                    : 金额 - > 单位 RMB (元) 最小充值金额1元 -> amount = 1;
 *  extension                 : 拓展
 *  completion 回调            : success = YES 为支付成功,否则失败(失败信息在 content 中显示)
 */
+ (void)payStartWithServerID:(NSString *_Nonnull)serverID
                  serverName:(NSString *_Nonnull)serverName
                      roleID:(NSString *_Nonnull)roleID
                    roleName:(NSString *_Nonnull)roleName
                   productID:(NSString *_Nonnull)productID
                 productName:(NSString *_Nonnull)productName
                      amount:(NSString *_Nonnull)amount
                   extension:(NSString *_Nullable)extension;


/**
 * GM 功能初始化
 * serverid : 服务器 ID ; serverName : 服务器名称
 * roleID : 角色 ID ; roleName : 角色名
 */
+ (void)initGMFunctionWithServerid:(NSString *_Nonnull)serverID
                        ServerName:(NSString *_Nonnull)serverName
                            RoleID:(NSString *_Nonnull)roleID
                          RoleName:(NSString *_Nonnull)roleName;





@end
