//
//  YHSegmentControl.h
//  YHSegmentView
//
//  Created by Vanha on 2020/7/12.
//

#import <UIKit/UIKit.h>
#import "YHSegmentSetting.h"


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
- (void)yh_scrollViewWillBeginDragging:(UIScrollView *)scrollView;


@end

NS_ASSUME_NONNULL_END
