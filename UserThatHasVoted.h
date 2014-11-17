//
//  UserThatHasVoted.h
//  MotionMe
//
//  Created by Akshar Bonu  on 7/19/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DebateMotion;

@interface UserThatHasVoted : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) DebateMotion *whoVoted;

@end
