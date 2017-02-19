//
//  PPAPIManager.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPAPIManager.h"

NSString * const FLAPIManagerCurrentUserIDKey = @"FLNewAPIManagerCurrentUserIDKey";

@implementation PPAPIManager

+ (instancetype)shared {
    static PPAPIManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PPAPIManager alloc] init];
    });
    return _sharedInstance;
}

+ (FIRDatabaseReference *)firebaseRef {
    return [[FIRDatabase database] reference];
}

+ (NSString *)currentUserID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:FLAPIManagerCurrentUserIDKey];
}

- (void)createUser:(PPUser *)user completion:(void(^)(NSError *error))completion {
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=id,name,picture,gender" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSString *facebookID = [[FBSDKAccessToken currentAccessToken] userID];
             NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=400&height=400", [[FBSDKAccessToken currentAccessToken] userID]];
             
             
             PPUser *usr = [[PPUser alloc] initWithID:user.id name:user.name age:@"" gender:result[@"gender"] photoURL:userImageURL email:user.email phoneNumber:@"" location:@""];
             
             NSMutableDictionary *userDictionary = [[usr dictionaryRepresentation] mutableCopy];
             
             [[[[PPAPIManager firebaseRef] child:@"users"] child:user.id] setValue:userDictionary];
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:user.id forKey:FLAPIManagerCurrentUserIDKey];
             [defaults synchronize];
             
             completion(nil);
         }
         else{
             NSLog(@"Error with creating user: %@",error.localizedDescription);
             completion(nil);
         }
     }];
}



@end
