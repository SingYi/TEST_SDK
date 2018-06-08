//
//  LoginController.m
//  SY_185SDK
//
//  Created by 燚 on 2017/9/29.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "LoginController.h"
#import "m185_LoginBackGroundView.h"
#import "UserModel.h"
#import "SDKModel.h"
@class SY_BindingPhoneView;

#ifdef DEBUG

#define BACKGROUNDCOLOR controller.useWindow ? RGBACOLOR(0, 0, 200, 150) : RGBACOLOR(200, 0, 0, 150)

#else

#define BACKGROUNDCOLOR RGBACOLOR(111, 111, 111, 111)

#endif

#define LOGINSUCCESS \
    if (success) {\
    SDKLOG(@"log in success");\
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginController:loginSuccess:withStatus:)]) {\
        [self.delegate loginController:self loginSuccess:YES withStatus:@{@"status":@"1",@"username":SDK_CONTENT_DATA[@"username"],@"token":SDK_CONTENT_DATA[@"token"]}];\
    }\
    [UserModel saveAccount:account Password:password];\
    [[UserModel currentUser] setAllPropertyWithDict:SDK_CONTENT_DATA];\
    [viewController setUsername:account];\
    [viewController setPassWord:password];\
    [LoginController showBingPhoneView];\
    [viewController hideOtherView];\
    } else {\
        SDKLOG(@"log in failure");\
        [InfomationTool showAlertMessage:content[@"msg"] dismissTime:1 dismiss:nil];\
    }\


@interface LoginController ()<m185_LoginBackGroundViewDeleagte>

/** window 加载 */
@property (nonatomic, strong) UIWindow *loginControllerBackGroundWindow;
@property (nonatomic, strong) UIViewController *windowRootViewController;

/** view 加载 */
@property (nonatomic, strong) UIView *loginControllerBackGroundView;

/** 背景视图 */
@property (nonatomic, strong) m185_LoginBackGroundView *backgroundView;


@end


LoginController *controller = nil;


@implementation LoginController

#pragma mark - init
+ (LoginController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [[LoginController alloc] init];
        }
    });
    return controller;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addobserver];
        [self addAutoLoginView];
    }
    return self;
}

- (void)addAutoLoginView {
    NSString *autoLogin = SDK_ISAUTOLOGIN;
    NSString *isUserLogOut = SDK_USERDEFAULTS_GET_OBJECT(@"isUserLogOut");

    SDKModel *model = [SDKModel sharedModel];
    NSDictionary *dict = nil;
    if (model.username.length > 4) {
        dict = [UserModel getAccountAndPassword];
        NSString *account = dict[@"account"];
        NSString *password = dict[@"password"];
        if (account && password && [model.username isEqualToString:account]) {
            [self.backgroundView setUsername:account];
            [self.backgroundView setPassWord:password];
        } else {
            [self.backgroundView setUsername:model.username];
            [self.backgroundView setPassWord:@""];
            autoLogin = @"0";
        }

        if (autoLogin && autoLogin.integerValue != 0 && isUserLogOut.integerValue != 1) {
            SDKLOG(@"loading auto login view");
            [self.backgroundView addAutoLoginView];
        }

    } else {
#warning show one up register view
//        [self m185_loginBackGroundView:self.backgroundView respondsToOneUpResgister:nil];
        [self.backgroundView showPhoneLogin:YES];
    }
}




