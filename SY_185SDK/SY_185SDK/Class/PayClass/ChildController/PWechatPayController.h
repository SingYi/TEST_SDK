//
//  PWechatPayController.h
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WechatPayDelegate <NSObject>

/** 选择支付 */
- (void)WechatPayControllerSelectWechatpay;

/** 二维码支付 */
- (void)WechatPayControllerSelectQRpay;

@end

@interface PWechatPayController : UIViewController

@property (nonatomic, weak) id<WechatPayDelegate> delegate;

/** 充值类型标签 */
@property (nonatomic, strong) NSString *rechargeTitle;
/** 充值账号 */
@property (nonatomic, strong) NSString *rechargeAccount;

@end


