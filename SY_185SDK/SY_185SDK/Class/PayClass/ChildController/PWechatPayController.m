//
//  PWechatPayController.m
//  SDK185SY
//
//  Created by 石燚 on 2017/6/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PWechatPayController.h"

@interface PWechatPayController ()

/** 充值账号 */
@property (nonatomic, strong) UILabel *accountLabel;

/** 充值类型 */
@property (nonatomic, strong) UILabel *rechargeTypeLabel;

/** 充值按钮 */
@property (nonatomic, strong) UIButton *rechargeBtn;

/** 二维码按钮 */
@property (nonatomic, strong) UIButton *QRCodeBtn;

@end

@implementation PWechatPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(PAYVIEW_WIDTH / 3 + 1, 0, PAYVIEW_WIDTH / 3 * 2 - 1, PAYVIEW_HEIGHT);
    
    [self.view addSubview:self.accountLabel];
    [self.view addSubview:self.rechargeTypeLabel];
    [self.view addSubview:self.rechargeBtn];
    [self.view addSubview:self.QRCodeBtn];
}

- (void)respondsToRechargeButton {
    if ([self.delegate respondsToSelector:@selector(WechatPayControllerSelectWechatpay)]) {
        [self.delegate WechatPayControllerSelectWechatpay];
    }
}

- (void)respondsToQRRechargeButton {
    if ([self.delegate respondsToSelector:@selector(WechatPayControllerSelectQRpay)]) {
        [self.delegate WechatPayControllerSelectQRpay];
    }
}

#pragma mark - setter
- (void)setRechargeTitle:(NSString *)rechargeTitle {
    _rechargeTitle = rechargeTitle;
    self.rechargeTypeLabel.text = [NSString stringWithFormat:@"支付金额 : %@ 元",rechargeTitle];
}

- (void)setRechargeAccount:(NSString *)rechargeAccount {
    _rechargeAccount = rechargeAccount;
    self.accountLabel.text = [NSString stringWithFormat:@"充值账号 : %@",rechargeAccount];
}

#pragma mark - getter
- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _accountLabel.center = CGPointMake(view_width / 2, view_height * 0.3);
        _accountLabel.text = @"充值账号: sjfaklsjdfas";
        _accountLabel.textColor = TEXTCOLOR;
        _accountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLabel;
}

- (UILabel *)rechargeTypeLabel {
    if (!_rechargeTypeLabel) {
        _rechargeTypeLabel = [[UILabel alloc] init];
        _rechargeTypeLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _rechargeTypeLabel.center = CGPointMake(view_width / 2, view_height * 0.3 + 40);
        _rechargeTypeLabel.text = @"充值类型: 30元月卡";
        _rechargeTypeLabel.textColor = TEXTCOLOR;
        _rechargeTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rechargeTypeLabel;
}

- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rechargeBtn.bounds = CGRectMake(0, 0, view_width / 2 - 10, 36);
        _rechargeBtn.center = CGPointMake(view_width / 4, view_height * 0.7);
        [_rechargeBtn setTitle:@"微信支付" forState:(UIControlStateNormal)];
        [_rechargeBtn setBackgroundColor:BUTTON_GREEN_COLOR];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rechargeBtn.layer.cornerRadius = 8;
        _rechargeBtn.layer.masksToBounds = YES;
        [_rechargeBtn addTarget:self action:@selector(respondsToRechargeButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rechargeBtn;
}

- (UIButton *)QRCodeBtn {
    if (!_QRCodeBtn) {
        _QRCodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _QRCodeBtn.bounds = CGRectMake(0, 0, view_width / 2 - 10, 36);
        _QRCodeBtn.center = CGPointMake(view_width / 4 * 3, view_height * 0.7);
        [_QRCodeBtn setTitle:@"扫码支付" forState:(UIControlStateNormal)];
        [_QRCodeBtn setBackgroundColor:BUTTON_YELLOW_COLOR];
        _QRCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _QRCodeBtn.layer.cornerRadius = 8;
        _QRCodeBtn.layer.masksToBounds = YES;
        
        [_QRCodeBtn addTarget:self action:@selector(respondsToQRRechargeButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _QRCodeBtn;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
