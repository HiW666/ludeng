//
//  ListTableViewCell.m
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/19.
//  Copyright © 2019 xjl. All rights reserved.
//

#import "ListTableViewCell.h"
@interface ListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *heartLab;
@property (weak, nonatomic) IBOutlet UILabel *turnBackLab;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumdeLab;

@property (weak, nonatomic) IBOutlet UILabel *change1Lab;
@property (weak, nonatomic) IBOutlet UILabel *change2Lab;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;


@end
@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[Header shareHeader]setCornerWithView:self.stateLab WithCornerRadiu:4.0f WithBorderWith:0 WithBorderColor:nil];
}
-(void)setCustomViewsWithModel:(DeviceModel *)deviceModel{
    self.change1Lab.text = @"心跳时间";
    self.change2Lab.text = @"复位设置";
    
    self.nameLab.text = deviceModel.name?deviceModel.name:@"未知";
    self.heartLab.text = deviceModel.lastHeartBeatTime?deviceModel.lastHeartBeatTime:@"未知";
    self.turnBackLab.text = deviceModel.resetTime?deviceModel.resetTime:@"未知";
    self.deviceNumdeLab.text = deviceModel.number?deviceModel.code:@"未知";
    
    [self setStatusLab:deviceModel.status];
}
-(void)setCustomViewsWithErrorModel:(ErrorListModel *)errorModel{
    self.change1Lab.text = @"触发时间";
    self.change2Lab.text = @"处理时间";
    
    self.nameLab.text = errorModel.deviceName?errorModel.deviceName:@"未知";
    self.heartLab.text = errorModel.createTime?errorModel.createTime:@"未知";
    self.turnBackLab.text = errorModel.dealTime?errorModel.dealTime:@"未知";
    self.deviceNumdeLab.text = errorModel.deviceCode?errorModel.deviceCode:@"未知";
    [self setErrorStatusLab:errorModel.status];
    if(errorModel.deviceName){
        [self setNameLabWithType:errorModel.type];
    }
}
-(void)setStatusLab:(NSInteger)status{
    switch (status) {
        case 0:
            self.stateLab.text = @"正常";
            self.stateLab.backgroundColor = COLOR(91, 168, 104);
            self.deviceImageView.image = [UIImage imageNamed:@"device_green"];
            break;
         case 1:
            self.stateLab.text = @"跳闸";
            self.stateLab.backgroundColor = COLOR(236, 90, 73);
            self.deviceImageView.image = [UIImage imageNamed:@"device_red"];
            break;
            case 2:
            self.stateLab.text = @"离线";
            self.stateLab.backgroundColor = [UIColor lightGrayColor];
            self.deviceImageView.image = [UIImage imageNamed:@"device_gray"];
            break;
        default:
            break;
    }
}
-(void)setErrorStatusLab:(NSInteger)status{
    switch (status) {
        case 0:
            self.stateLab.text = @"未处理";
             self.stateLab.backgroundColor = COLOR(236, 90, 73);
            self.deviceImageView.image = [UIImage imageNamed:@"device_red"];
            break;
         case 1:
            self.stateLab.text = @"处理中";
            self.stateLab.backgroundColor = COLOR(60, 126, 235);
            self.deviceImageView.image = [UIImage imageNamed:@"device_blue"];
            break;
            case 2:
            self.stateLab.text = @"已处理";
            self.stateLab.backgroundColor = COLOR(91, 168, 104);
            self.deviceImageView.image = [UIImage imageNamed:@"device_green"];
            break;
        default:
            break;
    }
}
-(void)setNameLabWithType:(NSInteger)type{
    switch (type) {
        case 1:
            self.nameLab.text = [NSString stringWithFormat:@"%@ - 异常跳闸",self.nameLab.text];
            break;
         case 2:
             self.nameLab.text = [NSString stringWithFormat:@"%@ - 通信断开",self.nameLab.text];
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
