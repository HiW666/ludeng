//
//  Header.m
//  画板
//
//  Created by 冼嘉良 on 2017/3/21.
//  Copyright © 2017年 冼嘉良. All rights reserved.
//

#import "Header.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "ReplicatorHudView.h"
#import "LoginViewController.h"
#import "JpushService.h"
@interface Header()

@end
@implementation Header
{
    UIAlertController *_alertVC;
}
+(id)shareHeader{
    static Header *header = nil;
    if (header==nil) {
        header = [[Header alloc]init];
    }return header;
}
+(void)requestDataWithURLOfPost:(NSString *)URLStr WithParaDic:(NSDictionary *)paraDic WithSucess:(sucessBlock)sucessBlock WithFail:(failBlock)failBlock{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    sessionManger.securityPolicy.allowInvalidCertificates = YES;
    sessionManger.securityPolicy.validatesDomainName = NO;
    sessionManger.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManger.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    [sessionManger POST:URLStr parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        if(code == -2){
            //登陆过期
            [[Header shareHeader]loginOut];
            return ;
        }
         sucessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorStr = [error localizedDescription];
        failBlock(errorStr);
    }];
    
//    [sessionManger POST:URLStr parameters:paraDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        sucessBlock(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSString *errorStr = [error localizedDescription];
//        failBlock(errorStr);
//    }];
    

}
+(void)requestDataWithURLOfGet:(NSString *)URLStr WithParaDic:(NSDictionary *)paraDic WithSucess:(sucessBlock)sucessBlock WithFail:(failBlock)failBlock{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    [sessionManger GET:URLStr parameters:paraDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucessBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorStr = [error localizedDescription];
        failBlock(errorStr);
    }];
}
+(void)sendImage:(UIImage *)myImage withScaled:(CGFloat)scaled WithURL:(NSString *)URLStr WithSucess:(sucessBlock)sucessBlock WithFail:(failBlock)failBlock{
    //把image  转为data , POST上传只能传data
//    NSData *data = UIImagePNGRepresentation(myImage);
    NSData *data = UIImageJPEGRepresentation(myImage,scaled);
    NSDictionary * body = @{@"category":@"user",@"file":@"HeadImg"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type" ];
    //ContentType设置
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",  @"application/octet-stream", @"text/json", nil];
                                                         

    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLStr parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //上传的参数(上传图片，以文件流的格式)
        /*
         data:图片data
         name:后台接收的字段（流的名字）
         fileName:文件名
         mineType:文件格式
         */
        [formData appendPartWithFileData:data   name:@"uploadFile"  fileName:@"gauge.png"  mimeType:@"image/png"];
       
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    //请求成功的block回调
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        sucessBlock(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failBlock([error localizedDescription]);
        
    }];
}
-(void)writeInfoToLocalWithContent:(NSString *)content WithKey:(NSString *)key{
    NSString *contentPath = [DOCUMENTPATH stringByAppendingString:@"content.plist"];
    if( [[NSFileManager defaultManager] fileExistsAtPath:contentPath]){
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:contentPath];
        [dic setObject:content forKey:key];
        [dic writeToFile:contentPath atomically:YES];
    }else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:content forKey:key];
        [dic writeToFile:contentPath atomically:YES];
    }

}
-(NSString *)getInfoFromLocalWithKey:(NSString *)key{
    NSString *contentPath = [DOCUMENTPATH stringByAppendingString:@"content.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:contentPath]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:contentPath];
        NSString *contentStr = dic[key];
        return contentStr;
    }
    return nil;
}
-(void)removeContentFromLocalWithKey:(NSString *)key{
    NSString *contentPath = [DOCUMENTPATH stringByAppendingString:@"content.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:contentPath]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:contentPath];
        [dic removeObjectForKey:key];
        [dic writeToFile:contentPath atomically:YES];
    }
}
-(void)AddTanAnimationWithView:(UIView *)myViwe{
    CGRect frame = myViwe.frame;
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            //弹起
            myViwe.frame = CGRectMake(frame.origin.x, frame.origin.y-20, frame.size.width, frame.size.height);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
                //下降
                myViwe.frame = frame;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                    //弹起
                    myViwe.frame = CGRectMake(frame.origin.x, frame.origin.y-10, frame.size.width, frame.size.height);
                } completion:^(BOOL finished){
                    //下降
                    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(void){
                        myViwe.frame = frame;
                    } completion:^(BOOL finished){
                    }];
                }];
            }];
        }];
    }];

}

