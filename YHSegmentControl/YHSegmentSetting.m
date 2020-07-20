//
//  YHSegmentSetting.m
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 万叶华. All rights reserved.
//

#import "YHSegmentSetting.h"
#import "SDWebImageDownloader.h"

@implementation YHSegmentItmeModel

+ (NSArray<YHSegmentItmeModel *> *)itemsWithTitles:(NSArray<NSString *> *)titles setting:(YHSegmentSetting *)setting {
    NSMutableArray *array;
    if (titles.count > 0) {
        array = [NSMutableArray array];
        for (NSInteger i=0; i<titles.count; i++){
            YHSegmentItmeModel *item = [self itmeModelWithTitle:titles[i] setting:setting];
            [array addObject: item];
        }
    }
    
    return array;
    
}

+ (YHSegmentItmeModel *)itmeModelWithTitle:(NSString *)title setting:(YHSegmentSetting *)setting {
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.badgeDotColor = [UIColor redColor];
    item.title = title;
  
    if (title.length > 0 && setting.titleNormalColor && setting.titleSelectColor && setting.titleNormalFont && setting.titleSelectFont) {
        
        CGSize titleSize = CGSizeZero;
        titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, setting.menuHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : setting.titleSelectFont} context:nil].size;
        
        if (titleSize.width > 0) {
            item.itemSize = CGSizeMake(titleSize.width + setting.itemInsets.left + setting.itemInsets.right, setting.menuHeight + setting.itemInsets.top + setting.itemInsets.bottom);
        }
    }
    
    return item;
}

+ (YHSegmentItmeModel *)itmeModelWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage itemSize:(CGSize)itemSize setting:(YHSegmentSetting *)setting {
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.badgeDotColor = [UIColor redColor];
    itemSize = itemSize;
    item.image = image;
    item.selectedImage = selectedImage;
    return item;
}

+ (YHSegmentItmeModel *)itmeModelWithImageURL:(NSString *)imageURL selectedImageURL:(NSString *)selectedImageURL itemSize:(CGSize)itemSize setting:(YHSegmentSetting *)setting {
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.badgeDotColor = [UIColor redColor];
    itemSize = itemSize;
    
    __weak __typeof (item) weakObjc = item;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageURL] options:SDWebImageDownloaderContinueInBackground  progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        __strong __typeof (weakObjc) strongObjc = weakObjc;
        if (!error && image && finished)
        {
            strongObjc.image = image;
        }
    }];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:selectedImageURL] options:SDWebImageDownloaderContinueInBackground  progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        __strong __typeof (weakObjc) strongObjc = weakObjc;
        if (!error && image && finished)
        {
            strongObjc.selectedImage = image;
        }
    }];
    
    return item;
}


+(YHSegmentItmeModel *)itmeModelWithTitle:(NSString *)title selectedImage:(UIImage *)selectedImage itemSize:(CGSize)itemSize setting:(YHSegmentSetting *)setting {
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.badgeDotColor = [UIColor redColor];
    itemSize = itemSize;
    item.title = title;
    item.selectedImage = selectedImage;
    return item;
}

@end


@implementation YHSegmentSetting

+ (YHSegmentSetting *)defaultSetting
{
    YHSegmentSetting *setting = [YHSegmentSetting new];
     setting.backgroundColor = [UIColor whiteColor];
    
    setting.itemContentType = YHItemContentTypeText;
    setting.menuHeight = 44;
    
    setting.titleNormalColor = [UIColor blackColor];
    setting.titleSelectColor = [UIColor orangeColor];
    
    setting.indicatorStyle = YHIndictorStyleAlignToTitle;
    setting.indicatorBgColor = [UIColor blackColor];
    setting.indicatorStartPoint = CGPointMake(0, 0.5);
    setting.indicatorEndPoint = CGPointMake(1, 0.5);
    setting.indicatorLocations = @[@(0.0f), @(1.0f)];
    setting.indicatorColors = @[(__bridge id)[UIColor orangeColor].CGColor,
                     (__bridge id)[UIColor redColor].CGColor];
    
    setting.indicatorTop = 35;
    setting.indicatorSize = CGSizeMake(14, 4);
 
    setting.titleNormalFont =  [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    setting.titleSelectFont = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    
    setting.BaseScale = 16.0/18.0;
    setting.MaxZoomScale = 18.0/16.0;

    setting.imageNormalWidth = 58;
    setting.imageMaxWidth = 58*1.1;
    
    return setting;
}



@end
