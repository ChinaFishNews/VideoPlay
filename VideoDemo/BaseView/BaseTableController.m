//
//  BaseTableController.m
//  VideoDemo
//
//  Created by 余新闻 on 15/7/12.
//  Copyright (c) 2015年 FishNews. All rights reserved.
//

#import "BaseTableController.h"

@implementation BaseTableController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}

#pragma mark  Hide Extra Line
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark  iOS8 Methods   iOS7:separatorInset
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
