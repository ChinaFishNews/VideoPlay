//
//  LocalVideoDisplay.m
//  VideoDemo
//
//  Created by 余新闻 on 15/7/12.
//  Copyright (c) 2015年 FishNews. All rights reserved.
//

#import "LocalVideoDisplay.h"

#import "ALMoviePlayerControls.h"
#import "ALMoviePlayerController.h"
#import "Const.h"

@interface LocalVideoDisplay() <ALMoviePlayerControllerDelegate>

@property(strong,nonatomic) ALMoviePlayerController *moviePlayer;

@end

@implementation LocalVideoDisplay

-(void)viewDidLoad
{
    self.navigationItem.title  =@"本地视频";
    
    [self.view addSubview:self.moviePlayer.view];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.moviePlayer != nil) {
        [self.moviePlayer pause];
    }
}

#pragma mark  Create Widgets
-(ALMoviePlayerController *)moviePlayer
{
    if (_moviePlayer == nil)
    {
        //Create the Player
        _moviePlayer = [[ALMoviePlayerController alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/3,SCREEN_WIDTH, SCREEN_WIDTH*9/16)];
        _moviePlayer.view.alpha = 1;
        _moviePlayer.delegate = self;
    
        //Create the Controls
        ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc]initWithMoviePlayer:_moviePlayer style:ALMoviePlayerControlsStyleDefault];
        movieControls.timeRemainingDecrements = true;
        movieControls.fadeDelay = 5.0;
        movieControls.barHeight = 100;
        movieControls.seekRate = 7.0;
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"popeye" ofType:@".mp4"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        _moviePlayer.controls = movieControls;
        [_moviePlayer stop];
        _moviePlayer.contentURL = url;
        [_moviePlayer play];
        
    }
    return _moviePlayer;
}

#pragma mark ALMoviePlayerControllerDelegate
-(void)moviePlayerWillMoveFromWindow
{
    NSArray *arr = self.view.subviews;
    if (![arr containsObject:_moviePlayer.view])
    {
        [self.view addSubview:_moviePlayer.view];
    }
    [_moviePlayer setFrame:CGRectMake(0, SCREEN_WIDTH/3, SCREEN_WIDTH, SCREEN_WIDTH*9/16)];
    
}
-(void)movieTimedOut
{
    NSLog(@"MOVIE TIMED OUT");
}

@end
