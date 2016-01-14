//
//  RemoteVideoDisplay2.m
//  VideoDemo
//
//  Created by 余新闻 on 15/7/20.
//  Copyright (c) 2015年 FishNews. All rights reserved.
//

#import "RemoteVideoDisplay2.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@interface RemoteVideoDisplay2 ()

@property (nonatomic, strong)MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong)MPMoviePlayerViewController *playerViewController;

@end

@implementation RemoteVideoDisplay2

-(void)viewDidLoad
{
    self.navigationItem.title  =@"网络视频";
    
    [self.navigationController.view addSubview:self.moviePlayer.view];
}

-(MPMoviePlayerController *)moviePlayer
{
    if (_moviePlayer == nil)
    {
        NSURL *movieURL = [NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
//        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
//        [self presentMoviePlayerViewControllerAnimated:playerViewController];
//        _moviePlayer = [playerViewController moviePlayer];
        
        _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:movieURL];
        _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        _moviePlayer.shouldAutoplay = YES;
        _moviePlayer.repeatMode = MPMovieRepeatModeOne;
        [_moviePlayer.view setFrame:self.view.bounds];
        [_moviePlayer setFullscreen:YES animated:YES];
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [_moviePlayer play];
        
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

@end
