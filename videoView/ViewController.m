//
//  ViewController.m
//  videoView
//
//  Created by Born To Win on 26/09/14.
//  Copyright (c) 2014 sugartin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
        swipeDown.delegate = self;
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.delegate = self;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeLeft:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;;
    
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwiperight:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    [self.mpContainer addGestureRecognizer:swipeUp];
    [self.mpContainer addGestureRecognizer:swipeDown];
    [self.mpContainer addGestureRecognizer:leftGesture];
    [self.mpContainer addGestureRecognizer:rightGesture];

    
     [self.mpContainer playMovieFile:[self localMovieURL]];

    
    self.mpContainer.layer.borderColor = [UIColor blueColor].CGColor;
    self.mpContainer.layer.borderWidth = 1.0;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.mpContainer.moviePlayerController.view.frame = CGRectMake(0, 5, 320, 180);
          self.mpContainer.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    }];
}
-(NSURL *)localMovieURL
{
	NSURL *theMovieURL = nil;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle)
	{
		NSString *moviePath = [bundle pathForResource:@"Movie" ofType:@"m4v"];
		if (moviePath)
		{
			theMovieURL = [NSURL fileURLWithPath:moviePath];
		}
	}
    return theMovieURL;
}
- (void)swipeDown:(UIGestureRecognizer *)gr {
    [self minimizeMp:YES animated:YES];
}

- (void)swipeUp:(UIGestureRecognizer *)gr {
    [self minimizeMp:NO animated:YES];
}
- (BOOL)mpIsMinimized {
    return self.tallMpContainer.frame.origin.y > 0;
}
- (void)minimizeMp:(BOOL)minimized animated:(BOOL)animated {
    self.mpContainer.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    if ([self mpIsMinimized] == minimized) return;
    
    CGRect tallContainerFrame, containerFrame;
    CGFloat tallContainerAlpha;

    if (minimized) {
        CGFloat mpWidth = 160;
        CGFloat mpHeight = 90; // 160:90 == 16:9
        
        CGFloat x = 320-mpWidth;
        CGFloat y = self.view.bounds.size.height - mpHeight;
        
        tallContainerFrame = CGRectMake(x, y - 66, 320, self.view.bounds.size.height);
        containerFrame = CGRectMake(x, y, mpWidth, mpHeight);
        tallContainerAlpha = 0.0;
        
    } else {

        tallContainerFrame = self.view.bounds;
        containerFrame = CGRectMake(0, 66, 320, 180);
        tallContainerAlpha = 1.0;
    }
    NSTimeInterval duration = (animated)? 5.0 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        NSLog(@"%f %f",self.mpContainer.frame.origin.x,self.mpContainer.frame.origin.y);
        
        self.tallMpContainer.frame = tallContainerFrame;
        self.mpContainer.frame = containerFrame;
        self.tallMpContainer.alpha = tallContainerAlpha;
        if (minimized) {
            self.mpContainer.moviePlayerController.view.frame = CGRectMake(0, 0, 160, 90);
        }else{
            self.mpContainer.moviePlayerController.view.frame = CGRectMake(0, 0, 320, 180);
        }
    }completion:^(BOOL finished) {
        NSLog(@"%f %f",self.mpContainer.frame.origin.x,self.mpContainer.frame.origin.y);
        
        if (minimized) {
            self.mpContainer.moviePlayerController.view.frame = CGRectMake(0, 0, 160, 90);
        }else{
            self.mpContainer.moviePlayerController.controlStyle = MPMovieControlStyleDefault;
        }
    }];
}
- (IBAction)handleSwipeLeft:(UITapGestureRecognizer *)gestures {
    if ([self mpIsMinimized] == YES){
        [UIView animateWithDuration:0.5 animations:^{
            self.mpContainer.frame = CGRectMake(-320, 480,  self.mpContainer.frame.size.width, self.mpContainer.frame.size.height);
        }];
    }
}
- (IBAction)handleSwiperight:(UITapGestureRecognizer *)gestures {
    if ([self mpIsMinimized] == YES){
        [UIView animateWithDuration:0.5 animations:^{
            self.mpContainer.frame = CGRectMake(320, 480,  self.mpContainer.frame.size.width, self.mpContainer.frame.size.height);
        }];
    }
}
-(IBAction)resetVideo:(id)sender{
    if ([self mpIsMinimized] == NO) return;
    
    CGRect tallContainerFrame, containerFrame;
    CGFloat tallContainerAlpha;
    
    tallContainerFrame = self.view.bounds;
    containerFrame = CGRectMake(0, 66, 320, 180);
    tallContainerAlpha = 1.0;
    
    NSTimeInterval duration = (NO)? 2.5 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tallMpContainer.frame = tallContainerFrame;
        self.mpContainer.frame = containerFrame;
        self.tallMpContainer.alpha = tallContainerAlpha;
        self.mpContainer.moviePlayerController.view.frame = CGRectMake(0, 0, 320, 180);
    }];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (self.isSwipe)
//        return NO;
    return YES;
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
//    if (self.fullScreenVideoIsPlaying == YES) {
        return UIInterfaceOrientationMaskAll;
//    }else {
//        return orientations;
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
