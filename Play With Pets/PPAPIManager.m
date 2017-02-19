//
//  PPAPIManager.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPAPIManager.h"

#define SERVER_URL @"https://playwithpets.herokuapp.com/send-request"
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
             
#warning lol age is hardcoded
             PPUser *usr = [[PPUser alloc] initWithID:user.id name:user.name age:@"18" gender:result[@"gender"] photoURL:userImageURL email:user.email phoneNumber:@"" location:user.location];
             
             NSMutableDictionary *userDictionary = [[usr dictionaryRepresentation] mutableCopy];
             
             [[[[PPAPIManager firebaseRef] child:@"users"] child:user.id] setValue:userDictionary];
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:user.id forKey:FLAPIManagerCurrentUserIDKey];
             [defaults synchronize];
             
             [PPAPIManager shared].currentUser = usr;

             completion(nil);
         }
         else{
             NSLog(@"Error with creating user: %@",error.localizedDescription);
             completion(nil);
         }
     }];
}

- (void)sendPlaydateRequestWithPet:(PPPet *)pet startTime:(NSString *)startTime endTime:(NSString *)endTime activity:(NSString *)activity activityLocation:(NSString *)activityLocation{
    NSURL *identityTokenURL = [NSURL URLWithString:SERVER_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *parameters = @{ @"user_id" : [PPAPIManager shared].currentUser.id,
                                  @"user_age" : [PPAPIManager shared].currentUser.age,
                                  @"user_name": [PPAPIManager shared].currentUser.name,
                                  @"user_location" : [PPAPIManager shared].currentUser.location,
                                  @"user_image": [PPAPIManager shared].currentUser.photoURL,
                                  @"user_email" : [PPAPIManager shared].currentUser.email,
                                  @"user_phone" : @"4086218608",//[PPAPIManager shared].currentUser.phoneNumber,
                                  @"pet_id" : pet.id,
                                  @"pet_image" : pet.photoURLs[0],
                                  @"pet_location" : pet.location,
                                  @"pet_name" : pet.name,
                                  @"pet_email" : pet.email,
                                  @"start_time" : startTime,
                                  @"end_time" : endTime,
                                  @"activity" : activity,
                                  @"activity_location" : activityLocation};
    
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    NSLog(@"sending post request with paramenters: %@", parameters);
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error: %@", error.description);
        } else {
            NSLog(@"Success, %@", response);
        }
    }] resume];


}



@end
