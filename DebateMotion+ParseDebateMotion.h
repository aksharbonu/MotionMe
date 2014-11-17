//
//  DebateMotion+ParseDebateMotion.h
//  MotionMe
//
//  Created by Akshar Bonu  on 7/19/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import "DebateMotion.h"
#import <Parse/Parse.h>

@interface DebateMotion (ParseDebateMotion)

+ (DebateMotion *) debateMotionWithParseObject: (PFObject *) debateMotionFromParse inManagedObjectContect: (NSManagedObjectContext*) context;

@end
