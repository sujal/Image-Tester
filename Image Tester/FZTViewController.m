//
//  FZTViewController.m
//  Image Tester
//
//  Created by Sujal Shah on 6/18/12.
//  
//
//  Public Domain via CC0 http://creativecommons.org/publicdomain/zero/1.0/

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
    [[NSRunLoop mainRunLoop] performSelector:@selector(fire:) target:self argument:[NSNumber numberWithInt:0] order:1 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
    dispLink_ = [CADisplayLink displayLinkWithTarget:self selector:@selector(loopFired:)];
    [dispLink_ addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
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
    BOOL network = NO;
    
    switch (state%4) {
        case 1:
            imageName = @"regular";
            type = @"jpg";
            label_text = @"Regular JPG";
            break;
        case 2:
            imageName = @"progressive";
            type = @"jpg";
            label_text = @"Progressive jpg";
            break;
        case 3:
            imageName = @"http://www3.images.coolspotters.com/wallpapers/151931/blue-ipad-wallpaper-x2.jpg";
            type = nil;
            label_text = @"blue loaded from network";
            network = YES;
            break;
        case 0:
            imageName = @"full_loading";
            type = @"png";
            label_text = @"Hit toggle to load an image.";
            break;
        default:
            break;
    }
    
    
    if (network) {
        downloadStartedDate_ = [NSDate date];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageName]
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:20];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
                                   NSLog(@"Done downloading");
                                   NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:downloadStartedDate_];
                                   downloadStartedDate_ = nil;
                                   self.statusDisplay.text = [NSString stringWithFormat:@"%@ - Downloaded in %f Seconds",
                                                              self.statusDisplay.text,
                                                              interv];
                                   
                                   if (error == nil) {
                                       ///////////////
                                       //
                                       // This bit is used to time the runloop. I don't know a better way to do this
                                       // but I assume there is... for now... HACK HACK HACK. :-)
                                       
                                       buttonTriggeredDate_ = [NSDate date];

                                       
                                       ///////////////
                                       
                                       self.imageView.image = [UIImage imageWithData:data];
                                       
                                   } else {
                                       UIAlertView* blah = [[UIAlertView alloc] initWithTitle:@"ERROR!!"
                                                                                      message:@"ERROR!!" delegate:nil
                                                                            cancelButtonTitle:@"So what?"
                                                                            otherButtonTitles:nil];
                                       [blah show];
                                   }
                               }];
    } else {
        ///////////////
        //
        // This bit is used to time the runloop. I don't know a better way to do this
        // but I assume there is... for now... HACK HACK HACK. :-)
        
        buttonTriggeredDate_ = [NSDate date];
//        [[NSRunLoop mainRunLoop] performSelector:@selector(fire:) target:self argument:[NSNumber numberWithInt:0] order:1 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        
        ///////////////
        
        NSString* path = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
        self.imageView.image = [UIImage imageWithContentsOfFile:path];        
    }
    
    NSLog(@"mark 0");
    self.statusDisplay.text = [NSString stringWithFormat:@"%@",
                               label_text];
}

- (void)fire:(NSNumber*)counter {
    int iterCount = [counter intValue];
    
    if (buttonTriggeredDate_ != nil) {
        NSLog(@"mark %d", iterCount);
        NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:buttonTriggeredDate_];
        
        // We really need the second pass through - if it's less than X, assume
        // it's just that first runloop iteration before the draw happens. Just wait
        // for the next one.
        
        if (iterCount < 1) {
            iterCount++;
        } else {
            buttonTriggeredDate_ = nil; 
            iterCount = 0;
            self.statusDisplay.text = [NSString stringWithFormat:@"%@ - Took %f Seconds",
                                       self.statusDisplay.text,
                                       interv];
        }        
    }
    [[NSRunLoop mainRunLoop] performSelector:@selector(fire:) 
                                      target:self 
                                    argument:[NSNumber numberWithInt:iterCount] 
                                       order:1 
                                       modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

- (void)loopFired:(CADisplayLink*)sender {
    
    if (lastDisplayLinkFireDate_ != nil) {
        NSTimeInterval diff = [lastDisplayLinkFireDate_ timeIntervalSinceNow];
        if (fabs(diff) > 0.2) { 
            NSLog(@"slow fire: %f", diff);
        }
    }
    lastDisplayLinkFireDate_ = [NSDate date];
}

@end
