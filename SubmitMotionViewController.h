//
//  SubmitMotionViewController.h
//  MotionMe
//
//  Created by Akshar Bonu  on 6/24/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SubmitMotionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textFieldToSubmitMotion;
@property (weak, nonatomic) IBOutlet UITextField *textFieldToSubmitSource;
@property (weak, nonatomic) IBOutlet UILabel *UserInfoLabel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *maskTextField;
@property (weak, nonatomic) IBOutlet UILabel *motionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceTitleLabel;

@end
