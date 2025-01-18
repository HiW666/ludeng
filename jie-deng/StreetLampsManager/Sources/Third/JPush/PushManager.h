//
//  PushManager.h
//  就手快车乘客端
//
//  Created by 冼嘉良 on 2018/3/28.
//  Copyright © 2018年 the fifth. All rights reserved.
//

#import <Foundation/Foundation.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
@interface PushManager : NSObject

//单例
+ (instancetype)sharedInstance;
//注册JPush
-(void)registerPush:(NSDictionary *)launchOptions;

@end
