//
//  FZTViewController.h
//  Image Tester
//
//  Created by Sujal Shah on 6/18/12.
//  Copyright (c) 2012 Fanzter, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZTViewController : UIViewController {
    NSInteger state;
    CADisplayLink* dispLink_;
    NSDate* buttonTriggeredDate_;
}


@property (nonatomic) IBOutlet UIImageView* imageView;
@property (nonatomic) IBOutlet UIButton* toggleButton;
@property (nonatomic) IBOutlet UILabel* statusDisplay;

- (IBAction)toggleImageType:(id)sender;

@end
