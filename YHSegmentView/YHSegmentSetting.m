//
//  YHSegmentSetting.m
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/8.
//  Copyright © 2020 万叶华. All rights reserved.
//

#import "YHSegmentSetting.h"
#import "SDWebImageDownloader.h"
#import "YHSegmentViewConstant.h"

@implementation YHSegmentItmeModel

+ (YHSegmentItmeModel *)itemWithTitle:(NSString *)title
{
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.ItemType = BBUISlideMenuItemTypeText;
    item.title = title;
    item.badgeDotColor = [UIColor redColor];
    return item;
}

+ (YHSegmentItmeModel *)itemWithImage:(UIImage *)image
{
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.ItemType = BBUISlideMenuItemTypeImage;
    item.image = image;
    item.badgeDotColor = [UIColor redColor];
    return item;
}

+ (YHSegmentItmeModel *)itemWithImageURL:(NSString *)imageURL
{
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.ItemType = BBUISlideMenuItemTypeImage;
    item.imageURL = imageURL;
    item.badgeDotColor = [UIColor redColor];
    [item loadWebImage];
    return item;
}

+ (NSArray<YHSegmentItmeModel *> *)itemsWithTitles:(NSArray<NSString *> *) titles
{
    NSMutableArray *array;
    if (titles.count > 0)
    {
        array = [NSMutableArray array];
        for (NSInteger i=0; i<titles.count; i++)
        {
            YHSegmentItmeModel *item = [YHSegmentItmeModel new];
            item.ItemType = BBUISlideMenuItemTypeText;
            item.title = [titles objectAtIndex:i];
            item.badgeDotColor = [UIColor redColor];
            [array addObject: item];
        }
    }

    return array;
}

- (void)loadWebImage
{
    if (!self.image)
    {
        __weak __typeof (self) weakSelf = self;
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.imageURL] options:SDWebImageDownloaderContinueInBackground  progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            __strong __typeof (weakSelf) strongSelf = weakSelf;
            if (!error && image && finished)
            {
                strongSelf.image = image;
            }
        }];
        
        
    }
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height {
    CGSize size = CGSizeZero;
    
    if (string.length > 0 && font) {
        size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSAttachmentAttributeName : font} context:nil].size;
    }
    
    return size;
    
}


+ (YHSegmentItmeModel *)itmeModelWithTitle:(NSString *)title normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont height:(CGFloat)height insets:(UIEdgeInsets)insets{
    YHSegmentItmeModel *item = [YHSegmentItmeModel new];
    item.ItemType = BBUISlideMenuItemTypeText;
    item.badgeDotColor = [UIColor redColor];
    item.title = title;
    [item loadWebImage];
    
    if (title.length > 0 && normalColor && selectedColor && normalFont && selectedFont) {
        NSMutableAttributedString *normalAttri = [[NSMutableAttributedString alloc] initWithString:title];
        [normalAttri addAttributes:@{NSForegroundColorAttributeName : normalColor, NSFontAttributeName : normalFont} range:NSMakeRange(0, title.length)];
        
        NSMutableAttributedString *selectedAttri = [[NSMutableAttributedString alloc] initWithString:title];
        [selectedAttri addAttributes:@{NSForegroundColorAttributeName : selectedColor, NSFontAttributeName : selectedFont} range:NSMakeRange(0, title.length)];
        
        item.titleNormalAttributedStri = normalAttri;
        item.titleSelectedAttributedStri = selectedAttri;
        
        CGSize titleSize = CGSizeZero;
        titleSize = [selectedAttri boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        if (titleSize.width > 0) {
             item.itemSize = CGSizeMake(titleSize.width + insets.left + insets.right, height + insets.top + insets.bottom);
        }
    }
    
    return item;
}

@end


@implementation YHSegmentSetting

+ (YHSegmentSetting *)defaultSetting
{
    YHSegmentSetting *setting = [YHSegmentSetting new];
    
    setting.MenuViewWidth = [UIScreen mainScreen].bounds.size.width;
   
    setting.titleNormalColor = YH_RGBA(135,138,153,1);
    setting.titleSelectColor = YH_RGBA(34,34,34,1);
    
    setting.indicatorBgColor = [UIColor blackColor];
    setting.indicatorStartPoint = CGPointMake(0, 0.5);
    setting.indicatorEndPoint = CGPointMake(1, 0.5);
    setting.indicatorLocations = @[@(0.0f), @(1.0f)];
    setting.indicatorColors = @[(__bridge id)YH_RGBA(255, 151, 135, 1).CGColor,
                     (__bridge id)YH_RGBA(255, 128, 112, 1).CGColor];
    
    setting.indicatorTop = 35;
    setting.indicatorSize = CGSizeMake(14, 4);
 
    setting.backgroundNormalColor = YH_RGBA(255,255,255,1);
    setting.backgroundTopColor = YH_RGBA(255,255,255,1);

    setting.titleNormalFont =  [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    setting.titleSelectFont = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    
    setting.BaseScale = 16.0/18.0;
    setting.MaxZoomScale = 18.0/16.0;

    setting.imageNormalWidth = 58;
    setting.imageMaxWidth = 58*1.1;
    
    return setting;
}


@end
