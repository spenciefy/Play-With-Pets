//
//  PPAPIManager.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPUser;
@class PPPet;

@interface PPAPIManager : NSObject

@property PPUser *currentUser;

+ (instancetype)shared;

+ (FIRDatabaseReference *)firebaseRef;

+ (NSString *)currentUserID;

- (void)createUser:(PPUser *)user completion:(void(^)(NSError *error))completion;

- (void)sendPlaydateRequestWithPet:(PPPet *)pet startTime:(NSString *)startTime endTime:(NSString *)endTime activity:(NSString *)activity activityLocation:(NSString *)activityLocation;


@end
