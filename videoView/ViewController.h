//
//  ViewController.h
//  videoView
//
//  Created by Born To Win on 26/09/14.
//  Copyright (c) 2014 sugartin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMovieViewController.h"
@interface ViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *tallMpContainer;
@property (weak, nonatomic) IBOutlet MyMovieViewController *mpContainer;

@property(nonatomic,readwrite)BOOL isMinimize;
@property(nonatomic,readwrite)BOOL isSwipe;
@end
