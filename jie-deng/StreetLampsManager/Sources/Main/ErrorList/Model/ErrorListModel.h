//
//  ErrorListModel.h
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/10/9.
//  Copyright © 2019 xjl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN

@interface ErrorListModel : NSObject
@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,strong) NSString *number;
@property (nonatomic,strong) NSString *deviceNumber;
@property (nonatomic,strong) NSString *deviceCode;
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *secondPushTime;
@property (nonatomic,strong) NSString *pushState;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) NSString *dealTime;
@property (nonatomic,strong) NSString *dealUserNumber;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,assign) NSInteger devStatus;


@end

NS_ASSUME_NONNULL_END
