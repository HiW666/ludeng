//
//  DeviceModel.m
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/10/6.
//  Copyright © 2019 xjl. All rights reserved.
//

#import "DeviceModel.h"
#import "MJExtension.h"


@implementation DeviceModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
