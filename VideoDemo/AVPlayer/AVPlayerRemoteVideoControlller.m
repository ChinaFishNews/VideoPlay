//
//  AVPlayerLocalVideoControlller.m
//  VideoDemo
//
//  Created by 余新闻 on 15/7/13.
//  Copyright (c) 2015年 FishNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Const.h"

#import "AVPlayerRemoteVideoControlller.h"

@interface AVPlayerRemoteVideoControlller ()

@property (strong,nonatomic) AVPlayer      *player;
@property (strong,nonatomic) AVPlayerItem  *playerItem;
@property (strong,nonatomic) AVPlayerLayer *playerLayer;

@property (strong,nonatomic) UIView        *controlView;
@property (strong,nonatomic) UIButton      *playOrPasueButton;
@property (strong,nonatomic) UILabel       *progressLabel;     //显示播放时间
@property (strong,nonatomic) UILabel       *allTimeLabel;      //显示总时间
@property (strong,nonatomic) UISlider      *progessSlider;     //进度条
@property (strong,nonatomic) UIButton      *enLargeButton;     //横竖屏按钮
@property (strong,nonatomic) UIButton      *volumeImageView;   //音量视图
@property (strong,nonatomic) UIView        *navigationBar;
@property (strong,nonatomic) UILabel       *titleLabel;
@property (strong,nonatomic) UIButton      *backButton;
@property (strong,nonatomic) UIView        *volumeSliderView;
@property (strong,nonatomic) UISlider      *volumeSlider;

@property (strong,nonatomic) NSString      *allTime;
@property (strong,nonatomic) NSTimer       *progressTimer;
@property (strong,nonatomic) NSTimer       *autoHideTimer;

@property (assign,nonatomic) BOOL          userPause;
@property (assign,nonatomic) BOOL          whetherPortrate;
@property (assign,nonatomic) BOOL          hiddenStatus;
@property (assign,nonatomic) BOOL          hasAppearSlider;
@property (assign,nonatomic) BOOL          isControlViewAppear;
@property (assign,nonatomic) float         sliderValue;

@end


@implementation AVPlayerRemoteVideoControlller

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    if(self.player)
    {
        [self.player pause];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    int time = (int)CMTimeGetSeconds(self.player.currentItem.duration);
    
    int minute = time/60;
    int second = time%60;
    
    if (minute < 10)
    {
        if (second == 0)
        {
            self.allTime = [NSString stringWithFormat:@"0%d:00",minute];
        }else if(second < 10)
        {
            self.allTime = [NSString stringWithFormat:@"0%d:0%d",minute,second];
        }else
        {
            self.allTime = [NSString stringWithFormat:@"0%d:%d",minute,second];
        }
        self.allTimeLabel.text = [@"/" stringByAppendingString:self.allTime];
    }
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressTimerHanlder:) userInfo:nil repeats:YES];
    self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(hideControlView) userInfo:nil repeats:NO];
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    [self.view.layer      addSublayer:self.playerLayer];
    [self.view            addSubview:self.controlView];
    [self.controlView     addSubview:self.playOrPasueButton];
    [self.controlView     addSubview:self.volumeImageView];
    [self.controlView     addSubview:self.enLargeButton];
    [self.controlView     addSubview:self.progessSlider];
    [self.controlView     addSubview:self.progressLabel];
    [self.controlView     addSubview:self.allTimeLabel];
    [self.view            addSubview:self.navigationBar];
    [self.navigationBar   addSubview:self.backButton];
    [self.navigationBar   addSubview:self.titleLabel];
    
    self.hiddenStatus        = NO;
    self.hasAppearSlider     = NO;
    self.isControlViewAppear = YES;
    
    self.sliderValue = 25;
    [self setNeedsStatusBarAppearanceUpdate];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureHanlder:)];
    [self.view addGestureRecognizer:tapGesture];
    self.view.backgroundColor = [UIColor blackColor];
    
}
#pragma mark --UITapGestureRecognizer Methods--
-(void)tapGestureHanlder:(UITapGestureRecognizer *)tapgesture
{
    if (self.isControlViewAppear)
    {
        [self hideControlView];
    }else
    {
        [self showControlView];
    }
}

