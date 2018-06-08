//
//  PPlatformCoinViewController.m
//  BTWan
//
//  Created by 石燚 on 2017/7/19.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "PPlatformCoinViewController.h"
#import "UserModel.h"

@interface PPlatformCoinViewController ()


/** 剩余平台币 */
@property (nonatomic, strong) UILabel *lastCoin;

/** 充值账号 */
@property (nonatomic, strong) UILabel *accountLabel;

/** 充值类型 */
@property (nonatomic, strong) UILabel *rechargeTypeLabel;

/** 充值按钮 */
@property (nonatomic, strong) UIButton *rechargeBtn;

@end

@implementation PPlatformCoinViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.lastCoin.text = [NSString stringWithFormat:@"剩余平台币 : %@",[UserModel currentUser].platform_money];
}

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
    [self.view addSubview:self.lastCoin];
}

#pragma mark - method
- (void)respondsTorechagreButton {
    if ([self.delegate respondsToSelector:@selector(PlatformCoinControllerSelectPlatformCoinpay)]) {
        [self.delegate PlatformCoinControllerSelectPlatformCoinpay];
    }
}


#pragma mark - setter
- (void)setRechargeTitle:(NSString *)rechargeTitle {
    _rechargeTitle = rechargeTitle;
    self.rechargeTypeLabel.text = [NSString stringWithFormat:@"支付金额 : %.0f平台币",rechargeTitle.floatValue * 10];
}

- (void)setRechargeAccount:(NSString *)rechargeAccount {
    _rechargeAccount = rechargeAccount;
    self.accountLabel.text = [NSString stringWithFormat:@"充值账号 : %@",rechargeAccount];
}

#pragma mark - getter
/** 剩余平台币 */
- (UILabel *)lastCoin {
    if (!_lastCoin) {
        _lastCoin = [[UILabel alloc] init];
        _lastCoin.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _lastCoin.center = CGPointMake(view_width / 2, view_height * 0.3);
        _lastCoin.textColor = TEXTCOLOR;
        _lastCoin.textAlignment = NSTextAlignmentCenter;
    }
    return _lastCoin;
}
/** 充值账号 */
- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _accountLabel.center = CGPointMake(view_width / 2, view_height * 0.45);
        _accountLabel.textColor = TEXTCOLOR;
        _accountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _accountLabel;
}

/** 充值类型 */
- (UILabel *)rechargeTypeLabel {
    if (!_rechargeTypeLabel) {
        _rechargeTypeLabel = [[UILabel alloc] init];
        _rechargeTypeLabel.bounds = CGRectMake(0, 0, view_width * 0.8, 30);
        _rechargeTypeLabel.center = CGPointMake(view_width / 2, view_height * 0.45 + 40);
        _rechargeTypeLabel.textColor = TEXTCOLOR;
        _rechargeTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rechargeTypeLabel;
}

/** 充值按钮 */
- (UIButton *)rechargeBtn {
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rechargeBtn.bounds = CGRectMake(0, 0, view_width / 2 - 10, 36);
        _rechargeBtn.center = CGPointMake(view_width / 2, view_height * 0.7);
        [_rechargeBtn setTitle:@"平台币支付" forState:(UIControlStateNormal)];
        [_rechargeBtn setBackgroundColor:BUTTON_GREEN_COLOR];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rechargeBtn.layer.cornerRadius = 8;
        _rechargeBtn.layer.masksToBounds = YES;
        [_rechargeBtn addTarget:self action:@selector(respondsTorechagreButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rechargeBtn;
}




@end
