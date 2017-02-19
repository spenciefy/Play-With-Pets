//
//  PPUser.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPUser : NSObject

@property NSString *id;
@property NSString *name;
@property NSString *age;
@property NSString *gender;
@property NSString *photoURL;
@property NSString *email;
@property NSString *phoneNumber;
@property NSString *location;
@property NSString *lat;
@property NSString *lng;


- (id)initWithID:(NSString *)id name:(NSString *)name age:(NSString *)age gender:(NSString *)gender photoURL:(NSString *)photoURL email:(NSString *)email phoneNumber:(NSString *)phoneNumber location:(NSString *)location lat:(NSString *)lat lng:(NSString *)lng;

+ (void)getUserWithID:(NSString *)userID completion:(void(^)(PPUser *user))completion;

@end
