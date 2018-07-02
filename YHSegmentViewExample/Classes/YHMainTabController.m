//
//  YHMainTabController.m
//  YHSegmentViewDemo
//
//  Created by wanyehua on 2018/7/1.
//  Copyright © 2018年 万叶华. All rights reserved.
//

#import "YHMainTabController.h"
#import "YHIndicatorStyleViewController.h"
#import "YHSpaceStyleViewController.h"

@interface YHMainTabController ()
@property (nonatomic, copy) NSArray <NSString *>*titleArr;
@end

@implementation YHMainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YHSegmentView";
    self.titleArr = @[@"指示杆样式",@"分割线样式"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
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
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[YHIndicatorStyleViewController new] animated:YES];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController:[YHSpaceStyleViewController new] animated:YES];
        }
            break;
       
        default:
            break;
    }
}


@end
