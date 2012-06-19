//
//  FZTViewController.m
//  Image Tester
//
//  Created by Sujal Shah on 6/18/12.
//  Copyright (c) 2012 Fanzter, Inc.. All rights reserved.
//

#import "FZTViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FZTViewController ()

@end

@implementation FZTViewController

@synthesize imageView=imageView_;
@synthesize statusDisplay=statusDisplay_;
@synthesize toggleButton=toggleButton_;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        state = 0;
        NSLog(@"booooo");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"I'm here");
}

- (void)viewDidUnload
{
    [dispLink_ invalidate];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)toggleImageType:(id)sender {
    state++;
    
    NSString* imageName = nil;
    NSString* type = nil;
    NSString* label_text = nil;
    
    switch (state%3) {
        case 1:
            imageName = @"photo";
            type = @"JPG";
            label_text = @"Regular JPG";
            break;
        case 2:
            imageName = @"green-ipad-wallpaper-x2";
            type = @"jpg";
            label_text = @"Progressive JPG";
            break;
        case 0:
            imageName = @"full_loading";
            type = @"png";
            label_text = @"Hit toggle to load an image.";
            break;
        default:
            break;
    }
    ///////////////
    //
    // This bit is used to time the runloop. I don't know a better way to do this
    // but I assume there is... for now... HACK HACK HACK. :-)

    buttonTriggeredDate_ = [NSDate date];
    [[NSRunLoop mainRunLoop] performSelector:@selector(fire:) target:self argument:[NSNumber numberWithInt:0] order:1 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];

    ///////////////

    NSString* path = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
    self.imageView.image = [UIImage imageWithContentsOfFile:path];
    
    NSLog(@"mark 0");
    self.statusDisplay.text = [NSString stringWithFormat:@"%@",
                               label_text];
}

- (void)fire:(NSNumber*)counter {
    int iterCount = [counter intValue];
    NSLog(@"mark %d", iterCount);
    NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:buttonTriggeredDate_];
    
    // We really need the second pass through - if it's less than X, assume
    // it's just that first runloop iteration before the draw happens. Just wait
    // for the next one.
    if (iterCount < 1) {
        iterCount++;
        [[NSRunLoop mainRunLoop] performSelector:@selector(fire:) 
                                          target:self 
                                        argument:[NSNumber numberWithInt:iterCount] 
                                           order:1 
                                           modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    } else {
        self.statusDisplay.text = [NSString stringWithFormat:@"%@ - Took %f Seconds",
                                   self.statusDisplay.text,
                                   interv];
    }
}

@end
