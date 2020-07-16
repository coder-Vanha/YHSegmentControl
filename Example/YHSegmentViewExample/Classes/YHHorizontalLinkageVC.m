//
//  YHHorizontalLinkageVC.m
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/14.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import "YHHorizontalLinkageVC.h"
#import "YHSegmentControl.h"
#import "YHTableViewListView.h"
#import "YHSegmentViewConstant.h"

// MARK -- YHSegmentPageItem
@interface YHSegmentPageItem : UICollectionViewCell
@property (nonatomic, strong) YHTableViewListView *litstView;
@end

@implementation YHSegmentPageItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        YHTableViewListView *litstView = [YHTableViewListView new];
        _litstView = litstView;
        [self.contentView addSubview:litstView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.litstView.frame = self.bounds;
}

@end




// MARK -- YHHorizontalLinkageVC
@interface YHHorizontalLinkageVC ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
YHSegmentControlDelegate
>

@property (nonatomic, strong) YHSegmentControl *segmentViewControl;
@property (nonatomic, strong) UICollectionView *containerView;
@property (nonatomic, strong) NSArray *dataSource;

@end

static CGFloat currentIndex = 0;

@implementation YHHorizontalLinkageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // containerView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 300);
    
    UICollectionView *containerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 300) collectionViewLayout:flowLayout];
    [containerView registerClass:[YHSegmentPageItem class] forCellWithReuseIdentifier:@"YHSegmentPageItemCellID"];
    containerView.dataSource = self;
    containerView.delegate = self;
    containerView.pagingEnabled = YES;
    containerView.alwaysBounceHorizontal = NO;
    containerView.showsHorizontalScrollIndicator = NO;
    containerView.backgroundColor = [UIColor whiteColor];
    _containerView = containerView;
    [self.view addSubview:containerView];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSMutableArray *vcMutArr = [NSMutableArray array];
    NSArray *titleArr = @[@"精选",@"2018世界杯",@"明日之子",@"电影"];
    
//     NSArray *titleArr = @[@"精选",@"2018世界杯",@"明日之子",@"电影",@"电视剧",@"NBA",@"花样年华",@"体育",@"电视剧",@"NBA",@"花样年华",@"体育"];
    NSMutableArray *titleModels4NewUI = [NSMutableArray array];
    
    for (int i = 0; i < titleArr.count; i++) {
          
        YHSegmentItmeModel *model = [YHSegmentItmeModel itmeModelWithTitle:titleArr[i] normalColor:[UIColor blackColor] selectedColor:[UIColor orangeColor] normalFont:[UIFont systemFontOfSize:13] selectedFont:[UIFont boldSystemFontOfSize:16] height:40 insets:UIEdgeInsetsMake(0, 8, 0, 8)];
        [titleModels4NewUI addObject:model];
        
    }
    
    self.dataSource = [titleModels4NewUI copy];
    containerView.contentSize = CGSizeMake(titleArr.count * CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    
    YHSegmentSetting *setting = [YHSegmentSetting defaultSetting];
    setting.titleNormalColor = YH_RGB(111,111,111);
    setting.titleSelectColor = YH_RGB(0,0,0);
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
    


    YHSegmentControl *segmentControl = [YHSegmentControl yh_segmentControlWithModels:titleModels4NewUI setting:setting currentSelectIndex:0 pageScrollView:containerView delegate:self];
    segmentControl.frame = CGRectMake(0, 60, 340, 44);
    segmentControl.backgroundColor = [UIColor greenColor];
    _segmentViewControl = segmentControl;
    
    [self.view addSubview:segmentControl];
    
    
    [containerView reloadData];

}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YHSegmentPageItem *cell = (YHSegmentPageItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YHSegmentPageItemCellID" forIndexPath:indexPath];
    
    if (self.dataSource.count > indexPath.row) {
          YHSegmentItmeModel *model = [self.dataSource objectAtIndex:indexPath.item];
        cell.litstView.title = [NSString stringWithFormat:@"%@--%ld",model.title,(long)indexPath.item];
        
       // NSLog(@"😄---%@",model.title);
    }
  
    return cell;
}


#pragma mark - YHSegmentControlDelegate
- (void)yh_segmentControlItemDidSelectedIndex:(NSInteger)index {
    [self.containerView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.segmentViewControl yh_scrollViewDidScroll:scrollView];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.segmentViewControl yh_scrollViewDidEndDecelerating:scrollView];
   // NSLog(@"减速完成----333333");
}



//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSLog(@"----444444");
//}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


