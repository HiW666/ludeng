//
//  TabBarView.m
//  StreetLampsManager
//
//  Created by 冼嘉良 on 2019/9/24.
//  Copyright © 2019 xjl. All rights reserved.
//

#import "TabBarView.h"
@interface TabBarView ()
@property (nonatomic,strong) UIButton *keepBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceListBtn;
@end
@implementation TabBarView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.deviceListBtn.selected = YES;
    self.keepBtn = self.deviceListBtn;
}
- (IBAction)clickTab:(UIButton *)sender {
    self.keepBtn.selected = NO;
    sender.selected = YES;
    self.keepBtn = sender;
    self.selectedIndex(sender.tag -100);
}


@end