-(void)setCornerWithView:(UIView *)myView WithCornerRadiu:(CGFloat)cornerRadiu WithBorderWith:(CGFloat)borderWidth WithBorderColor:(UIColor *)borderColor{
    myView.layer.masksToBounds=YES;
    myView.layer.cornerRadius = cornerRadiu;
    myView.layer.borderWidth = borderWidth;
    myView.layer.borderColor=borderColor.CGColor;
}

- (CAShapeLayer *)setCornerWithView:(UIView *)view{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = view.bounds;
    layer.path = maskPath.CGPath;
    return layer;
}

- (CAGradientLayer *)setGradientWithView:(UIView*)view StartColor:(UIColor *)startColor EndColor:(UIColor *)endColor{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)startColor.CGColor,
                       (id)endColor.CGColor, nil];
    return gradient;
}

+ (BOOL)valiMobile:(NSString *)mobile{
    
    if (mobile.length != 11)
        
    {
        
        return NO;
        
    }
    
    /**
     
     * 手机号码:
     
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     
     * 电信号段: 133,149,153,170,173,177,180,181,189
     
     */
    
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    
    /**
     
     * 中国移动：China Mobile
     
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     
     */
    
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    
    /**
     
     * 中国联通：China Unicom
     
     * 130,131,132,145,155,156,170,171,175,176,185,186
     
     */
    
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    
    /**
     
     * 中国电信：China Telecom
     
     * 133,149,153,170,173,177,180,181,189
     
     */
    
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        
        || ([regextestcm evaluateWithObject:mobile] == YES)
        
        || ([regextestct evaluateWithObject:mobile] == YES)
        
        || ([regextestcu evaluateWithObject:mobile] == YES))
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
}
-(UIImageView *)addGIfImageViewWithFileName:(NSString *)fileName{
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"gif"]; //加载GIF图片
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);           //将GIF图片转换成对应的图片源
    size_t frameCout = CGImageSourceGetCount(gifSource);                                         //获取其中图片源个数，即由多少帧图片组成
    NSMutableArray *frames = [[NSMutableArray alloc] init];                                      //定义数组存储拆分出来的图片
    for (size_t i = 0; i < frameCout; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL); //从GIF图片中取出源图片
        UIImage *imageName = [UIImage imageWithCGImage:imageRef];                  //将图片源转换成UIimageView能使用的图片源
        [frames addObject:imageName];                                              //将图片加入数组中
        CGImageRelease(imageRef);
    }
    UIImageView *gifImageView = [[UIImageView alloc] init];
    gifImageView.animationImages = frames; //将图片数组加入UIImageView动画数组中
    //    gifImageView.animationDuration = 1.5; //每次动画时长
    [gifImageView startAnimating];         //开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
  
    return gifImageView;
}
-(void)setShadowWithView:(UIView *)shadowView WithShadowRadiu:(CGFloat)shadowRadiu WithShadowOpacity:(CGFloat)shadowOpacity WithShadowColor:(UIColor *)shadowColor WithShadowOffset:(CGSize)size{
    
        shadowView.layer.shadowColor = shadowColor.CGColor;
        shadowView.layer.shadowRadius = shadowRadiu;
        shadowView.layer.shadowOpacity = shadowOpacity;
        shadowView.layer.shadowOffset = size;
//        shadowView.layer.cornerRadius = 4.0f;
        shadowView.layer.masksToBounds = NO;
}
-(void)showAlertWithTiTle:(NSString *)title WithController:(UIViewController *)controller{
    _alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [controller presentViewController:_alertVC animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(creatAlert:) userInfo:_alertVC repeats:NO];
    
    
}
- (void)creatAlert:(NSTimer *)timer{
    
    UIAlertController *alert = [timer userInfo];
    
    [alert dismissViewControllerAnimated:YES completion:nil];
    
    alert = nil;
    
    
    
}

