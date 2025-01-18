//
//  ListContentView.h
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/29.
//  Copyright © 2019 xjl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListContentView : UIView
@property (weak, nonatomic) IBOutlet UIView *lowView;
@property (nonatomic,copy) void(^chooseBlock)(NSDictionary *);
@property (nonatomic,assign) NSInteger type;    // 0 设备列表  1 故障信息列表
@end

NS_ASSUME_NONNULL_END
