//
//  LocalVideoDisplay2.m
//  VideoDemo
//
//  Created by 余新闻 on 15/7/20.
//  Copyright (c) 2015年 FishNews. All rights reserved.
//

#import "LocalVideoDisplay2.h"

#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface LocalVideoDisplay2()

@property (nonatomic, strong)MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong)MPMoviePlayerViewController *playerViewController;

@end

@implementation LocalVideoDisplay2

-(void)viewDidLoad
{
    self.navigationItem.title  =@"本地视频";
    
    [self.navigationController.view addSubview:self.moviePlayer.view];
    
}

-(MPMoviePlayerController *)moviePlayer
{
    if (_moviePlayer == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"popeye" ofType:@"mp4"];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL fileURLWithPath:path];

//        _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//        _moviePlayer = [_playerViewController moviePlayer];
//        [self.navigationController presentViewController:_playerViewController animated:YES completion:nil];
//
        
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        [_moviePlayer.view setFrame:self.view.bounds];
        _moviePlayer.initialPlaybackTime = -1;   //开始播放位置
        _moviePlayer.currentPlaybackRate = 1.0;  //播放速率
        _moviePlayer.currentPlaybackTime = 20;
       
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        [_moviePlayer play];
        
        //1 监听播放状态
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_moviePlayer];
        //        //2 监听播放完成
//                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        //        //3视频截图
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(caputerImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:_moviePlayer];
        //        //4退出全屏通知
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exitFullScreen) name:MPMoviePlayerDidExitFullscreenNotification object:_moviePlayer];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
        
    }
    return _moviePlayer;
}
- (void)myMovieFinishedCallback:(NSNotification *)notify
{
    MPMoviePlayerController *theMovie = [notify object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:(theMovie)];
    
    [theMovie.view removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 MPMoviePlaybackStateStopped,            //停止
 MPMoviePlaybackStatePlaying,            //播放
 MPMoviePlaybackStatePaused,             //暂停
 MPMoviePlaybackStateInterrupted,        //中断
 MPMoviePlaybackStateSeekingForward,     //快进
 MPMoviePlaybackStateSeekingBackward     //快退
 */
- (void)stateChange
{
    switch (_moviePlayer.playbackState) {
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停");
            break;
        case MPMoviePlaybackStatePlaying:
            //设置全屏播放
            [_moviePlayer setFullscreen:YES animated:YES];
            NSLog(@"播放");
            break;
        case MPMoviePlaybackStateStopped:
            //注意：正常播放完成，是不会触发MPMoviePlaybackStateStopped事件的。
            //调用[self.player stop];方法可以触发此事件。
            NSLog(@"停止");
            break;
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"快进");
            break;
         case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"快退");
            break;
        default:
            break;
    }
}

@end
