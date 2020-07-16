//
//  YHSegmentItem.h
//  YHSegmentView
//
//  Created by Vanha on 2020/7/12.
//

#import <UIKit/UIKit.h>
@class YHSegmentSetting;
@class YHSegmentItmeModel;

typedef NS_ENUM(NSInteger ,YHSegmentItemStatus){
    YHSegmentItemStatusNormal        = 1 << 0,
    YHSegmentItemStatusSelected      = 1 << 1
};

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const kYHSegmentItemCellID;

@interface YHSegmentItem : UICollectionViewCell

- (void)yh_refreshDataWithModel:(id)model setting:(YHSegmentSetting *)setting;

- (void)yh_setAnimationWithItemStatus:(YHSegmentItemStatus)status absRatio:(CGFloat)absRatio transScale:(CGFloat)transScale;

- (void)yh_changeTitleColorFromColor:(UIColor*)fromColor toColor:(UIColor*)toColor percent:(CGFloat)percent;


@end

NS_ASSUME_NONNULL_END
