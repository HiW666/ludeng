//
//  ViewController.m
//  自定义登录界面
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarController.h"
#import "JpushService.h"

@interface LoginViewController ()
@property (nonatomic,strong) UITextField *userNameTF;
@property (nonatomic,strong) UITextField *passwordTF;
@end

@implementation LoginViewController

-(instancetype)init{
    if(self = [super init]){
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer addSublayer: [self backgroundLayer]];
    [self setUp];
    [self autoLogin];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.userNameTF.text = [USER_DEFAULT objectForKey:@"account"];
    self.passwordTF.text = [USER_DEFAULT objectForKey:@"password"];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];
}
-(void)setUp{
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCRW, 150)];
    headImageView.image =[UIImage imageNamed:@"login_head"];
    [self.view addSubview:headImageView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 180, SCRW, 25)];
    nameLab.text = @"管理系统";
    nameLab.textAlignment = 1;
    nameLab.font = [UIFont systemFontOfSize:23.0f];
    [self.view addSubview:nameLab];
    
    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    detail.center = CGPointMake(self.view.center.x,630+Height_viewToTop);
    detail.textColor = [UIColor lightGrayColor];
    detail.text = @"欢迎使用";
    detail.font = [UIFont systemFontOfSize:13.f];
    detail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detail];
    
    self.userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(40, 300, SCRW-80, 30)];
    self.userNameTF.textColor = [UIColor blackColor];
    self.userNameTF.borderStyle = UITextBorderStyleNone;
    self.userNameTF.placeholder = @"请输入您的账号";
//    self.userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    self.userNameTF.font = [UIFont systemFontOfSize:14.0f];
    self.userNameTF.text = [USER_DEFAULT objectForKey:@"account"];
    
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 332, SCRW-80, 1)];
    line1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:line1];
    [self.view addSubview:self.userNameTF];
    
    self.passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(40, 355, SCRW-130, 30)];
    self.passwordTF.placeholder = @"请输入您的密码";
    self.passwordTF.font = [UIFont systemFontOfSize:14.0f];
    self.passwordTF.textColor = [UIColor blackColor];
    self.passwordTF.borderStyle = UITextBorderStyleNone;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.text = [USER_DEFAULT objectForKey:@"password"];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 387, SCRW-80, 1)];
    line2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:line2];
    [self.view addSubview:self.passwordTF];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCRW-40-30, 360, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"pwd_close"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pwd_open"] forState:UIControlStateSelected];
    btn.backgroundColor = [UIColor whiteColor];
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(showPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 250, 40)];
    loginBtn.center = CGPointMake(self.view.center.x, self.passwordTF.center.y+100);
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor blackColor];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font =[UIFont systemFontOfSize:15.0f];
    [[Header shareHeader]setCornerWithView:loginBtn WithCornerRadiu:22.0 WithBorderWith:0 WithBorderColor:nil];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}


-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.65,@1];
    return gradientLayer;
}
-(void)showPwd:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !sender.selected;
}
-(void)login:(UIButton *)sender{
    if(self.userNameTF.text.length == 0){
        [[Header shareHeader]showToastWithTitle:@"请填写您的账号"];
        return ;
    }
    if(self.passwordTF.text.length == 0){
        [[Header shareHeader]showToastWithTitle:@"请填写密码"];
        return;
    }
    [self loginRequest];
}
//登陆请求
-(void)loginRequest{
    UIView *loadingView = [[Header shareHeader]loadingView:self.view];
    NSDictionary *paramDic = @{@"account":self.userNameTF.text,@"password":self.passwordTF.text};
    NSString *urlStr = [API_HOST stringByAppendingFormat:LOGIN];
    [Header requestDataWithURLOfPost:urlStr WithParaDic:paramDic WithSucess:^(id result) {
        
        NSDictionary *resDic = (NSDictionary *)result;
        NSInteger code = [resDic[@"code"] integerValue];
        if(code == 0){
            NSDictionary *data =resDic[@"data"];
            NSString *token = data[@"token"];
//            NSString *userNumber = data[@"userNumber"];
//            NSString *name = data[@"name"];
//            NSArray *roles = data[@"roles"];
            TabBarController *tabVC = [[TabBarController alloc]init];
//            [self presentViewController:tabVC animated:YES completion:^{
//                [loadingView removeFromSuperview];
//            }];
            [self.navigationController pushViewController:tabVC animated:YES];
            [loadingView removeFromSuperview];
            [self.navigationController popToViewController:tabVC animated:YES];
            [USER_DEFAULT setObject:self.userNameTF.text forKey:@"account"];
            [USER_DEFAULT setObject:self.passwordTF.text forKey:@"password"];
            [USER_DEFAULT setObject:token forKey:@"token"];
            [self setPushAlias:data[@"userNumber"]];
        }else{
            [loadingView removeFromSuperview];
             [[Header shareHeader]showToastWithTitle:resDic[@"msg"]];
        }
        
    } WithFail:^(NSString *errorStr) {
         [loadingView removeFromSuperview];
        [[Header shareHeader]showToastWithTitle:@"网络出错 请稍后再试"];
    }];
}
//自动登陆
-(void)autoLogin{
    NSString *pwd = [USER_DEFAULT objectForKey:@"password"];
    if(pwd.length>3){
        [self loginRequest];
    }
}
//设置推送别名
-(void)setPushAlias:(NSString *)aliasName{
//    NSString *account = [USER_DEFAULT objectForKey:@"account"];
    [JPUSHService setAlias:aliasName completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"");
    } seq:520];

 }

@end
