//
//  ServerApi.h
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/16.
//  Copyright © 2019 xjl. All rights reserved.
//

#ifndef ServerApi_h
#define ServerApi_h

#define PUSH_KEY @"459912fc72e35bd025670e54"
#define PUSH_SECRET  @"46191185d36fec4de54a9c11"


//#define API_HOST @"http://yapi.demo.qunar.com/mock/1251"              //mock
#define API_HOST @"http://139.159.253.34:8069"                          //正式环境
//#define API_HOST @"http://172.31.1.186:8069"                          //本地环境


#define LOGIN  @"/user/login"                                         //用户登录
#define USER_INFO @"/user/info"                                       //用户信息
#define COMMON_DIC @"/user/dictionary"                                //状态枚举
#define DEVICE_LIST @"/dev/list"                                      //设备列表
#define DEVICE_ADD @"/dev/add"                                        //设备添加
#define DEVICE_UPDATE @"/dev/update"                                  //设备更新
#define DEVICE_FAULT_LIST @"/devMsg/list"                             //故障列表   




#endif /* ServerApi_h */
