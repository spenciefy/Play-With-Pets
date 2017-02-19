//
//  PPUser.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPUser.h"

@implementation PPUser

- (id)initWithID:(NSString *)id name:(NSString *)name age:(NSString *)age gender:(NSString *)gender photoURL:(NSString *)photoURL email:(NSString *)email phoneNumber:(NSString *)phoneNumber location:(NSString *)location lat:(NSString *)lat lng:(NSString *)lng {
    self = [super init];
    
    if(self) {
        self.id = id;
        self.name = name;
        self.age = age;
        self.gender = gender;
        self.photoURL = photoURL;
        self.email = email;
        self.phoneNumber = phoneNumber;
        self.location = location;
        self.lat = lat;
        self.lng = lng;
    }
    
    return self;
}

+ (void)getUserWithID:(NSString *)userID completion:(void(^)(PPUser *user))completion
{
    [[[[PPAPIManager firebaseRef] child:@"users"] child:userID] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if(snapshot.value != [NSNull null]) {
            
            PPUser *user = [[PPUser alloc] initWithID:snapshot.value[@"id"] name:snapshot.value[@"name"] age:snapshot.value[@"age"] gender:snapshot.value[@"gender"] photoURL:snapshot.value[@"photoURL"] email:snapshot.value[@"email"] phoneNumber:snapshot.value[@"phoneNumber"] location:snapshot.value[@"location"] lat:snapshot.value[@"lat"] lng:snapshot.value[@"lng"]];
            
            completion(user);
        } else {
            completion(nil);
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        completion(nil);
    }];
}

@end
