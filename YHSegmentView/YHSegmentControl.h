//
//  YHSegmentControl.h
//  YHSegmentView
//
//  Created by Vanha on 2020/7/12.
//

#import <UIKit/UIKit.h>
#import "YHSegmentSetting.h"

typedef NS_ENUM(NSInteger , YHIndictorStyle) {
    YHIndictorStyleDefault        =  1 << 0, // 给定宽度，跳跃滑动
    YHIndictorStyleAlignToTitle   =  1 << 1, // 宽度与文字平齐，自然滑动
    YHIndictorStyleNature         =  1 << 2, // 给定宽度， 自然滑动
};

typedef NS_ENUM(NSInteger , YHItemStyle) {
    YHItemStyleDefault            =  1 << 0, // 直接切换文字
    YHItemStyleSmoothness         =  1 << 1, // 渐变切换文字
};

typedef NS_ENUM(NSInteger , YHItemContentType) {
    YHItemContentTypeText         =  1 << 0, // 纯文字
    YHItemContentTypeImageText    =  1 << 1, // 图文
};

NS_ASSUME_NONNULL_BEGIN

@protocol YHSegmentControlDelegate<NSObject>

@required
- (void)yh_segmentControlItemDidSelectedIndex:(NSInteger)index;   

@end

@interface YHSegmentControl : UIControl

+ (YHSegmentControl *)yh_segmentControlWithModels:(NSArray<YHSegmentItmeModel *> *)models
           setting:(YHSegmentSetting *)setting
currentSelectIndex:(NSInteger)index
    pageScrollView:(UIScrollView *)pageScrollView
          delegate:(id<YHSegmentControlDelegate>)delegate;

- (void)yh_reloadDataWithSetting:(YHSegmentSetting *)setting models:(NSArray<YHSegmentItmeModel *> *)models;
- (void)yh_reloadDataWithModels:(NSArray<YHSegmentItmeModel *> *)models;
- (void)yh_setDefaultSelectedIndex:(NSInteger)index models:(NSArray<YHSegmentItmeModel *> *)models;

// By call this method to achieve linkage effect
- (void)yh_scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)yh_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;


@end

NS_ASSUME_NONNULL_END
