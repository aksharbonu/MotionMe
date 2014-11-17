//
//  MotionGeneratorViewController.m
//  MotionMe
//
//  Created by Akshar Bonu  on 6/24/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import "MotionGeneratorViewController.h"
#import "UserThatHasVoted+CreateUserThatHasVoted.h"
#import "DebateMotion+ParseDebateMotion.h"
#import "MessageUI/MessageUI.h"
#import "SubmitMotionViewController.h"

@interface MotionGeneratorViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *debateMotions; 

@end

@implementation MotionGeneratorViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"submitMotion"]) {
        SubmitMotionViewController *controller = [segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
    }
}

- (NSArray *) debateMotions
{
    if (!_debateMotions)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"DebateMotion" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError* error = nil;
        _debateMotions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }
    return _debateMotions;
}

- (IBAction)votingOnDisplayedMotion:(UIButton *)sender
{
    PFQuery *newQuery = [PFQuery queryWithClassName: @"debateMotion"];
    NSString *temporary = [NSString stringWithString:self.motionScoreLabel.text];
    self.motionScoreLabel.text = [NSString stringWithFormat:@"Contacting Server"];
    [newQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (error)
        {
            self.motionScoreLabel.text = [NSString stringWithFormat:@"An Error Occured"];
        }
        else
        {
            [newQuery whereKey: @"motionName" equalTo:self.motionTitleLabel.text];
            PFObject *motion = [newQuery getFirstObject];
            NSMutableArray* userList = [motion objectForKey: @"usersThatHaveVoted"];
            NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            int match = 0;
            if (motion)
            {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                fetchRequest.predicate = [NSPredicate predicateWithFormat: @"motionName = %@",self.motionTitleLabel.text];
                NSEntityDescription *entity = [NSEntityDescription
                                               entityForName:@"DebateMotion" inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                NSError* error = nil;
                NSArray* motionsFetched = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                DebateMotion* motionFetched = [motionsFetched lastObject];
                
                if ([sender.currentTitle isEqualToString: @"+"])
                {
                    if ([userList count] == 0)
                    {
                        NSNumber *currentscore = [motion objectForKey: @"numberOfUpVotes"];
                        [motion setObject:[NSNumber numberWithInt: 1 + [currentscore intValue]] forKey: @"numberOfUpVotes"];
                        sender.enabled = NO;
                      
                        self.minusButton.enabled = YES;
                       
                        [userList addObject: [identifier stringByAppendingFormat: @"+"]];
                        
                        motionFetched.numberOfUpVotes = [NSNumber numberWithInt: 1 + [currentscore intValue]];
                        motionFetched.usersThateHaveVoted = [[NSSet alloc] init];
                        for (NSString* user in userList)
                        {
                            [UserThatHasVoted userThatHasVotedWithNSString: user inManagedObjectContect: self.managedObjectContext forDebateMotion: motionFetched];
                        }
                        [motion setObject: userList forKey:@"usersThatHaveVoted"];
                    }
                    else
                    {
                        for (NSString* value in userList)
                        {
                            if ([value isEqualToString: [identifier stringByAppendingFormat: @"-"]])
                            {
                                
                                NSNumber *currentscore = [motion objectForKey: @"numberOfUpVotes"];
                                [motion setObject:[NSNumber numberWithInt: 1 + [currentscore intValue]] forKey: @"numberOfUpVotes"];
                                NSNumber *currentMinusScore = [motion objectForKey: @"numberOfDownVotes"];
                                [motion setObject:[NSNumber numberWithInt: [currentMinusScore intValue]-1] forKey: @"numberOfDownVotes"];
                                
                                NSString* identifierWithAppend = [identifier stringByAppendingFormat: @"-"];
                                [userList removeObject: identifierWithAppend];
                                [userList addObject: [identifier stringByAppendingFormat: @"+"]];
                                [motion setObject: userList forKey:@"usersThatHaveVoted"];
                                match = 0;
                                
                                motionFetched.numberOfUpVotes = [NSNumber numberWithInt: 1 + [currentscore intValue]];
                                motionFetched.numberOfDownVotes = [NSNumber numberWithInt: [currentMinusScore intValue]-1];
                                motionFetched.usersThateHaveVoted = [[NSSet alloc] init];
                                
                                for (NSString* user in userList)
                                {
                                    [UserThatHasVoted userThatHasVotedWithNSString: user inManagedObjectContect: self.managedObjectContext forDebateMotion: motionFetched];
                                }
                                
                                sender.enabled = NO;
                                self.minusButton.enabled = YES;
                                break;
                                
                            } else if ([value isEqualToString: [identifier stringByAppendingFormat: @"+"]]){
                                self.minusButton.enabled = YES;
                                self.plusButton.enabled = NO;
                                match = 0; 
                                break;
                            } else
                            {
                                match = 1;
                            }
                        }
                        if (match == 1)
                        {
                            NSNumber *currentscore = [motion objectForKey: @"numberOfUpVotes"];
                            [motion setObject:[NSNumber numberWithInt: 1 + [currentscore intValue]] forKey: @"numberOfUpVotes"];
                            sender.enabled = NO;
                            self.minusButton.enabled = YES;
                            [userList addObject: [identifier stringByAppendingFormat: @"+"]];
                            [motion setObject: userList forKey:@"usersThatHaveVoted"];
                            
                            motionFetched.numberOfUpVotes = [NSNumber numberWithInt: 1 + [currentscore intValue]];
                            motionFetched.usersThateHaveVoted = [[NSSet alloc] init];
                            for (NSString* user in userList)
                            {
                                [UserThatHasVoted userThatHasVotedWithNSString: user inManagedObjectContect: self.managedObjectContext forDebateMotion: motionFetched];
                            }
                        }
                    }
                }
                else
                {
                        if ([userList count] == 0)
                        {
                            NSNumber *currentscore = [motion objectForKey: @"numberOfDownVotes"];
                            [motion setObject:[NSNumber numberWithInt: 1 + [currentscore intValue]] forKey: @"numberOfDownVotes"];
                            sender.enabled = NO;
                            self.plusButton.enabled = YES;
                            [userList addObject: [identifier stringByAppendingFormat: @"-"]];
                            [motion setObject: userList forKey:@"usersThatHaveVoted"];
                            
                            motionFetched.numberOfDownVotes = [NSNumber numberWithInt: 1 + [currentscore intValue]];
                            
                            motionFetched.usersThateHaveVoted = [[NSSet alloc] init];
                            for (NSString* user in userList)
                            {
                                [UserThatHasVoted userThatHasVotedWithNSString: user inManagedObjectContect: self.managedObjectContext forDebateMotion: motionFetched];
                            }
                        }
                        else
                        {
                            for (NSString* value in userList)
                            {
                                if ([value isEqualToString: [identifier stringByAppendingFormat: @"-"]])
                                {
                                    self.minusButton.enabled = NO;
                                    
                                    self.plusButton.enabled = YES;
                                    
                                    match = 0; 
                                    break;
                                    
                                    
                                } else if ([value isEqualToString: [identifier stringByAppendingFormat: @"+"]]){
                                    NSNumber *currentscore = [motion objectForKey: @"numberOfDownVotes"];
                                    [motion setObject:[NSNumber numberWithInt: 1 + [currentscore intValue]] forKey: @"numberOfDownVotes"];
                                    sender.enabled = NO;
                                    
                                    self.plusButton.enabled = YES;
                                   
                                    NSNumber *currentPlusScore = [motion objectForKey: @"numberOfUpVotes"];
                                    [motion setObject:[NSNumber numberWithInt: [currentPlusScore intValue]-1] forKey: @"numberOfUpVotes"];
                                    NSString* identifierWithAppend = [identifier stringByAppendingFormat: @"+"];
                                    [userList removeObject: identifierWithAppend];
                                    [userList addObject: [identifier stringByAppendingFormat: @"-"]];
                                    [motion setObject: userList forKey:@"usersThatHaveVoted"];
                                    match = 0;
                                    
                                    motionFetched.numberOfUpVotes = [NSNumber numberWithInt: [currentPlusScore intValue]-1];
                                    motionFetched.numberOfDownVotes = [NSNumber numberWithInt: 1 + [currentscore intValue]];
                                    
                                    motionFetched.usersThateHaveVoted = [[NSSet alloc] init];
                                    for (NSString* user in userList)
                                    {
                                        [UserThatHasVoted userThatHasVotedWithNSString: user inManagedObjectContect: self.managedObjectContext forDebateMotion: motionFetched];
                                    }
                                    
                                    break;
                                } else
                                {
                                    match = 1;
                                }
                            }
                            if (match == 1)
                            {
                                
                                NSNumber *currentscore = [motion objectForKey: @"numberOfDownVotes"];
                                [motion setObject:[NSNumber numberWithInt: 1 + [currentscore intValue]] forKey: @"numberOfDownVotes"];
                                sender.enabled = NO;
                                
                                self.plusButton.enabled = YES;
                                
                                [userList addObject: [identifier stringByAppendingFormat: @"-"]];
                                [motion setObject: userList forKey:@"usersThatHaveVoted"];
                                
                                motionFetched.numberOfDownVotes = [NSNumber numberWithInt: 1 + [currentscore intValue]];
                                motionFetched.usersThateHaveVoted = [[NSSet alloc] init];
                                
                                for (NSString* user in userList)
                                {
                                    [UserThatHasVoted userThatHasVotedWithNSString: user inManagedObjectContect: self.managedObjectContext forDebateMotion: motionFetched];
                                }
                            }
                        }
                    }
                    [motion saveInBackground];
                    [self updateScore: motionFetched];
                }
            else
            {
                self.motionScoreLabel.text = [NSString stringWithString: temporary];
            }
            }
             
        }];
   
    }
     
     - (IBAction)generateRandomMotion
    {
        if (![self.debateMotions count])
        {
            self.motionScoreLabel.text = [NSString stringWithFormat:@"No motions"];
        }
        else
        {
            int r = arc4random() % [self.debateMotions count];
            DebateMotion *motion = self.debateMotions[r];
            self.motionTitleLabel.text = motion.motionName;
            self.sourceLabel.text = motion.source;
            [self updateScore: motion];
            NSSet* userList = motion.usersThateHaveVoted;
            if ([userList count] == 0)
            {
                self.minusButton.enabled = YES;
                
                self.plusButton.enabled = YES;
                
            }
            else
            {
                for (UserThatHasVoted* user in userList)
                {
                    NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                    if ([user.identifier isEqualToString: [identifier stringByAppendingFormat: @"-"]])
                    {
                        self.minusButton.enabled = NO;
                        
                        self.plusButton.enabled = YES;
                      
                        break;
                    } else if ([user.identifier isEqualToString: [identifier stringByAppendingFormat: @"+"]]){
                        self.minusButton.enabled = YES;
                        
                        self.plusButton.enabled = NO;
                       
                        break;
                    } else
                    {
                        self.minusButton.enabled = YES;
                        
                        self.plusButton.enabled = YES;
                        
                    }
                }
            }
            
        }
    }


