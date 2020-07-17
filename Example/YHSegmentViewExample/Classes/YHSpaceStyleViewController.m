//
//  YHSpaceStyleViewController.m
//  YHSegmentViewDemo
//
//  Created by wanyehua on 2018/7/1.
//  Copyright © 2018年 万叶华. All rights reserved.
//

#import "YHSpaceStyleViewController.h"
#import "YHSegmentView.h"
#import "YHTableViewListView.h"
#import "YHSegmentViewConstant.h"
#import "YHSegmentSetting.h"

@interface YHSpaceStyleViewController ()
<
UIScrollViewDelegate,
YHSegmentViewDelegate
>

@property (nonatomic, strong) YHSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, strong) NSArray *subViews;

@end

@implementation YHSpaceStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
// containerView
      UIScrollView *containerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 300)];
      containerView.delegate = self;
      containerView.pagingEnabled = YES;
      containerView.alwaysBounceHorizontal = NO;
      containerView.showsHorizontalScrollIndicator = NO;
      _containerView = containerView;
      [self.view addSubview:containerView];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSMutableArray *vcMutArr = [NSMutableArray array];
  
  //   NSArray *titleArr = @[@"精选",@"2018世界杯",@"明日之子"];
    
    NSArray *titleArr = @[@"精选",@"2018世界杯",@"明日之子",@"电影",@"电视剧",@"NBA",@"花样年华",@"体育",@"电视剧",@"NBA",@"花样年华",@"体育"];
  
    NSArray *titleModels4NewUI = [YHSegmentItmeModel itemsWithTitles:titleArr];
    
    for (int i = 0; i < titleArr.count; i++) {

        YHTableViewListView *listView = [[YHTableViewListView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(containerView.frame), 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame))];
        listView.title = [NSString stringWithFormat:@"%@--%d",titleArr[i],i];
        [vcMutArr addObject:listView];


        [containerView addSubview:listView];
    }
    
    self.subViews = [vcMutArr copy];
    containerView.contentSize = CGSizeMake(titleArr.count * CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    
    
    YHSegmentSetting *setting = [YHSegmentSetting defaultSetting];
    setting.titleNormalColor = YH_RGB(111,111,111);
    setting.titleSelectColor = YH_RGB(0,0,0);
//    setting.progressLeftColor = BBColor(BBBackgroundThemeColor);
//    setting.progressRightColor = BBColor(BBBackgroundThemeDarkColor);
    setting.backgroundNormalColor = YH_RGB(247,247,247);
//    setting.progressLeftColor = [UIColor orangeColor];
//    setting.progressRightColor = [UIColor redColor];
    setting.backgroundTopColor = [UIColor whiteColor];
    setting.titleNormalFont =  [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    setting.titleSelectFont = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    setting.imageNormalWidth = 64.0 * 0.95;
    setting.imageMaxWidth = 64;
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:scrollView];
    
    self.segmentView = [YHSegmentView menuViewWithModels:titleModels4NewUI setting:setting currentSelectIndex:0 pageScrollView:containerView delegate:self];
    self.segmentView.frame = CGRectMake(0, 80, self.view.bounds.size.width, 50);
    [self.segmentView setShowTypeIsTop:YES];
    self.segmentView.backgroundColor = [UIColor whiteColor];
    self.segmentView.layer.shadowColor = [UIColor clearColor].CGColor;


    [self.view addSubview:_segmentView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.segmentView bbui_scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.segmentView bbui_scrollViewDidEndDecelerating:scrollView];
}

@end
