//
//  PushManager.m
//  就手快车乘客端
//
//  Created by 冼嘉良 on 2018/3/28.
//  Copyright © 2018年 the fifth. All rights reserved.
//

#import "PushManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PushManager()  <JPUSHRegisterDelegate>
@end
@implementation PushManager
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
-(void)registerPush:(NSDictionary *)launchOptions{
    //监听极光发过来的通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification object:nil];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        NSLog(@"第一次启动");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }else{
        NSLog(@"不是第一次启动");
    }
    
    //初始化APNs
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        }
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //初始化JPush
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:PUSH_KEY channel:@"nihao" apsForProduction:0 advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
//            //登录前获取registrationID
//            NSString *filePath = [NSString stringWithFormat:@"%@registrationId.text",DOCUMENTPATH];
//            if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//                NSString *registrationIdStr = registrationID;
//                [registrationIdStr writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
//            }
            //如登录前未获取到registrationID,登录后手动更新registrationID
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
#pragma mark- JPUSHRegisterDelegate
// APP打开收到回调
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
     [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:userInfo];
}

//点击通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:userInfo];
}

//在APP打开的情况下，接收自定义的方法
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    //处理通知的方法
    NSDictionary *userInfo = [notification userInfo];
    NSString *jsonStr = userInfo[@"extras"][@"object"];
    NSDictionary * infoDic = [Header parseJSONStringToNSDictionary:jsonStr];
    NSString *action = [infoDic[@"action"] stringValue];
    [[NSNotificationCenter defaultCenter]postNotificationName:action object:nil userInfo:infoDic];
}

@end
