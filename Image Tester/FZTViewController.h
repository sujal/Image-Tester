//
//  FZTViewController.h
//  Image Tester
//
//  Created by Sujal Shah on 6/18/12.
//  
//
//  Public Domain via CC0 http://creativecommons.org/publicdomain/zero/1.0/

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
