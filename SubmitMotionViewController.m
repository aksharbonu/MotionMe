//
//  SubmitMotionViewController.m
//  MotionMe
//
//  Created by Akshar Bonu  on 6/24/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import "SubmitMotionViewController.h"
#import "DebateMotion+ParseDebateMotion.h"
#import <QuartzCore/QuartzCore.h>


@interface SubmitMotionViewController ()



@end

@implementation SubmitMotionViewController

- (IBAction)submitMotion:(UIButton *)sender
{
    if (!([self.textFieldToSubmitMotion.text isEqualToString: @""] || [self.textFieldToSubmitSource.text isEqualToString: @""]))
    {
        sender.userInteractionEnabled = NO;
        self.UserInfoLabel.text = [NSString stringWithFormat: @"Contacting Server"];
        PFQuery *newQuery = [PFQuery queryWithClassName: @"debateMotion"];
        [newQuery whereKey: @"motionName" equalTo: self.textFieldToSubmitMotion.text];
        [newQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error)
            {
                self.UserInfoLabel.text = [NSString stringWithFormat: @"Submission Failed"];
                sender.userInteractionEnabled = YES;
            }
            else
            {
                PFObject *motion = [PFObject objectWithClassName:@"debateMotion"];
                [motion setObject: self.textFieldToSubmitMotion.text forKey:@"motionName"];
                [motion setObject: self.textFieldToSubmitSource.text forKey:@"source"];
                [motion setObject: [NSNumber numberWithInt:0] forKey:@"numberOfUpVotes"];
                [motion setObject: [NSNumber numberWithInt:0] forKey:@"numberOfDownVotes"];
                [motion setObject:[NSArray array] forKey:@"usersThatHaveVoted"];
                [motion saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error)
                    {
                        [DebateMotion debateMotionWithParseObject:motion inManagedObjectContect:self.managedObjectContext];
                        sender.userInteractionEnabled = YES;
                        self.UserInfoLabel.text = [NSString stringWithFormat: @"Submission Successful"];
                    }
                    else
                    {
                        sender.userInteractionEnabled = YES;
                        self.UserInfoLabel.text = [NSString stringWithFormat: @"Submission Failed"];
                    }
                }];
            }
            
        }];
    }
    else
    {
        self.UserInfoLabel.text = [NSString stringWithFormat: @"Empty Field"];
    }
}

- (IBAction)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textFieldToSubmitMotion.text = @"";
    self.textFieldToSubmitSource.text = @"";
    self.UserInfoLabel.text = [NSString stringWithFormat: @""];
    self.maskTextField.frame = CGRectInset(self.textFieldToSubmitMotion.frame, 0, -2);
    
    self.textFieldToSubmitMotion.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    self.textFieldToSubmitSource.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
    self.motionTitleLabel.font = [UIFont fontWithName:@"KomikaTitle-Axis" size:25];
    self.sourceTitleLabel.font = [UIFont fontWithName:@"KomikaTitle-Axis" size:25];
    self.UserInfoLabel.font = [UIFont fontWithName:@"KomikaTitle-Brush" size:20];

                            
                            
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
