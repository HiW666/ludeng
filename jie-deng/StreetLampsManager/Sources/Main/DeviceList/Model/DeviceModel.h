//
//  DeviceModel.h
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/10/6.
//  Copyright © 2019 xjl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceModel : NSObject
@property (nonatomic,assign) NSInteger ID;                  //设备ID
@property (nonatomic,strong) NSString *number;              //设备编号
@property (nonatomic,strong) NSString *code;                //设备编码
@property (nonatomic,strong) NSString *name;                //设备名称
@property (nonatomic,assign) NSInteger status;             //设备状态
@property (nonatomic,strong) NSString *resetTime;           //重置时间
@property (nonatomic,strong) NSString *lastHeartBeatTime;   //最后更新时间(心跳时间)
@property (nonatomic,strong) NSString *area;                //区域
@property (nonatomic,strong) NSString *createTime;          //创建时间（添加时间）
@property (nonatomic,strong) NSString *updateTime;          //更新时间
@end

NS_ASSUME_NONNULL_END
