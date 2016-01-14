//
//  BaseNavigationController.m
//  VideoDemo
//
//  Created by 余新闻 on 15/7/13.
//  Copyright (c) 2015年 FishNews. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