#pragma mark ---Actions--
-(void)playOrPause:(UIButton *)sender
{
    if (sender.selected)
    {
        [self pause];
    }else
    {
        [self play];
    }
}

-(void)onVolumeImageViewTapGesture:(UIButton *)sender
{
    if (self.hasAppearSlider)
    {
        [self.volumeSliderView removeFromSuperview];
    }else
    {
        [self configureSlider];
    }
    self.hasAppearSlider = !self.hasAppearSlider;
}

-(void)configureSlider
{
    
    self.volumeSliderView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-106,SCREEN_HEIGHT-100 ,80 , 40)];
    self.volumeSliderView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.volumeSliderView.backgroundColor = [UIColor clearColor];
    
    UISlider *volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 5, 80, 40)];
    [volumeSlider setThumbImage:[UIImage imageNamed:@"RoundSlider"] forState:UIControlStateNormal];
    [volumeSlider setMinimumTrackTintColor:[UIColor redColor]];
    [volumeSlider setUserInteractionEnabled:YES];
    [volumeSlider setMinimumValue:0];
    [volumeSlider setMaximumValue:50];
    [volumeSlider setValue:self.sliderValue];
    [volumeSlider addTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.volumeSliderView  addSubview:volumeSlider];
    [self.view addSubview:self.volumeSliderView];
}

-(void)onEnLargeButtonClicked:(UIButton *)sender
{
    if(self.hasAppearSlider)
    {
        [self.volumeSliderView removeFromSuperview];
        self.hasAppearSlider = NO;
    }
    
    if (!sender.selected)
    {
        [self setUIFrameAtLandRight];
    }else
    {
        [self setUIFrameAtPoritate];
    }
    sender.selected = !sender.selected;
}
#pragma mark   ---Setting LandRight Frames---
-(void)setUIFrameAtLandRight
{
    self.whetherPortrate = YES;
    self.hiddenStatus    = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.playerLayer.transform   = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
    self.playerLayer.frame       = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds));
    
    self.controlView.frame       = CGRectMake(30 - SCREEN_HEIGHT / 2, SCREEN_HEIGHT/ 2 - 30, SCREEN_HEIGHT, 60);
    self.controlView.transform   = CGAffineTransformRotate(self.controlView.transform, M_PI_2);
    self.navigationBar.frame     = CGRectMake(SCREEN_WIDTH - SCREEN_HEIGHT / 2 - 22, SCREEN_HEIGHT / 2 - 22, SCREEN_HEIGHT, 44);
    self.navigationBar.transform = CGAffineTransformRotate(self.navigationBar.transform, M_PI_2);
    self.volumeImageView.frame   = CGRectMake(SCREEN_HEIGHT - 36 - 10 - 30, 16, 30, 28);
    self.enLargeButton.frame     = CGRectMake(SCREEN_HEIGHT - 36-3, 15, 30, 30);
    self.progessSlider.frame     = CGRectMake(48, 26, SCREEN_HEIGHT - 36 - 33 - 100 - 38-10, 10);
    self.playOrPasueButton.frame = CGRectMake(5, 0, 60, 60);
    self.progressLabel.frame     = CGRectMake(SCREEN_HEIGHT - 36 - 33 - 100, 15,40, 30);
    self.allTimeLabel.frame      = CGRectMake(SCREEN_HEIGHT - 36 - 33 - 60, 15, 50, 30);
    self.titleLabel.frame        = CGRectMake(0, 0, SCREEN_HEIGHT,44);
    self.backButton.frame        = CGRectMake(0, 0, 44, 44);
}