-(NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString{
    
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
    return [weekArray objectAtIndex:0];
}

-(void)addAlertViewWith:(UIView *)superView WithAlertView:(UIView *)alertView{
    UIView *blackView = [[UIView alloc]initWithFrame:superView.frame];
    blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [superView addSubview:blackView];
    
    alertView.center = CGPointMake(SCRW/2, SCRH*0.45);
    [[Header shareHeader] AddTanAnimationWithView:alertView];;
    [blackView addSubview:alertView];
    
    
}
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    // 截止时间data格式
    NSDate *endDate = [dateFomatter dateFromString:endTime];
    // 当前时间data格式
    NSDate *startDate = [dateFomatter dateFromString:startTime];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
//    NSString *str = @(dateCom.minute+dateCom.hour*60+dateCom.day*24*60).stringValue;
    NSString *str = @(dateCom.minute*60+dateCom.hour*3600+dateCom.day*24*3600+dateCom.second).stringValue;
    return str;
}
-(NSString *)secondBetweenStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    // 截止时间data格式
    NSDate *endDate = [dateFomatter dateFromString:endTime];
    // 当前时间data格式
    NSDate *startDate = [dateFomatter dateFromString:startTime];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    NSString *str = @(dateCom.second+dateCom.minute*60+dateCom.hour*60*60+dateCom.day*24*60*60).stringValue;
    
    return str;
}
-(NSString *)getDateWithStartDate:(NSDate *)startDate WithSeconds:(NSInteger)second{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [NSDate dateWithTimeInterval:second sinceDate:startDate];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

-(NSString *)getDateStrWithTimeStampString:(NSString *)timeStampString{
    NSTimeInterval interval  = [timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString  = [formatter stringFromDate: date];
    return dateString;
}

+ (NSMutableAttributedString *)setSpaceWithContentStr:(NSString *)contentStr WithSpace:(CGFloat)Space{
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:Space];
    NSMutableAttributedString *setString = [[NSMutableAttributedString alloc]initWithString:contentStr];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    return setString;
}
+(NSString *)changeToDateStrWith:(NSString *)cuoStr WithFormatterStr:(NSString *)formatterStr{
    
    NSString *timeStampString  = cuoStr;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString *dateString  = [formatter stringFromDate: date];
    return dateString;
}
//获取Window当前显示的ViewController
- (UIViewController*)getCurrentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
-(void)showToastWithTitle:(NSString *)title{
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    UIViewController *vc = [self getCurrentViewController];
    UILabel *toastLab =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width+30, 40)];
    toastLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    toastLab.text = title;
    toastLab.textAlignment = 1;
    toastLab.textColor = [UIColor whiteColor];
    toastLab.font = [UIFont systemFontOfSize:15];
    toastLab.center = CGPointMake(SCRW/2, SCRH/2);
    [self setCornerWithView:toastLab WithCornerRadiu:5.0 WithBorderWith:0 WithBorderColor:nil];
    [vc.view addSubview: toastLab];
    [self showAnimation:toastLab WithState:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismissToast:) userInfo:toastLab repeats:NO];
}
-(void)dismissToast:(NSTimer *)timer{
    UILabel *toastLab = [timer userInfo];
    [self showAnimation:toastLab WithState:NO];
    [timer invalidate];
    timer = nil;
}
- (void)showAnimation:(UIView *) animationView WithState:(BOOL)isOpen{
    
    CGFloat offsetX =  10;
    CGFloat offsetY =  10;
    
    if (isOpen == YES) {
        // 动画由小变大
        animationView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, offsetX, offsetY);
        [UIView animateWithDuration:0.3f animations:^{
            animationView.alpha = 1.0f;
            animationView.transform = CGAffineTransformMake(1.05f, 0, 0, 1.0f, 0, 0);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f animations:^{
                animationView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
            } completion:^(BOOL finished) {
                //  恢复原位
                animationView.transform = CGAffineTransformIdentity;
            }];
        }];
        
    } else {
        // 动画由大变小
        animationView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
        [UIView animateWithDuration:0.2 animations:^{
            animationView.transform = CGAffineTransformMake(0.01, 0, 0, 0.01, offsetX, offsetY);
        } completion:^(BOOL finished) {
            animationView.transform = CGAffineTransformIdentity;
            animationView.alpha = 0.0f;
            [animationView removeFromSuperview];
        }];
    }
    
}
-(UIView *)loadingView:(UIView *)superView{
    ReplicatorHudView *hudView = [[ReplicatorHudView alloc] initWithCGRect:CGRectMake(0, 0, 50, 50) color:[UIColor lightGrayColor]];
    hudView.center = CGPointMake(SCRW/2, SCRH/2);
    hudView.durTime = 1;
    hudView.needGradient = YES;
    [superView addSubview:hudView];
    return hudView;
}
-(void)loginOut{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的登陆已过期，请重新登陆" preferredStyle:UIAlertControllerStyleAlert];
    UIViewController *currentVC = [[Header shareHeader]getCurrentViewController];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        for (UIViewController *vc in currentVC.navigationController.viewControllers) {
            if([vc isKindOfClass:[LoginViewController class]]){
                [currentVC.navigationController popToViewController:vc animated:YES];
                [USER_DEFAULT setObject:@"" forKey:@"password"];
                [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    NSLog(@"删除别名");
                } seq:520];
                break;
            }
        }
    }];
    [alertVC addAction:sureAction];
    [currentVC presentViewController:alertVC animated:YES completion:nil];
}

@end
