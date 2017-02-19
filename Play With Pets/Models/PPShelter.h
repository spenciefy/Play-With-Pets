//
//  PPShelter.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPShelter : NSObject

@property NSString *id;
@property NSString *name;
@property NSString *address;
@property NSString *email;
@property NSString *phoneNumber;

- (id)initWithID:(NSString *)id name:(NSString *)name address:(NSString *)address email:(NSString *)email phoneNumber:(NSString *)phoneNumber;

@end