- (void) updateScore: (DebateMotion*) motion
{
    if ([motion.numberOfUpVotes intValue] + [motion.numberOfDownVotes intValue] == 0)
    {
        self.motionScoreLabel.text = [NSString stringWithFormat:@"Unrated"];
    }
    else
    {
        float ratio = (float) [motion.numberOfUpVotes intValue]/([motion.numberOfUpVotes intValue] + [motion.numberOfDownVotes intValue]);
        float score = ratio*100;
        self.motionScoreLabel.text = [NSString stringWithFormat:@"%.1f%%",score];
    }
}


     - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        self.backgroundTextFieldSource.frame = CGRectInset(self.motionScoreLabel.frame, 0, -2);
        self.backgroundTextFieldMotion.frame = CGRectInset(self.backgroundTextViewMotion.frame, 0, -2);
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);
            
            if(result.height == 1136)
            {
                self.motionTitleLabel.text = @"\r\n\r\n\r\n\r\n\r\nPress Motion Me to begin debating";
            }
            else
            {
                self.motionTitleLabel.text = @"\r\n\r\n\r\n\r\nPress Motion Me to begin debating";
            }
        }
        
        self.sourceLabel.text = @"";
        if (self.managedObjectContext)
        {
            self.motionScoreLabel.text = [NSString stringWithFormat:@"%d motions", [self.debateMotions count]];
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

- (IBAction)updateAppDatabase
{
    self.motionScoreLabel.text = [NSString stringWithFormat:@"Updating Database"];
    PFQuery *newQuery = [PFQuery queryWithClassName: @"debateMotion"];
    newQuery.limit = 1000;
    [newQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            self.motionScoreLabel.text = [NSString stringWithFormat:@"An Error Occured"];
        }
        else
        {
            for (DebateMotion *motion in self.debateMotions)
            {
                [self.managedObjectContext deleteObject: motion];
            }
            for (PFObject *motion in objects)
            {
                [DebateMotion debateMotionWithParseObject:motion inManagedObjectContect:self.managedObjectContext];
            }
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"DebateMotion" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSError* error = nil;
            self.debateMotions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            self.motionScoreLabel.text = [NSString stringWithFormat:@"%d motions", [self.debateMotions count]];
        }
    }];
}

    - (void) updateDatabase
    {
        self.motionScoreLabel.text = [NSString stringWithFormat:@"Updating Database"];
        PFQuery *newQuery = [PFQuery queryWithClassName: @"debateMotion"];
        newQuery.limit = 1000;
        [newQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error)
            {
                self.motionScoreLabel.text = [NSString stringWithFormat:@"An Error Occured"];
            }
            else
            {
                for (DebateMotion *motion in self.debateMotions)
                {
                    [self.managedObjectContext deleteObject: motion];
                }
                for (PFObject *motion in objects)
                {
                    [DebateMotion debateMotionWithParseObject:motion inManagedObjectContect:self.managedObjectContext];
                }
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription
                                               entityForName:@"DebateMotion" inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                NSError* error = nil;
                self.debateMotions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                self.motionScoreLabel.text = [NSString stringWithFormat:@"%d Motions", [self.debateMotions count]];
            }
        }];
    }

