//
//  ListContentView.m
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/29.
//  Copyright © 2019 xjl. All rights reserved.
//

#import "ListContentView.h"
@interface ListContentView ()
@property (weak, nonatomic) IBOutlet UIButton *chooseTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) NSString *statusStr;

@end
@implementation ListContentView

-(void)awakeFromNib{
    [super awakeFromNib];
    [[Header shareHeader]setCornerWithView:self.chooseTypeBtn WithCornerRadiu:4.0f WithBorderWith:1.0 WithBorderColor:COLOR(211, 211, 211)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeChooseView) name:@"removeChooseView" object:nil];
    self.statusStr = @"";
}
//选择状态搜索
- (IBAction)chooseTypeAction:(UIButton *)sender {
    NSArray *deviceStatusArr ;
    if(self.type == 0){
      deviceStatusArr = @[@{@"name":@"正常",@"code":@"0"},@{@"name":@"跳闸",@"code":@"1"},@{@"name":@"断开",@"code":@"2"}];
    }else if(self.type == 1){
        deviceStatusArr = @[@{@"name":@"未处理",@"code":@"0"},@{@"name":@"处理中",@"code":@"1"},@{@"name":@"已处理",@"code":@"2"}];
    }
    [self addChooseView:deviceStatusArr];
//    if([[NSFileManager defaultManager]fileExistsAtPath:[DOCUMENTPATH stringByAppendingFormat:@"status.plist"]]){
//        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[DOCUMENTPATH stringByAppendingFormat:@"status.plist"]];
//         NSArray *deviceStatusArr = @[];
//        if(self.type == 0){
//            deviceStatusArr = dic[@"DeviceStatus"];
//        }else if(self.type == 1){
//            deviceStatusArr = dic[@"DeviceMessageStatus"];
//        }
//
//        [self addChooseView:deviceStatusArr];
//
//       }else{
//           [self requestStatus];
//       }
}
//请求状态枚举
-(void)requestStatus{
    NSDictionary *paraDic = @{};
    NSString *urlStr = [API_HOST stringByAppendingFormat:COMMON_DIC];
     [Header requestDataWithURLOfPost:urlStr WithParaDic:paraDic WithSucess:^(id result) {
        NSDictionary *resDic = (NSDictionary *)result;
        NSInteger code = [resDic[@"code"] integerValue];
        if(code == 0){
            NSDictionary *dataDic = resDic[@"data"];
            [dataDic writeToFile:[DOCUMENTPATH stringByAppendingFormat:@"status.plist"] atomically:YES];
            NSArray *deviceStatusArr = @[];
            if(self.type == 0){
                deviceStatusArr = dataDic[@"DeviceStatus"];
            }else if(self.type == 1){
                deviceStatusArr = dataDic[@"DeviceMessageStatus"];
            }
            [self addChooseView:deviceStatusArr];
        }else{
            [[Header shareHeader]showToastWithTitle:@"服务器异常，请检查网络"];
        }
    } WithFail:^(NSString *errorStr) {
        [[Header shareHeader]showToastWithTitle:@"网络异常，请检查网络"];
    }];
}
-(void)addChooseView:(NSArray *)statusArr{
    self.chooseView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 65,(statusArr.count + 1)*30)];
    self.chooseView.backgroundColor = COLOR(235, 235, 235);
    [self.lowView addSubview:self.chooseView];
    
    for (NSInteger i =0; i<statusArr.count +1 ; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*30, 65, 30)];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        if(i == 0){
            [btn setTitle:@"所有" forState:UIControlStateNormal];
            btn.tag = 99;
        }else{
            NSDictionary *dic = statusArr[i-1];
            [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
            NSInteger code = [dic[@"code"] integerValue];
            btn.tag = 100+code;
        }
        [btn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseView addSubview:btn];
    }
}
-(void)chooseAction:(UIButton *)sender{
    [self.chooseView removeFromSuperview];
    [self.chooseTypeBtn setTitle:sender.currentTitle forState:UIControlStateNormal];
    if(sender.tag==99){
        self.statusStr = @"";
    }else{
        self.statusStr = @(sender.tag - 100).stringValue;
    }
    self.chooseView = nil;
}
//开始搜索
- (IBAction)searchAction:(UIButton *)sender {
    self.chooseBlock(@{@"status":self.statusStr,@"name":self.searchTF.text?self.searchTF.text:@""});
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeChooseView];
}
-(void)removeChooseView{
    [self.chooseView removeFromSuperview];
    self.chooseView = nil;
}
@end
