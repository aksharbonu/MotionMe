//
//  MotionGeneratorViewController.h
//  MotionMe
//
//  Created by Akshar Bonu  on 6/24/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DebateMotion.h"

@interface MotionGeneratorViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *motionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *motionScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *backgroundTextFieldMotion;
@property (weak, nonatomic) IBOutlet UITextField *backgroundTextFieldSource;
@property (weak, nonatomic) IBOutlet UITextView *backgroundTextViewMotion;



- (void) updateScore: (DebateMotion *) motion;

@end

