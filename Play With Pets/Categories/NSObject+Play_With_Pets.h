//
//  NSObject+Play_With_Pets.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Play_With_Pets)

- (PMKPromise *)promiseForKey:(NSString *)key;
- (PMKPromise *)newPromiseForKey:(NSString *)key;
- (void)fulfill:(id)result
         forKey:(NSString *)key;
- (void)reject:(NSError *)error
        forKey:(NSString *)key;
- (void)fulfill:(id)result;
- (void)reject:(NSError *)error;

- (PMKPromise *)promise;

- (NSDictionary *)dictionaryRepresentation;

@end
