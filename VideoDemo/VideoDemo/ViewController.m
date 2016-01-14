//
//  ViewController.m
//  VideoDemo
//
//  Created by 余新闻 on 15/7/12.
//  Copyright (c) 2015年 FishNews. All rights reserved.
//

#import "ViewController.h"


#define DataArray \
@[ \
@{@"title" : @"本地视频播放-封装MPMoviePlayerController", @"className" : @"LocalVideoDisplay"}, \
@{@"title" : @"网络视频播放-封装MPMoviePlayerController", @"className" : @"RemoteVideoDisplay"}, \
@{@"title" : @"本地视频播放-使用MPMoviePlayerController", @"className" : @"LocalVideoDisplay2"}, \
@{@"title" : @"网络视频播放-使用MPMoviePlayerController", @"className" : @"RemoteVideoDisplay2"}, \
@{@"title" : @"本地视频播放-使用AVPlayer"               , @"className" : @"AVPlayerLocalVideoControlller"}, \
@{@"title" : @"网络视频播放-使用AVPlayer"               , @"className" : @"AVPlayerRemoteVideoControlller"}, \
]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"蛋蛋的忧伤";
}
#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return DataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [DataArray[indexPath.row] objectForKey:@"title"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    Class currentClass = NSClassFromString([DataArray[indexPath.row] objectForKey:@"className"]);
//    UIViewController *controller = [[currentClass alloc]init];
//    [self.navigationController pushViewController:controller animated:YES];
    
    switch (indexPath.row) {
        case 0:
             [self performSegueWithIdentifier:@"LocalVideoDisplay" sender:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"RemoteVideoDisplay" sender:nil];
            break;
        case 2:
             [self performSegueWithIdentifier:@"LocalVideoDisplay2" sender:nil];
             break;
        case 3:
             [self performSegueWithIdentifier:@"RemoteVideoDisplay2" sender:nil];
             break;
        case 4:
            [self performSegueWithIdentifier:@"AVPlayerLocalVideoControlller" sender:nil];
            break;
        default:
           [self performSegueWithIdentifier:@"AVPlayerRemoteVideoControlller" sender:nil];
            break;
    }
    
}

@end
