//
//  YHSegmentView.h
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 万叶华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHSegmentSetting.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YHSegmentViewDelegate<NSObject>

@required

- (void)bbui_menuViewDidMoveToIndex:(NSInteger)index;    // 用户点击到另外的title， 业务去做ScrollView scrolltoOffset，menuView不做其他处理
@optional
- (void)bbui_menuViewScrollingRatio:(CGFloat)ratio currentSelectIndex:(NSInteger)currentSelectIndex;

@end


@interface YHSegmentView : UIView

// 纯文本
+ (YHSegmentView *) menuViewWithTitles:(NSArray<NSString *> *)titles
                                  setting:(YHSegmentSetting *)setting
                       currentSelectIndex:(NSInteger)index
                           pageScrollView:(UIScrollView *)pageScrollView
                                 delegate:(id<YHSegmentViewDelegate>)delegate;


// 支持图片
+ (YHSegmentView *) menuViewWithModels:(NSArray<YHSegmentItmeModel *> *)models
                                 setting:(YHSegmentSetting *)setting
                      currentSelectIndex:(NSInteger)index
                          pageScrollView:(UIScrollView *)pageScrollView
                                delegate:(id<YHSegmentViewDelegate>)delegate;

+ (CGFloat)heightOfMenuView;

- (void)setSlideMenuViewWidth:(CGFloat)menuWidth;


@property (nonatomic, weak) id<YHSegmentViewDelegate> delegate;
@property (nonatomic, weak) UIScrollView               * recognizeSimultaneouslyScrollView;


- (void)refreshWithTitles:(NSArray<NSString *> *)titles currentSelectIndex:(NSInteger)index;
- (void)refreshWithModels:(NSArray<YHSegmentItmeModel *> *)models currentSelectIndex:(NSInteger)index;
- (void)refreshSetting:(YHSegmentSetting *)setting;

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setShowTypeIsTop:(BOOL)isTop;
/** 是否显示底部阴影 */
- (void)showBottomLayerShadow:(BOOL)isShow;

//-- 小红点
- (void)showRedTipWithIndex:(NSInteger)index;
- (void)hideRedTipWithIndex:(NSInteger)index;
- (void)hideAllRedTips;

- (UIView *)getTabViewWithIndex:(NSInteger)index;

- (void)bbui_scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)bbui_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
