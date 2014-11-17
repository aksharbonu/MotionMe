//
//  UserThatHasVoted+CreateUserThatHasVoted.m
//  MotionMe
//
//  Created by Akshar Bonu  on 7/19/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import "UserThatHasVoted+CreateUserThatHasVoted.h"

@implementation UserThatHasVoted (CreateUserThatHasVoted)

+ (void) userThatHasVotedWithNSString: (NSString *) user inManagedObjectContect: (NSManagedObjectContext*) context forDebateMotion: (DebateMotion*) debatemotion
{
    UserThatHasVoted* userVote = nil;
    userVote = [NSEntityDescription insertNewObjectForEntityForName: @"UserThatHasVoted" inManagedObjectContext:context];
    userVote.identifier = user;
    userVote.whoVoted = debatemotion;
}

@end
