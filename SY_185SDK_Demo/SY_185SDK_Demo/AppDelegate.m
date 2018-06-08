//
//  AppDelegate.m
//  SY_185SDK_Demo
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "AppDelegate.h"
#import <SY_185SDK/SY185SDK.h>
#import <UserNotifications/UserNotifications.h>
#import "ViewController.h"

#define AppId @"1000"
#define ClientKey @"ce9660948c245bd6027153288ee12c13"
#define SystemVersion (([UIDevice currentDevice].systemVersion).doubleValue)

@interface AppDelegate ()<SY185SDKDelegate, UNUserNotificationCenterDelegate>



@end

@implementation AppDelegate

#pragma mark - delegate
- (void)m185SDKInitCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (success) {
        NSLog(@"appdelegate == 初始化成功");
    } else {
        NSLog(@"appdelegate == 初始化失败");
    }
    if (dict) {
        NSLog(@"appdelegate = init %@",dict);
    }
}

- (void)m185SDKLoginCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (dict) {
        NSLog(@"appdelegate = lgoin %@",dict);
    }
    if (success) {
        NSLog(@"登录成功");
    } else {
        NSLog(@"登录失败");
    }
}

- (void)m185SDKLogOutCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (dict) {
        NSLog(@"appdelegate =  %@",dict);
    }
    if (success) {
        NSLog(@"登出成功");
    }
}

- (void)m185SDKRechargeCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (dict) {
        NSLog(@"appdelegate = recharge %@",dict);
    }
    if (success) {
        NSLog(@"充值成功");
    } else {
        NSLog(@"充值失败");
    }
}

- (void)m185SDKGMFunctionSendPropsCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *_Nonnull)dict {
    if (success) {
        NSLog(@"GM 权限发送道具 : %@",dict);
    }
}

#pragma mark --------------------------


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [SY185SDK initWithAppID:AppId Appkey:ClientKey Delegate:self UseWindow:NO];

    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

//    UIImageWriteToSavedPhotosAlbum([UIImage new], self, NULL, NULL);

//    [self resignNotification];
//
//    [self pushtNotification];

    return YES;
}


- (void)resignNotification {
    // 使用 UNUserNotificationCenter 来管理通知
    if (SystemVersion > 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;

        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {

        }];
    }
}

- (void)pushtNotification {
    if (SystemVersion > 10.0) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"本地推送Title" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:@"本地推送Body"     arguments:nil];
        content.sound = [UNNotificationSound defaultSound];

        // 在 设定时间 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:5 repeats:NO];

        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                              content:content trigger:trigger];

        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {

        }];
    } else {
        // Fallback on earlier versions
    }

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
