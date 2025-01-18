//
//  TabBarView.h
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/24.
//  Copyright © 2019 xjl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarView : UIView
@property (nonatomic,copy)void(^selectedIndex)(NSInteger);
@end

NS_ASSUME_NONNULL_END
