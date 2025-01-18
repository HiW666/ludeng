//
//  ListTableViewCell.h
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/19.
//  Copyright © 2019 xjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"
#import "ErrorListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewCell : UITableViewCell
-(void)setCustomViewsWithModel:(DeviceModel *)deviceModel;
-(void)setCustomViewsWithErrorModel:(ErrorListModel *)errorModel;
@end

NS_ASSUME_NONNULL_END
