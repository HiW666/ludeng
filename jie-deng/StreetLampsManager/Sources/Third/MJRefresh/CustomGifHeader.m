//
//  CustomGifHeader.m
//  CustomGifRefresh
//
//  Created by WXQ on 2018/8/20.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#import "CustomGifHeader.h"

@implementation CustomGifHeader

#pragma mark - 实现父类的方法
- (void)prepare {
    [super prepare];
    //GIF数据
    NSArray * idleImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:59];
    NSArray * refreshingImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:59];
    //普通状态
    [self setImages:idleImages forState:MJRefreshStateIdle];
    //即将刷新状态
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    //正在刷新状态
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    
    
}
- (void)placeSubviews {
    [super placeSubviews];
    //隐藏状态显示文字
    self.stateLabel.hidden = YES;
    //隐藏更新时间文字
    self.lastUpdatedTimeLabel.hidden = YES;
}

#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    NSMutableArray * imageArray = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%zd.png",i]];
        if (image) {
            [imageArray addObject:image];
        }
    }
    return imageArray;
}
- (NSArray *)getImageFromGifResource:(NSString *)resource {
    NSMutableArray *imageArray = [NSMutableArray array];
    
    // 获取gif url
    NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"gif"];
    // 转换为图片源
    CGImageSourceRef gifImageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, nil);
    // 获取图片个数
    size_t framesCount = CGImageSourceGetCount(gifImageSourceRef);
    for (size_t i=0; i<framesCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifImageSourceRef, i, nil);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArray addObject:image];
        
        CFRelease(imageRef);
    }
    
    return imageArray;
}


@end
