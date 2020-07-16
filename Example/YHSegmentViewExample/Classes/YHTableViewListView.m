//
//  YHTableViewListView.m
//  YHSegmentViewExample
//
//  Created by Vanha on 2020/7/13.
//  Copyright © 2020 wanwan. All rights reserved.
//

#define randomColor [UIColor colorWithRed:arc4randouniform(256)/255.0 green:arc4randouniform(256)/255.0 blue:arc4randouniform(256)/255.0 alpha:1.0]

#import "YHTableViewListView.h"

@interface YHTableViewListView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YHTableViewListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
   // if ([_title isEqualToString:title]) return;
  
    _title = title;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"----%@🍺",self.title];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"------------CELL display");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

@end