#pragma mark   ---Setting Poritate Frames---
-(void)setUIFrameAtPoritate
{
    self.whetherPortrate = NO;
    self.hiddenStatus    = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    self.playerLayer.transform = CATransform3DIdentity;
    self.playerLayer.frame = CGRectMake(0,SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3);
    
    self.controlView.transform       = CGAffineTransformIdentity;
    self.navigationBar.transform     = CGAffineTransformIdentity;
    
    self.controlView.frame       = CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60);
    self.navigationBar.frame     = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    self.volumeImageView.frame   = CGRectMake(SCREEN_WIDTH-76, 16, 30, 28);
    self.enLargeButton.frame     = CGRectMake(SCREEN_WIDTH-36, 15, 30, 30);
    self.progessSlider.frame     = CGRectMake(38, 26, SCREEN_WIDTH - 207, 10);
    self.playOrPasueButton.frame = CGRectMake(-5, 0, 60, 60);
    self.progressLabel.frame     = CGRectMake(SCREEN_WIDTH - 169, 15,40, 30);
    self.allTimeLabel.frame      = CGRectMake(SCREEN_WIDTH - 129, 15,50, 30);
    self.titleLabel.frame        = CGRectMake(0, 20,SCREEN_WIDTH,_navigationBar.frame.size.height-34);
    self.backButton.frame        = CGRectMake(0,20, 44, 44);
    
    
}
#pragma mark --UISider Events--
-(void)touchDownProgressSlider:(UISlider *)slider
{
    [self.autoHideTimer invalidate];
    self.autoHideTimer = nil;
}

-(void)dragInsideProgressSlider:(UISlider *)slider
{
    CMTime duration = self.player.currentItem.duration;
    Float64 time = CMTimeGetSeconds(CMTimeMakeWithSeconds(CMTimeGetSeconds(duration)*slider.value, CMTimeGetSeconds(duration)));
    self.progressLabel.text = [self getCurrentTime:time];
    
}

-(void)TouchUpInsideProgressSlider:(UISlider *)slider
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
    CMTime duration = self.player.currentItem.duration;
    [self.player.currentItem seekToTime:CMTimeMakeWithSeconds(CMTimeGetSeconds(duration)*slider.value, CMTimeGetSeconds(duration))];
    [self play];
    self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(hideControlView) userInfo:nil repeats:NO];
}

