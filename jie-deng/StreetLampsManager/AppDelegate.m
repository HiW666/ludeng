//
//  AppDelegate.m
//  自定义登录界面
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DeviceListViewController.h"
#import <IQKeyboardManager.h>
#import "PushManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    [self initIQKeyboardManager];
    //初始化极光
    [[PushManager sharedInstance]registerPush:launchOptions];
    return YES;
}
- (void)initIQKeyboardManager{
    [IQKeyboardManager sharedManager].enable = YES;// 控制整个功能是否启用
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 控制是否显示键盘上的工具条
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;// 控制点击背景是否收起键盘
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0){
        
        [self resetBageNumber];
        
    }
}
-(void)resetBageNumber{
    
    UILocalNotification *clearEpisodeNotification= [[UILocalNotification alloc] init];
    
    clearEpisodeNotification.fireDate =[NSDate dateWithTimeIntervalSinceNow:(1*1)];
    
    clearEpisodeNotification.applicationIconBadgeNumber = -1;//这是最关键的代码，设置-1
    
    [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
#pragma mark -- <极光错误回调>
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
@end
