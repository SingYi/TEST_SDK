//
//  ViewController.m
//  SY_185SDK_Demo
//
//  Created by 燚 on 2017/9/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "ViewController.h"
#import <SY_185SDK/SY185SDK.h>

#define kScreen_width ([UIScreen mainScreen].bounds.size.width)
#define kScreen_height ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *signOutButton;
@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) UIButton *gmButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor grayColor];

    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.signOutButton];
    [self.view addSubview:self.payButton];
    [self.view addSubview:self.gmButton];
}


#pragma mark - responds
- (void)respondsToLoginButton {
     [SY185SDK showLoginView];
}

- (void)respondsToSignButton {
     [SY185SDK signOut];
}

- (void)respondsToPayButton {
    [SY185SDK payStartWithServerID:@"1" serverName:@"1" roleID:@"1" roleName:@"1" productID:@"1" productName:@"1" amount:@"1" extension:nil];
}

- (void)respondsToGMButton {
    [SY185SDK initGMFunctionWithServerid:@"1" ServerName:@"1" RoleID:@"1" RoleName:@"1"];
}


#pragma mark - getter
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
        _loginButton.bounds = CGRectMake(0, 0, kScreen_width * 0.8, 44);
        _loginButton.center = CGPointMake(kScreen_width / 2, 100);
        _loginButton.backgroundColor = [UIColor orangeColor];
        [_loginButton addTarget:self action:@selector(respondsToLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)signOutButton {
    if (!_signOutButton) {
        _signOutButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_signOutButton setTitle:@"登出" forState:(UIControlStateNormal)];
        _signOutButton.bounds = CGRectMake(0, 0, kScreen_width * 0.8, 44);
        _signOutButton.center = CGPointMake(kScreen_width / 2, 150);
        _signOutButton.backgroundColor = [UIColor orangeColor];
        [_signOutButton addTarget:self action:@selector(respondsToSignButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signOutButton;
}

- (UIButton *)payButton {
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_payButton setTitle:@"发起支付" forState:(UIControlStateNormal)];
        _payButton.bounds = CGRectMake(0, 0, kScreen_width * 0.8, 44);
        _payButton.center = CGPointMake(kScreen_width / 2, 200);
        _payButton.backgroundColor = [UIColor orangeColor];
        [_payButton addTarget:self action:@selector(respondsToPayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (UIButton *)gmButton {
    if (!_gmButton) {
        _gmButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_gmButton setTitle:@"初始化 GM" forState:(UIControlStateNormal)];
        _gmButton.bounds = CGRectMake(0, 0, kScreen_width * 0.8, 44);
        _gmButton.center = CGPointMake(kScreen_width / 2, 250);
        _gmButton.backgroundColor = [UIColor orangeColor];
        [_gmButton addTarget:self action:@selector(respondsToGMButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gmButton;
}

@end

















