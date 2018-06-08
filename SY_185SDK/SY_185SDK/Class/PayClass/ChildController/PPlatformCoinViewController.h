//
//  PPlatformCoinViewController.h
//  BTWan
//
//  Created by 石燚 on 2017/7/19.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlatformCoinDelegate <NSObject>

/** 平台币支付 */
- (void)PlatformCoinControllerSelectPlatformCoinpay;


@end

@interface PPlatformCoinViewController : UIViewController

@property (nonatomic, weak) id<PlatformCoinDelegate> delegate;

/** 充值类型标签 */
@property (nonatomic, strong) NSString *rechargeTitle;
/** 充值账号 */
@property (nonatomic, strong) NSString *rechargeAccount;


@end
