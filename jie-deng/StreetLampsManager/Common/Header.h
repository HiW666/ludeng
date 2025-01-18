//
//  Header.h
//  画板
//
//  Created by 冼嘉良 on 2017/3/21.
//  Copyright © 2017年 冼嘉良. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//缓存路径
#define DOCUMENTPATH  [NSHomeDirectory() stringByAppendingString:@"/Documents/"]
typedef void(^sucessBlock) (id result);
typedef void(^failBlock) (NSString *errorStr);
@interface Header : NSObject
//post请求数据(AFN)，改为用HttpUtils的请求方法
+(void)requestDataWithURLOfPost:(NSString *)URLStr WithParaDic:(NSDictionary *)paraDic WithSucess:(sucessBlock)sucessBlock WithFail:(failBlock)failBlock;
+(void)requestDataWithURLOfGet:(NSString *)URLStr WithParaDic:(NSDictionary *)paraDic WithSucess:(sucessBlock)sucessBlock WithFail:(failBlock)failBlock;
//post请求数据(AFN)
//上传文件(AFN)
+(void)sendImage:(UIImage *)myImage withScaled:(CGFloat)scaled WithURL:(NSString *)URLStr WithSucess:(sucessBlock)sucessBlock WithFail:(failBlock)failBlock;
//单例
+(id)shareHeader;
//判断输入是否为电话号码
+(BOOL)valiMobile:(NSString *)mobile;
//json格式字符串转字典
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString ;
//写入本地缓存(plist)
-(void)writeInfoToLocalWithContent:(NSString *)content WithKey:(NSString *)key;
//获取本地缓存(plist)
-(NSString *)getInfoFromLocalWithKey:(NSString *)key;
//删除缓存内容
-(void)removeContentFromLocalWithKey:(NSString *)key;
//弹动效果
-(void)AddTanAnimationWithView:(UIView *)myViwe;

//视图圆角·边框·属性设置
-(void)setCornerWithView:(UIView *)myView WithCornerRadiu:(CGFloat)cornerRadiu WithBorderWith:(CGFloat)borderWidth WithBorderColor:(UIColor *)borderColor;
//只设置底边圆角
- (CAShapeLayer *)setCornerWithView:(UIView *)view;
//加载播放gif动画
-(UIImageView *)addGIfImageViewWithFileName:(NSString *)fileName;
//设置阴影
-(void)setShadowWithView:(UIView *)shadowView WithShadowRadiu:(CGFloat)shadowRadiu WithShadowOpacity:(CGFloat)shadowOpacity WithShadowColor:(UIColor *)shadowColor WithShadowOffset:(CGSize)size;
//提示框
-(void)showAlertWithTiTle:(NSString *)title WithController:(UIViewController *)controller;
//根据日期返回星期几
-(NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString;
//添加UI设计提示框
-(void)addAlertViewWith:(UIView *)superView WithAlertView:(UIView *)alertView;
//计算两个时间差（s）
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
//计算两个时间差(sec)
-(NSString *)secondBetweenStartTime:(NSString *)startTime endTime:(NSString *)endTime;
//计算想要的时间日期
-(NSString *)getDateWithStartDate:(NSDate *)startDate WithSeconds:(NSInteger)second;
//时间戳转时间
-(NSString *)getDateStrWithTimeStampString:(NSString *)timeStampString;
//设置字体行间距
+ (NSMutableAttributedString *)setSpaceWithContentStr:(NSString *)contentStr WithSpace:(CGFloat)Space;
//时间戳转时间
+(NSString *)changeToDateStrWith:(NSString *)cuoStr WithFormatterStr:(NSString *)formatterStr;
//获取当前控制器
- (UIViewController*)getCurrentViewController;
//设置View的渐变色
- (CAGradientLayer *)setGradientWithView:(UIView*)view StartColor:(UIColor *)startColor EndColor:(UIColor *)endColor;
//提示框
-(void)showToastWithTitle:(NSString *)title;
//网络加载动画
-(UIView *)loadingView:(UIView *)superView;
//退出登录
-(void)loginOut;
@end
