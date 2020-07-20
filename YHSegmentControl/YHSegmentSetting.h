//
//  YHSegmentSetting.h
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 万叶华. All rights reserved.
//


#import <UIKit/UIKit.h>
@class YHSegmentSetting;
NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger , YHIndictorStyle) {
    YHIndictorStyleLeap           =  1 << 0, // 给定宽度，跳跃滑动
    YHIndictorStyleAlignToTitle   =  1 << 1, // 宽度与文字平齐，自然滑动
    YHIndictorStyleNature         =  1 << 2, // 给定宽度， 自然滑动
};

typedef NS_ENUM(NSInteger , YHItemContentType) {
    YHItemContentTypeText         =  1 << 0, // 纯文字
    YHItemContentTypeImageText    =  1 << 1, // 图文
};

@interface YHSegmentItmeModel : NSObject

@property (nonatomic, copy)     NSString    * title;

@property (nonatomic, strong)   UIImage     * image;
@property (nonatomic, copy)     NSString    * imageURL;
@property (nonatomic, strong)   UIImage     * selectedImage;
@property (nonatomic, copy)     NSString    * selectedImageURL;

@property (nonatomic, assign)   BOOL          showBadge;
@property (nonatomic, strong)   UIColor     * badgeDotColor;
@property (nonatomic, assign)   CGSize        badgeSize;
@property (nonatomic, assign)   UIEdgeInsets  badgeInsets;
@property (nonatomic, copy)     NSString    * badgeURL;

@property (nonatomic, assign)   CGSize      itemSize;


+ (NSArray<YHSegmentItmeModel *> *)itemsWithTitles:(NSArray<NSString *> *) titles  setting:(YHSegmentSetting *)setting;

+ (YHSegmentItmeModel *)itmeModelWithTitle:(NSString *)title setting:(YHSegmentSetting *)setting;

+ (YHSegmentItmeModel *)itmeModelWithTitle:(NSString *)title selectedImage:(UIImage *)selectedImage itemSize:(CGSize)itemSize setting:(YHSegmentSetting *)setting;

+ (YHSegmentItmeModel *)itmeModelWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage itemSize:(CGSize)itemSize setting:(YHSegmentSetting *)setting;

+ (YHSegmentItmeModel *)itmeModelWithImageURL:(NSString *)imageURL selectedImageURL:(NSString *)selectedImageURL itemSize:(CGSize)itemSize setting:(YHSegmentSetting *)setting;


@end

@interface YHSegmentSetting : NSObject

// for menuView
@property (nonatomic, strong) UIColor   * backgroundColor;
// require a value to caculate text itemSize
@property (nonatomic, assign) CGFloat     menuHeight;

// for item
@property (nonatomic, assign) UIEdgeInsets   itemInsets;
@property (nonatomic, assign) YHItemContentType  itemContentType;
@property (nonatomic, strong) UIColor   * titleNormalColor;
@property (nonatomic, strong) UIColor   * titleSelectColor;
@property (nonatomic, strong) UIFont    * titleNormalFont;
@property (nonatomic, strong) UIFont    * titleSelectFont;

@property (nonatomic, assign) CGFloat   BaseScale;
@property (nonatomic, assign) CGFloat   MaxZoomScale;

@property (nonatomic, assign) CGFloat     imageNormalWidth;
@property (nonatomic, assign) CGFloat     imageMaxWidth;

// for indicator
@property (nonatomic, assign) YHIndictorStyle    indicatorStyle;
@property (nonatomic, assign) BOOL      hiddenindicator;
@property (nonatomic, assign) CGSize    indicatorSize;
@property (nonatomic, assign) CGFloat   indicatorTop;
@property (nonatomic, strong) UIColor   * indicatorBgColor;

@property CGPoint indicatorStartPoint;
@property CGPoint indicatorEndPoint;
@property(nullable, copy) NSArray<NSNumber *> * indicatorLocations;
@property(nullable, copy) NSArray *indicatorColors;


+ (YHSegmentSetting *)defaultSetting;

@end


NS_ASSUME_NONNULL_END
