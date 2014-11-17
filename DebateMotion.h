//
//  DebateMotion.h
//  MotionMe
//
//  Created by Akshar Bonu  on 7/19/13.
//  Copyright (c) 2013 Akshar Bonu . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserThatHasVoted;

@interface DebateMotion : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * motionName;
@property (nonatomic, retain) NSNumber * numberOfDownVotes;
@property (nonatomic, retain) NSNumber * numberOfUpVotes;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *usersThateHaveVoted;
@end

@interface DebateMotion (CoreDataGeneratedAccessors)

- (void)addUsersThateHaveVotedObject:(UserThatHasVoted *)value;
- (void)removeUsersThateHaveVotedObject:(UserThatHasVoted *)value;
- (void)addUsersThateHaveVoted:(NSSet *)values;
- (void)removeUsersThateHaveVoted:(NSSet *)values;

@end
