//
//  YHMainTabController.m
//  YHSegmentViewDemo
//
//  Created by wanyehua on 2018/7/1.
//  Copyright © 2018年 万叶华. All rights reserved.
//

#import "YHMainTabController.h"
#import "YHSubViewController.h"
#import "YHSegmentViewConstant.h"

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
    setting.titleNormalColor = YH_RGB(111,111,111);
    setting.titleSelectColor = YH_RGB(0,0,0);
    setting.backgroundNormalColor = YH_RGB(247,247,247);
    setting.titleNormalFont =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    setting.titleSelectFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    setting.imageNormalWidth = 64.0 * 0.95;
    setting.imageMaxWidth = 64;
    
    switch (indexPath.row) {
        case 0:
        {
            setting.indicatorStyle =  YHIndictorStyleLeap;
        }
            break;
        case 1:
        {
            setting.indicatorStyle =  YHIndictorStyleAlignToTitle;
        }
            break;
        case 2:
        {
            setting.indicatorStyle =  YHIndictorStyleNature;
        }
            break;
        case 3:
        {
            setting.indicatorStyle =  YHIndictorStyleLeap;
        }
            break;
        case 4:
        {
            setting.indicatorStyle =  YHIndictorStyleNature;
        }
            break;
            
        default:
            break;
    }
    
     YHSubViewController *subVC = [YHSubViewController new];
     subVC.setting = setting;
     [self.navigationController pushViewController:subVC animated:YES];
    
    
}


@end
