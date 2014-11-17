//
//  UserThatHasVoted+CreateUserThatHasVoted.h
//  MotionMe
//
//  Created by Akshar Bonu  on 7/19/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import "UserThatHasVoted.h"

@interface UserThatHasVoted (CreateUserThatHasVoted)

+ (void) userThatHasVotedWithNSString: (NSString *) user inManagedObjectContect: (NSManagedObjectContext*) context forDebateMotion: (DebateMotion*) debatemotion;

@end