-(void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---CurentTime --
-(NSString *)getCurrentTime:(float)f
{
    int time = (int)f;
    if (time < 1)
    {
        return @"00:00";
    }
    int minute = 0;
    int extraSeconds = 0;
    if (time > 59)
    {
        minute = time/60;
        extraSeconds = time % 60;
    }else
    {
        minute = 0;
        extraSeconds = time;
    }
    
    if (minute > 0)
    {
        if (minute > 10)
        {
            if (extraSeconds > 10)
            {
                return [NSString stringWithFormat:@"%d:%d",minute,extraSeconds];
            }else
            {
                return [NSString stringWithFormat:@"%d:0%d",minute,extraSeconds];
            }
        }else
        {
            if (extraSeconds >9)
            {
                if (extraSeconds == 60)
                {
                    return [NSString stringWithFormat:@"0%d:60",minute];
                }else
                {
                    return [NSString stringWithFormat:@"0%d:%d",minute,extraSeconds];
                }
            }else
            {
                if (extraSeconds < 1)
                {
                    return [NSString stringWithFormat:@"0%d:00",minute];
                }else
                {
                    return [NSString stringWithFormat:@"0%d:0%d",minute,extraSeconds];
                }
            }
        }
    }else
    {
        if (extraSeconds > 9)
        {
            return [NSString stringWithFormat:@"00:%d",extraSeconds];
        }else
        {
            return [NSString stringWithFormat:@"00:0%d",extraSeconds];
        }
    }
    
}

#pragma mark --NSTimer Methods--

-(void)progressTimerHanlder:(NSTimer *)timer
{
    int currentSecond = CMTimeGetSeconds(self.playerItem.currentTime);
    self.progessSlider.value = currentSecond/CMTimeGetSeconds(self.player.currentItem.duration);
    
    if (currentSecond == (int)CMTimeGetSeconds(self.player.currentItem.duration))
    {
        [self.progressTimer invalidate];
        self.progressTimer  = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (currentSecond < 1)
    {
        currentSecond = 0;
    }
    
    int minute = 0;
    int extraSeconds = 0;
    
    if (currentSecond > 59)
    {
        minute = currentSecond/60;
        extraSeconds = (int)currentSecond % 60;
    }else
    {
        minute = 0;
        extraSeconds = currentSecond;
    }
    
    if (minute > 0)
    {
        if (minute > 10)
        {
            if (extraSeconds > 10)
            {
                self.progressLabel.text = [NSString stringWithFormat:@"%d:%d",minute,extraSeconds];
            }else
            {
                self.progressLabel.text = [NSString stringWithFormat:@"%d:0%d",minute,extraSeconds];
            }
        }else
        {
            if (extraSeconds >9)
            {
                if (extraSeconds == 60)
                {
                    self.progressLabel.text = [NSString stringWithFormat:@"0%d:60",minute];
                }else
                {
                    self.progressLabel.text = [NSString stringWithFormat:@"0%d:%d",minute,extraSeconds];
                }
            }else
            {
                if (extraSeconds < 1)
                {
                    self.progressLabel.text = [NSString stringWithFormat:@"0%d:00",minute];
                }else
                {
                    self.progressLabel.text = [NSString stringWithFormat:@"0%d:0%d",minute,extraSeconds];
                }
            }
        }
    }else
    {
        if (extraSeconds > 9)
        {
            self.progressLabel.text = [NSString stringWithFormat:@"00:%d",extraSeconds];
        }else
        {
            self.progressLabel.text = [NSString stringWithFormat:@"00:0%d",extraSeconds];
        }
    }
    
}

-(void)showControlView
{
    if (self.controlView != nil)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.controlView.alpha = 1;
            self.navigationBar.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            self.isControlViewAppear = YES;
            self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(hideControlView) userInfo:nil repeats:NO];
        }];
    }
}

-(void)hideControlView
{
    if (_controlView != nil) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.controlView.alpha   = 0;
            self.navigationBar.alpha = 0;
            if (self.hasAppearSlider == YES)
            {
                [self.volumeSliderView removeFromSuperview];
            }
        } completion:^(BOOL finished) {
            
            self.isControlViewAppear = NO;
            self.hasAppearSlider = NO;
        }];
    }
}

#pragma mark   --Play or Pause--
-(void)play
{
    self.playOrPasueButton.selected = YES;
    [self.player play];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressTimerHanlder:) userInfo:nil repeats:YES];
    
}
-(void)pause
{
    self.playOrPasueButton.selected = NO;
    [self.player pause];
    [self.progressTimer invalidate];
    self.progressTimer  = nil;
    
}

#pragma mark ----Hiden StatusBar --
-(BOOL)prefersStatusBarHidden
{
    return self.hiddenStatus;
}