#pragma mark - show login controller
+ (void)showLoginViewUseTheWindow:(BOOL)useWindow
                     WithDelegate:(id<LoginControllerDeleagete>)delegate {

    [LoginController sharedController].delegate = delegate;

    controller.useWindow = useWindow;

    if ([UserModel currentUser].uid) {
        [InfomationTool showAlertMessage:@"已登录账号" dismissTime:0.7 dismiss:nil];
        return;
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:controller action:@selector(loginViewResignFirstResponds)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;

    if (useWindow) {
        [controller.loginControllerBackGroundWindow makeKeyAndVisible];
        [controller.windowRootViewController.view addSubview:controller.backgroundView];
        [controller.windowRootViewController.view addGestureRecognizer:tap];
    } else {
        [[InfomationTool rootViewController].view addSubview:controller.loginControllerBackGroundView];
        [controller.loginControllerBackGroundView addSubview:controller.backgroundView];
        [controller.loginControllerBackGroundView addGestureRecognizer:tap];
    }

}

- (void)loginViewResignFirstResponds {
    [self.backgroundView inputResignFirstResponds];
}

+ (void)signOut {
    [LoginController hideLoginView];
}

+ (void)hideLoginView {
    if (controller.useWindow) {
        [controller.loginControllerBackGroundWindow resignKeyWindow];
        controller.loginControllerBackGroundWindow = nil;
    } else {
        [controller.loginControllerBackGroundView removeFromSuperview];
    }
}

+ (void)showADPicView {
#warning show ad pic image view
    BOOL isShowAdPicView = [SDKModel sharedModel].isdisplay_ad.boolValue;
    if (isShowAdPicView) {
        [controller.backgroundView removeFromSuperview];
        if (controller.useWindow) {
            [controller.windowRootViewController.view addSubview:(UIView *)controller.backgroundView.adPicImageView];
        } else {
            [[InfomationTool rootViewController].view addSubview:(UIView *)controller.backgroundView.adPicImageView];
        }
    } else {
        [LoginController showBingPhoneView];
    }
}

+ (void)showBingPhoneView {
#warning show bind mobile view
    //添加绑定手机页面
//    BOOL isShowbindView = YES;
    BOOL isShowbindView = [SDKModel sharedModel].bind_mobile_enabled.boolValue;
    if (isShowbindView && ([UserModel currentUser].mobile == nil || [UserModel currentUser].mobile.length < 11)) {
        //显示绑定手机页面
        [controller.backgroundView removeFromSuperview];
        if (controller.useWindow) {
            [controller.windowRootViewController.view addSubview:(UIView *)controller.backgroundView.bingdingPhoneView];
        } else {
            [[InfomationTool rootViewController].view addSubview:(UIView *)controller.backgroundView.bingdingPhoneView];
        }
    } else {
        [LoginController showBindNameView];
    }
}

+ (void)showBindNameView {
#warning show bind idcard view
    BOOL isShowBindView = [SDKModel sharedModel].name_auth_enabled.boolValue;
    if (isShowBindView && ([UserModel currentUser].id_card == nil || [UserModel currentUser].id_card.length == 0)) {
        [controller.backgroundView removeFromSuperview];
        if (controller.useWindow) {
            [controller.windowRootViewController.view addSubview:(UIView *)controller.backgroundView.bindingIDCardView];
        } else {
            [[InfomationTool rootViewController].view addSubview:(UIView *)controller.backgroundView.bindingIDCardView];
        }
    } else {
        [LoginController hideLoginView];
    }
}

#pragma mark - close ad pic view
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToCloseADPicView:(id)info {
    [LoginController showBingPhoneView];
}

#pragma mark - close bind phone view
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToCloseBindingPhoneView:(id)info {
    [LoginController showBindNameView];
}



#pragma mark - delegate login
- (void)loginWithUserName:(BOOL)isUserName Account:(NSString *)account Password:(NSString *)password WithController:(m185_LoginBackGroundView *)viewController {
//    syLog(@"name == %@   password == %@",account,password);
    SDK_START_ANIMATION;
    if (isUserName) {
        [UserModel userLoginWithUserName:account PassWord:password completion:^(NSDictionary *content, BOOL success) {
            SDK_STOP_ANIMATION;
            LOGINSUCCESS;
        }];
    } else {
        [UserModel phoneLoginWithPhoneNumber:account Password:password completion:^(NSDictionary *content, BOOL success) {
            SDK_STOP_ANIMATION;
            LOGINSUCCESS;
        }];
    }
}

- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWituUserName:(NSString *)username PassWord:(NSString *)password {

    if (![self isLegalUserName:username]) {
        return;
    }

    if (![self isLegalPassword:password]) {
        return;
    }

    [self loginWithUserName:YES Account:username Password:password WithController:viewController];
}

- (void)m185_LoginBackGroundView:(m185_LoginBackGroundView *)viewController RespondsToLoginWitPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password {

    if (![self isLegalPhoneNumber:phoneNumber]) {
        return;
    }

    if (![self isLegalPassword:password]) {
        return;
    }

    [self loginWithUserName:NO Account:phoneNumber Password:password WithController:viewController];
}

#pragma mark - delegate one uo register
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToOneUpResgister:(NSString *)test {

#warning 是否继续申请一键注册.
    if ([SDKModel sharedModel].oneUpRegisterAccount && [SDKModel sharedModel].oneUpregisterPassword) {

        [viewController showOneUpRegisterViewWithUserName:[SDKModel sharedModel].oneUpRegisterAccount Password:[SDKModel sharedModel].oneUpregisterPassword];
    } else {

        SDK_START_ANIMATION;
        [UserModel oneUpRegisterWithcompletion:^(NSDictionary *content, BOOL success) {

            SDK_STOP_ANIMATION;
            if (success) {

                [viewController showOneUpRegisterViewWithUserName:SDK_CONTENT_DATA[@"username"] Password:[UserModel oneUpRegistPassword]];

                [SDKModel sharedModel].oneUpRegisterAccount = [NSString stringWithFormat:@"%@",(SDK_CONTENT_DATA[@"username"])];
                [SDKModel sharedModel].oneUpregisterPassword = [NSString stringWithFormat:@"%@",[UserModel oneUpRegistPassword]];

            } else {
                [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
            }

        }];
    }

}

#pragma mark - delegate to register
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToRegisterUserName:(NSString *)username Password:(NSString *)password {
    SDK_START_ANIMATION;
    [UserModel userRegisterWithUserName:username PassWord:password completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            [self loginWithUserName:YES Account:username Password:password WithController:viewController];
        } else {
            [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
        }
    }];
}

- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToRegisterPhoneNumber:(NSString *)phoneNumber Password:(NSString *)passowrd Code:(NSString *)code {
    SDK_START_ANIMATION;
    [UserModel phoneRegisterWithPhoneNumber:phoneNumber PassWord:passowrd Code:code completion:^(NSDictionary *content, BOOL success) {
        SDK_STOP_ANIMATION;
        if (success) {
            SDK_START_ANIMATION;
            [self loginWithUserName:NO Account:phoneNumber Password:passowrd WithController:viewController];
        } else {
            [InfomationTool showAlertMessage:[NSString stringWithFormat:@"%@",content[@"msg"]] dismissTime:0.7 dismiss:nil];
        }
    }];
}

#pragma mark - delegate auto login
- (void)m185_loginBackGroundView:(m185_LoginBackGroundView *)viewController respondsToAutoLoginWithAccount:(NSString *)account Password:(NSString *)password {

    NSDictionary *dict = [UserModel getAccountAndPassword];
    account = dict[@"account"];
    password = dict[@"password"];
    if (account && password) {
        [self loginWithUserName:YES Account:account Password:password WithController:viewController];
    } else {
        [viewController removeAutoLoginView];
    }

}

#pragma mark - check is legal
- (BOOL)isLegalUserName:(NSString *)username {
    if (username.length < 1) {
        [InfomationTool showAlertMessage:@"账号长度不正确" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    return YES;
}

- (BOOL)isLegalPassword:(NSString *)password {
    if (password.length < 1) {
        [InfomationTool showAlertMessage:@"密码长度不正确" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    return YES;
}

- (BOOL)isLegalPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length < 11) {
        [InfomationTool showAlertMessage:@"手机号长度不正确" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    //手机号有误
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (![regextestmobile evaluateWithObject:phoneNumber]) {
        [InfomationTool showAlertMessage:@"输入的手机号码有误" dismissTime:0.7 dismiss:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 监听屏幕旋转
/** 添加监听事件 */
- (void)addobserver {

    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];

    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];

    [notification addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];

}

/** 监听屏幕的旋转 */
- (void)orientationChanged:(NSNotification *)note  {
    if ([SDKModel sharedModel].useWindow) {
//        self.loginControllerBackGroundWindow.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
//        self.windowRootViewController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    } else {
        self.loginControllerBackGroundView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    }
    self.backgroundView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
}

+ (BOOL)isInit {
    if (controller) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - getter
- (UIWindow *)loginControllerBackGroundWindow {
    if (!_loginControllerBackGroundWindow) {
        _loginControllerBackGroundWindow = [[UIWindow alloc] init];
        _loginControllerBackGroundWindow.rootViewController = self.windowRootViewController;
        _loginControllerBackGroundWindow.backgroundColor = [UIColor clearColor];
        _loginControllerBackGroundWindow.windowLevel = SDK_WINDOW_LEVEL;
    }
    return _loginControllerBackGroundWindow;
}

- (UIViewController *)windowRootViewController {
    if (!_windowRootViewController) {
        _windowRootViewController = [[UIViewController alloc] init];
        _windowRootViewController.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        _windowRootViewController.view.backgroundColor = BACKGROUNDCOLOR;
    }
    return _windowRootViewController;
}

- (UIView *)loginControllerBackGroundView {
    if (!_loginControllerBackGroundView) {
        _loginControllerBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _loginControllerBackGroundView.backgroundColor = BACKGROUNDCOLOR;
//        _loginControllerBackGroundView.backgroundColor = [UIColor blackColor];
    }
    return _loginControllerBackGroundView;
}

- (m185_LoginBackGroundView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[m185_LoginBackGroundView alloc] init];
        _backgroundView.delegate = self;
    }
    return _backgroundView;
}




@end











