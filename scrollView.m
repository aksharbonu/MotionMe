//
//  scrollView.m
//  MotionMe
//
//  Created by Akshar Bonu  on 6/28/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import "scrollView.h"

@implementation scrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) textViewDidBeginEditing:(UITextView *) textView
{

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 1136)
            {
                CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-280);
                [self setContentOffset:scrollPoint animated:YES];
            }
            else
            {
                CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-180);
                [self setContentOffset:scrollPoint animated:YES];
            }
        }

    }
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textField {
    if ([textField.text isEqualToString: @""])
    {
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString: @""])
    {
    }
    [self setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
