//
//  PTenpayController.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol TenPayDelegate <NSObject>

/** 选择支付 */
- (void)TenPayControllerSelectTenPay;

@end

@interface PTenpayController : UIViewController

@property (nonatomic, weak) id<TenPayDelegate> delegate;

/** 充值类型标签 */
@property (nonatomic, strong) NSString *rechargeTitle;
/** 充值账号 */
@property (nonatomic, strong) NSString *rechargeAccount;

@end

