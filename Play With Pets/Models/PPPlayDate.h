//
//  PPPlayDate.h
//  Play With Pets
//
//  Created by Spencer Yen on 2/19/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPPlayDate : NSObject

@property NSString *id;
@property NSString *status;
@property PPPet *pet;
@property NSString *time;
@property NSString *activity;
@property NSString *location;
@property NSString *shelterPhoneNumber;
@property NSString *shelterName;

- (id)initWithID:(NSString *)id pet:(PPPet *)pet status:(NSString *)status time:(NSString *)time activity:(NSString *)activity location:(NSString *)location shelterPhoneNumber:(NSString *)shelterPhoneNumber shelterName:(NSString *)shelterName;

+ (PPPlayDate *)playdateFromFirebaseDictionary:(NSDictionary *)playdateDict id:(NSString *)id;

@end
