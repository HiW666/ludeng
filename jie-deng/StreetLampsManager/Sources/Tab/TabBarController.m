//
//  TabBarController.m
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/24.
//  Copyright © 2019 xjl. All rights reserved.
//

#import "TabBarController.h"
#import "DeviceListViewController.h"
#import "FourPingTransition.h"
#import "ErrorListViewController.h"
#import "TabBarView.h"
@interface TabBarController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) TabBarView *tabBarView;
@end

@implementation TabBarController
-(instancetype)init{
    if(self = [super init]){
        self.transitioningDelegate = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.alpha = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildVC];
    [self addTabBarView];
}
-(void)addChildVC{
    DeviceListViewController *deviceVC = [[DeviceListViewController alloc]init];
    ErrorListViewController *errorVC = [[ErrorListViewController alloc]init];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:deviceVC];
     UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:errorVC];
    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
}
-(void)addTabBarView{
    self.tabBarView = [[NSBundle mainBundle]loadNibNamed:@"TabBarView" owner:self options:nil].firstObject;
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    self.tabBarView.frame = CGRectMake(0, SCRH-Height_TabBar, SCRW, Height_TabBar);
    [self.view addSubview:self.tabBarView];
    
    __weak TabBarController *weakSelf = self;
    self.tabBarView.selectedIndex = ^(NSInteger selectedIndex){
        weakSelf.selectedIndex = selectedIndex;
    };
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [FourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [FourPingTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}
@end
