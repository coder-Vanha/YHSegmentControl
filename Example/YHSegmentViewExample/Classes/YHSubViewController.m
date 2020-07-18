//
//  YHSubViewController.m
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/18.
//  Copyright © 2020 wanwan. All rights reserved.
//

#import "YHSubViewController.h"
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



// MARK -- YHSubViewController
@interface YHSubViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
YHSegmentControlDelegate
>

@property (nonatomic, strong) YHSegmentControl *segmentViewControl;
@property (nonatomic, strong) UICollectionView *containerView;


@end

//static CGFloat currentIndex = 0;

@implementation YHSubViewController

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
   

    containerView.contentSize = CGSizeMake(self.dataSource.count * CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    
  
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:scrollView];
    


    YHSegmentControl *segmentControl = [YHSegmentControl yh_segmentControlWithModels:self.dataSource setting:_setting currentSelectIndex:0 pageScrollView:containerView delegate:self];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.segmentViewControl yh_scrollViewWillBeginDragging:scrollView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


