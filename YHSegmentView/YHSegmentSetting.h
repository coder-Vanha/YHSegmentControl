//
//  YHSegmentSetting.h
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 万叶华. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BBUISlideMenuItemType)
{
    BBUISlideMenuItemTypeText = 0,     // 文本
    BBUISlideMenuItemTypeImage         // 图片
};

@interface YHSegmentItmeModel : NSObject

@property (nonatomic, assign)   BBUISlideMenuItemType  ItemType;
@property (nonatomic, copy)     NSString    * title;
@property (nonatomic, strong)   UIImage     * image;
@property (nonatomic, copy)     NSString    * imageURL;
@property (nonatomic, copy)     NSString    * imageWidth;
@property (nonatomic, copy)     NSString    * imageHeight;

@property (nonatomic, assign)   BOOL        showBadge;
@property (nonatomic, strong)   UIColor     * badgeDotColor;
@property (nonatomic, assign)   CGSize      dotSize;
@property (nonatomic, copy)     NSString    * badgeURL;

@property (nonatomic, assign)   UIEdgeInsets   itemInsets;
@property (nonatomic, assign)   CGSize      itemSize;
//@property (nonatomic, strong)   UIFont      * font;
//@property (nonatomic, strong)   UIColor     * titleColor;

@property (nonatomic, copy)   NSAttributedString  * titleNormalAttributedStri;
@property (nonatomic, copy)   NSAttributedString  * titleSelectedAttributedStri;
//@property (nonatomic, strong) UIFont    * titleNormalFont;
//@property (nonatomic, strong) UIFont    * titleSelectFont;
//@property (nonatomic, strong) UIColor   * titleNormalColor;
//@property (nonatomic, strong) UIColor   * titleSelectColor;

+ (YHSegmentItmeModel *)itemWithTitle:(NSString *)title;
+ (YHSegmentItmeModel *)itemWithImage:(UIImage *)image;
+ (YHSegmentItmeModel *)itemWithImageURL:(NSString *)imageURL;
+ (NSArray<YHSegmentItmeModel *> *)itemsWithTitles:(NSArray<NSString *> *) titles;

//+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;

+ (NSAttributedString *)attributedStringWithString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;


+ (YHSegmentItmeModel *)itmeModelWithTitle:(NSString *)title normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont height:(CGFloat)height insets:(UIEdgeInsets)insets;

@end

@interface YHSegmentSetting : NSObject

// for menuView
@property (nonatomic, assign) CGFloat   MenuViewWidth;

@property (nonatomic, strong) UIColor   * backgroundNormalColor;
@property (nonatomic, strong) UIColor   * backgroundTopColor;


@property (nonatomic, strong) UIColor   * titleNormalColor;
@property (nonatomic, strong) UIColor   * titleSelectColor;


// for item


// for indicator

@property (nonatomic, assign) BOOL      hiddenindicator;
@property (nonatomic, assign) CGSize    indicatorSize;
@property (nonatomic, assign) CGFloat   indicatorTop;
@property (nonatomic, strong) UIColor   * indicatorBgColor;

@property CGPoint indicatorStartPoint;
@property CGPoint indicatorEndPoint;
@property(nullable, copy) NSArray<NSNumber *> * indicatorLocations;
@property(nullable, copy) NSArray *indicatorColors;



@property (nonatomic, strong) UIFont    * titleNormalFont;
@property (nonatomic, strong) UIFont    * titleSelectFont;

@property (nonatomic, assign) CGFloat   BaseScale;
@property (nonatomic, assign) CGFloat   MaxZoomScale;

@property (nonatomic, assign) CGFloat     imageNormalWidth;
@property (nonatomic, assign) CGFloat     imageMaxWidth;


+ (YHSegmentSetting *)defaultSetting;

@end


NS_ASSUME_NONNULL_END