- (IBAction)sendEmail:(UIButton *)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailcontroller = [[MFMailComposeViewController alloc] init];
        mailcontroller.mailComposeDelegate = self;
        NSArray *usersTo = [NSArray arrayWithObject: @"akshar.bonu@gmail.com"];
        [mailcontroller setToRecipients:usersTo];
        [mailcontroller setSubject: @"MotionMe Feedback"];
        [self presentViewController: mailcontroller animated:YES completion:nil];
        
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];

}


     - (void) viewWillAppear:(BOOL)animated
    {
        [super viewWillAppear: animated];
        
        self.motionScoreLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17.5];
        self.motionTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];
        self.sourceLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15];

        if (!self.managedObjectContext)
          {
              self.motionScoreLabel.text = [NSString stringWithFormat:@"Reaching Database"];
              NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
              url = [url URLByAppendingPathComponent:@"Core Data"];
              UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
              
              if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
                  [document saveToURL:url
                     forSaveOperation:UIDocumentSaveForCreating
                    completionHandler:^(BOOL success) {
                        if (success) {
                            self.managedObjectContext = document.managedObjectContext;
                            [self updateDatabase];
                        }
                    }];
              } else if (document.documentState == UIDocumentStateClosed) {
                  [document openWithCompletionHandler:^(BOOL success) {
                      if (success)
                      {
                          self.managedObjectContext = document.managedObjectContext;
                          NSString *temporary = [NSString stringWithString: self.motionScoreLabel.text];
                          if ([temporary rangeOfString: @"%"].location != NSNotFound)
                          {
                              self.motionScoreLabel.text = temporary;
                          }
                          else
                          {
                              self.motionScoreLabel.text = [NSString stringWithFormat:@"%d Motions", [self.debateMotions count]];
                          }
                          [self updateDatabase];
                      }
                  }];
              }
          }
        if (self.managedObjectContext)
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"DebateMotion" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSError* error = nil;
            NSArray* motions = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            if ([motions count] != [self.debateMotions count])
            {
                self.debateMotions = motions; 
            }
            
            NSString *temporary = [NSString stringWithString: self.motionScoreLabel.text];
            if ([temporary rangeOfString: @"%"].location != NSNotFound)
            {
                
            }
            else if([temporary rangeOfString: @"Unrated"].location != NSNotFound)
            {
                self.motionScoreLabel.text = temporary;
            }
            else
            {
                self.motionScoreLabel.text = [NSString stringWithFormat:@"%d Motions", [self.debateMotions count]];
            }
        }
        
    }
     
     - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }
     
     @end
