//
//  DebateMotion+ParseDebateMotion.m
//  MotionMe
//
//  Created by Akshar Bonu  on 7/19/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import "DebateMotion+ParseDebateMotion.h"
#import <Parse/Parse.h>
#import "UserThatHasVoted+CreateUserThatHasVoted.h"

@implementation DebateMotion (ParseDebateMotion)

+ (DebateMotion *) debateMotionWithParseObject: (PFObject *) debateMotionFromParse inManagedObjectContect: (NSManagedObjectContext*) context
{
    DebateMotion* debateMotion = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: @"DebateMotion"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey: @"motionName" ascending: YES]];
    request.predicate = [NSPredicate predicateWithFormat: @"objectId = %@",debateMotionFromParse.objectId];
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];

    if (!matches || [matches count] >1)
    {
    }
    else if (![matches count])
    {
         
        debateMotion = [NSEntityDescription insertNewObjectForEntityForName: @"DebateMotion" inManagedObjectContext:context];
        debateMotion.createdAt = debateMotionFromParse.createdAt;
        debateMotion.motionName = [debateMotionFromParse objectForKey: @"motionName"];
        debateMotion.numberOfDownVotes = [debateMotionFromParse objectForKey: @"numberOfDownVotes"];
        debateMotion.numberOfUpVotes = [debateMotionFromParse objectForKey: @"numberOfUpVotes"];
        debateMotion.objectId = debateMotionFromParse.objectId;
        debateMotion.source = [debateMotionFromParse objectForKey: @"source"];
        debateMotion.updatedAt = debateMotionFromParse.updatedAt;
        NSSet *usersThatHavedVoted = [NSSet setWithArray: [debateMotionFromParse objectForKey: @"usersThatHaveVoted"]];
        for (NSString* user in usersThatHavedVoted)
        {
           [UserThatHasVoted userThatHasVotedWithNSString: user inManagedObjectContect:context forDebateMotion: debateMotion];
        }
    }
    else
    {
        debateMotion = [matches lastObject];
    }
    return debateMotion; 
}

@end
