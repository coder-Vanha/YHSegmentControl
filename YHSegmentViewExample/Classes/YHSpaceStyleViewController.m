//
//  YHSpaceStyleViewController.m
//  YHSegmentViewDemo
//
//  Created by wanyehua on 2018/7/1.
//  Copyright © 2018年 万叶华. All rights reserved.
//

#import "YHSpaceStyleViewController.h"
#import "YHDetailsTabController.h"
#import "YHSegmentView.h"

@interface YHSpaceStyleViewController ()

@end

@implementation YHSpaceStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *mutArr = [NSMutableArray array];
    NSArray *titleArr = @[@"未接电话",@"已拨电话"];
    for (int i = 0; i < 2; i++) {
        YHDetailsTabController *tabVC = [YHDetailsTabController new];
        tabVC.title = titleArr[i];
        [mutArr addObject:tabVC];
    }
    
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)) ViewControllersArr:[mutArr copy] TitleArr:titleArr TitleNormalSize:20 TitleSelectedSize:20 SegmentStyle:YHSegementStyleSpace ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
        NSLog(@"点击了%ld模块",(long)index);
    }];
    
    [self.view addSubview:segmentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
