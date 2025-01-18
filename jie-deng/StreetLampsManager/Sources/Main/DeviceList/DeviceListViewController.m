#import "DeviceListViewController.h"
#import "ListTableViewCell.h"
#import "ListContentView.h"
#import "CustomGifHeader.h"
#import "CustomGifFooter.h"
#import "CustomAutoGifFooter.h"
#import "MJExtension.h"
#import "DeviceModel.h"
#import "LoginViewController.h"
#import "JpushService.h"
@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ListContentView *contentView;
@property(nonatomic,strong)CustomGifHeader * gifHeader;
@property(nonatomic,strong)CustomGifFooter * gifFooter;
@property(nonatomic,strong)CustomAutoGifFooter * gifAutoFooter;
@property (nonatomic,strong) UIImageView *noDataImageView;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSMutableArray *deviceModelArr;
@end

@implementation DeviceListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设备列表";
    self.pageIndex = 1;
    self.deviceName = @"";
    self.status = @"";
    [self initContentView];
    [self addNoDataView];
    [self initTableView];
    [self requestData];
    [self addRightBtn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUpdateNoti:) name:@"update" object:nil];
}
-(void)getUpdateNoti:(NSNotification *)noti{
    [self requestData];
}
//请求数据
-(void)requestData{
    NSDictionary *paramDic = @{@"page":@(self.pageIndex),@"rows":@(10),@"token":[USER_DEFAULT objectForKey:@"token"],@"keyword":self.deviceName,@"status":self.status};
    NSString *urlStr = [API_HOST stringByAppendingFormat:DEVICE_LIST];
    [Header requestDataWithURLOfPost:urlStr WithParaDic:paramDic WithSucess:^(id result) {
        [self.gifFooter endRefreshing];
        [self.gifHeader endRefreshing];
        NSDictionary *resDic = (NSDictionary *)result;
        NSInteger code = [resDic[@"code"] integerValue];
        if(code == 0){
            NSDictionary *dataDic = resDic[@"data"];
            NSArray *list = dataDic[@"list"];
            if(list.count == 0){
                if(self.deviceModelArr.count == 0){
                    self.tableView.hidden = YES;
                }else{
                     [[Header shareHeader]showToastWithTitle:@"数据加载完毕"];
                }
                return ;
            }
            self.tableView.hidden = NO;
            NSArray *modelArr = [DeviceModel mj_objectArrayWithKeyValuesArray:list];
            [self.deviceModelArr addObjectsFromArray:modelArr];
            [self.tableView reloadData];
        }else{
            [[Header shareHeader]showToastWithTitle:@"请求数据出错 请稍后再试"];
        }
    } WithFail:^(NSString *errorStr) {
        [[Header shareHeader]showToastWithTitle:@"网络异常  请检查网络"];
    }];
    
}
-(void)initContentView{
    self.contentView = [[NSBundle mainBundle]loadNibNamed:@"ListContentView" owner:self options:nil].firstObject;
    self.contentView.frame = CGRectMake(0, 0, SCRW, self.view.frame.size.height);
    self.contentView.type = 0;
    [self.view addSubview:self.contentView];
    WeakSelf(self);
    self.contentView.chooseBlock = ^(NSDictionary *searchDic){
        weakSelf.status = searchDic[@"status"];
        weakSelf.deviceName = searchDic[@"name"];
        [weakSelf.deviceModelArr  removeAllObjects];
        weakSelf.pageIndex = 1;
        [weakSelf requestData];
    };
}
-(void)addNoDataView{
    self.noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, SCRW-200, SCRW-200)];
    self.noDataImageView.image = [UIImage imageNamed:@"no_data"];
    [self.contentView.lowView addSubview:self.noDataImageView];
}
-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCRW, SCRH-44-Height_NavBar-Height_TabBar)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.contentView.lowView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"listCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.mj_header = self.gifHeader;
    self.tableView.mj_footer = self.gifFooter;
    // _tableView.mj_footer = self.gifAutoFooter;
    
    self.tableView.hidden = YES;
}
- (CustomGifHeader *)gifHeader {
    if (!_gifHeader) {
        _gifHeader = [CustomGifHeader headerWithRefreshingBlock:^{
            self.pageIndex = 1;
            [self.deviceModelArr removeAllObjects];
            [self requestData];
        }];
    }
    return _gifHeader;
}

- (CustomGifFooter *)gifFooter {
    if (!_gifFooter) {
        _gifFooter = [CustomGifFooter footerWithRefreshingBlock:^{
            self.pageIndex+=1;
            [self requestData];
            
        }];
    }
    return _gifFooter;
}

- (CustomAutoGifFooter *)gifAutoFooter {
    if (!_gifAutoFooter) {
        _gifAutoFooter = [CustomAutoGifFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
            });
        }];
    }
    return _gifAutoFooter;
}
-(void)addRightBtn{
    UIButton *logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logBtn setTitle:@"注销" forState:UIControlStateNormal];
    [logBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    logBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [logBtn addTarget:self action:@selector(logOutAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logBtn];
}
//注销
-(void)logOutAction:(UIButton *)sender{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要注销当前账号吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        UIViewController *currentVC = [[Header shareHeader]getCurrentViewController];
        for (UIViewController *vc in currentVC.navigationController.viewControllers) {
            if([vc isKindOfClass:[LoginViewController class]]){
                [currentVC.navigationController popToViewController:vc animated:YES];
                [USER_DEFAULT setObject:@"" forKey:@"password"];
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    NSLog(@"删除别名");
                } seq:520];
                break;
            }
        }
    }];
    [self presentViewController:alertVC animated:YES completion:nil];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
}

#pragma  mark -- <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceModelArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    DeviceModel *model = self.deviceModelArr[indexPath.row];
    [cell setCustomViewsWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
//    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeChooseView" object:nil];
}
-(NSMutableArray *)deviceModelArr{
    if(!_deviceModelArr){
        _deviceModelArr = [[NSMutableArray alloc]init];
    }return _deviceModelArr;
}

@end