#pragma mark  -- Create Widgets --
-(AVPlayerLayer *)playerLayer
{
    if(_playerLayer == nil)
    {
        NSURL *sourceMovieURL = [NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
        AVAsset *movieAsset   = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        _playerItem           = [AVPlayerItem playerItemWithAsset:movieAsset];
        _player               = [AVPlayer playerWithPlayerItem:_playerItem];
        _playerLayer          = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame    = CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [_player play];
    }
    return _playerLayer;
}
-(UIView *)controlView
{
    if (_controlView == nil){
        
        _controlView                 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
        _controlView.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _controlView;
}
-(UIButton *)playOrPasueButton
{
    if (_playOrPasueButton == nil){
        
        _playOrPasueButton                 = [[UIButton alloc]initWithFrame:CGRectMake(-5, 0, 60, 60)];
        _playOrPasueButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        _playOrPasueButton.selected        = YES;
        [_playOrPasueButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        [_playOrPasueButton setImage:[UIImage imageNamed:@"Stop"] forState:UIControlStateSelected];
        [_playOrPasueButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playOrPasueButton;
}
-(UIButton *)volumeImageView
{
    if (_volumeImageView == nil){
        
        _volumeImageView                 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-76, 16, 30, 28)];
        _volumeImageView.imageEdgeInsets = UIEdgeInsetsMake(6, 3, 6, 4);
        [_volumeImageView setImage:[UIImage imageNamed:@"Sound"] forState:UIControlStateNormal];
        [_volumeImageView addTarget:self action:@selector(onVolumeImageViewTapGesture:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _volumeImageView;
}

-(void)volumeSliderValueChanged:(UISlider *)slider
{
    self.autoHideTimer.fireDate = [[NSDate alloc]initWithTimeIntervalSinceNow:2];
    self.sliderValue = slider.value;
    self.player.volume = self.sliderValue/50;
}
-(UIButton *)enLargeButton
{
    if (_enLargeButton == nil) {
        
        _enLargeButton                 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-36, 15, 30, 30)];
        _enLargeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 2, 5, 8);
        [_enLargeButton setImage:[UIImage imageNamed:@"EnLarge"] forState:UIControlStateNormal];
        [_enLargeButton addTarget:self action:@selector(onEnLargeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _enLargeButton;
}
-(UISlider *)progessSlider
{
    if (_progessSlider == nil) {
        
        _progessSlider                       = [[UISlider alloc]initWithFrame:CGRectMake(38, 26, SCREEN_WIDTH - 207, 10)];
        _progessSlider.minimumTrackTintColor = [UIColor redColor];
        _progessSlider.value                 = 0;
        [_progessSlider thumbRectForBounds:CGRectMake(-20, -20, -20, -20) trackRect:CGRectMake(-20, -20, -20, -20) value:0];
        [_progessSlider setThumbImage:[UIImage imageNamed:@"Round"] forState:UIControlStateNormal];
        [_progessSlider addTarget:self action:@selector(touchDownProgressSlider:) forControlEvents:UIControlEventTouchDown];
        [_progessSlider addTarget:self action:@selector(dragInsideProgressSlider:) forControlEvents:UIControlEventValueChanged];
        [_progessSlider addTarget:self action:@selector(TouchUpInsideProgressSlider:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _progessSlider;
}

-(UILabel *)progressLabel
{
    if (_progressLabel == nil) {
        
        _progressLabel               = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 169, 15,40, 30)];
        _progressLabel.font          = [UIFont systemFontOfSize:15];
        _progressLabel.backgroundColor = [UIColor clearColor];
        _progressLabel.text = @"00:00";
        _progressLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _progressLabel;
}

-(UILabel *)allTimeLabel
{
    if (_allTimeLabel == nil){
        
        _allTimeLabel               = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 129, 15,50, 30)];
        _allTimeLabel.font          = [UIFont systemFontOfSize:15];
        _allTimeLabel.textAlignment = NSTextAlignmentLeft;
        _allTimeLabel.backgroundColor = [UIColor clearColor];
    }
    return _allTimeLabel;
}

-(UIView *)navigationBar
{
    if (_navigationBar == nil) {
        
        _navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _navigationBar.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        
    }
    return _navigationBar;
}

-(UIButton *)backButton
{
    if (_backButton == nil) {
        
        _backButton                 = [[UIButton alloc]initWithFrame:CGRectMake(0,20, 44, 44)];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 13, 10, 13);
        [_backButton setImage:[UIImage imageNamed:@"IconBack"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel               = [[UILabel alloc]initWithFrame:CGRectMake(0, 20,SCREEN_WIDTH,_navigationBar.frame.size.height-34)];
        _titleLabel.font          = [UIFont systemFontOfSize:15];
        _titleLabel.textColor     = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text          = @"AVPlayer";
    }
    return _titleLabel;
}



@end
