//
//  YHMainTabController.m
//  YHSegmentViewDemo
//
//  Created by wanyehua on 2018/7/1.
//  Copyright © 2018年 万叶华. All rights reserved.
//

#import "YHMainTabController.h"
#import "YHSubViewController.h"

@interface YHMainTabController ()
@property (nonatomic, copy) NSArray <NSString *>*titleArr;
@end

@implementation YHMainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YHSegmentView";

    self.titleArr = @[@"Text + SlidingLeap 文本 + 跳跃滑动",
                      @"Text + SlidingAlign 文本 + 宽度与文字平齐",
                      @"Text + SlidingNature 文本 + 自然滑动",
                      @"Image&Text + SlidingLeap 图文+ 跳跃滑动",
                      @"Image&Text + SlidingNature 图文+ 自然滑动",
                      @"Tips + SlidingNature 图文+ 自然滑动"
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titleArr[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YHSegmentSetting *setting = [YHSegmentSetting defaultSetting];
    setting.itemInsets = UIEdgeInsetsMake(0, 8, 0, 8);
//    setting.titleNormalColor = YH_RGB(111,111,111);
//    setting.titleSelectColor = YH_RGB(0,0,0);
//    setting.backgroundNormalColor = YH_RGB(247,247,247);
    setting.titleNormalFont =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    setting.titleSelectFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    setting.imageNormalWidth = 64.0 * 0.95;
    setting.imageMaxWidth = 64;
    
    switch (indexPath.row) {
        case 0:
        {
            setting.itemContentType = YHItemContentTypeText;
            setting.indicatorStyle =  YHIndictorStyleLeap;
        }
            break;
        case 1:
        {
            setting.itemContentType = YHItemContentTypeText;
            setting.indicatorStyle =  YHIndictorStyleAlignToTitle;
        }
            break;
        case 2:
        {
            setting.itemContentType = YHItemContentTypeText;
            setting.indicatorStyle =  YHIndictorStyleNature;
        }
            break;
        case 3:
        {
            setting.itemContentType = YHItemContentTypeImageText;
            setting.indicatorStyle =  YHIndictorStyleLeap;
        }
            break;
        case 4:
        {
            setting.itemContentType = YHItemContentTypeImageText;
            setting.indicatorStyle =  YHIndictorStyleNature;
        }
            break;
        case 5:
        {
            setting.itemContentType = YHItemContentTypeImageText;
            setting.indicatorStyle =  YHIndictorStyleNature;
        }
            break;
            
        default:
            break;
    }
     
     YHSubViewController *subVC = [YHSubViewController new];
     subVC.setting = setting;
     subVC.dataSource = [self getModelsWithSetting:setting row:indexPath.row];
     [self.navigationController pushViewController:subVC animated:YES];
    
}

- (NSArray *)getModelsWithSetting:(YHSegmentSetting *)setting row:(NSInteger)row{
    NSArray *titleArr = @[@"关注",@"2020推荐",@"双十一抢先购",@"抗击疫情",@"小视频",@"电影",@"电视剧",@"NBA",@"体育"];
    NSMutableArray *titleModels = [NSMutableArray array];
    
    for (int i = 0; i < titleArr.count; i++) {
        YHSegmentItmeModel *model = [YHSegmentItmeModel itmeModelWithTitle:titleArr[i] setting:setting];
        if (setting.itemContentType == YHItemContentTypeImageText) {
            if (i == 2) {
                model.selectedImage = [UIImage imageNamed:@"双十一"];
            } else {
                if (i % 2 == 0) {
                    model.image = [UIImage imageNamed:@"端午"];
                    if (i % 4 == 0) {
                        model.selectedImage = [UIImage imageNamed:@"双十一"];
                    }
                }
            }
        }
        
        if (row == 5) {
            if (i == 1) {
                model.showBadge = YES;
                model.badgeDotColor = [UIColor redColor];
                model.dotSize = CGSizeMake(6, 6);
            }
            
            if (i == 2) {
                model.showBadge = YES;
                model.badgeURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595097377903&di=dbbd4dd87277da02b86e2d7f750b6b87&imgtype=0&src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F16%2F12%2F01%2F187c4d90056a425df880027b34704688.jpg";
                model.dotSize = CGSizeMake(30, 20);
              
            }
        }
        
        [titleModels addObject:model];
        
    }
    
return [titleModels copy];
}
@end
