//
//  PPShelter.m
//  Play With Pets
//
//  Created by Spencer Yen on 2/18/17.
//  Copyright © 2017 Spencer Yen. All rights reserved.
//

#import "PPShelter.h"

@implementation PPShelter

- (id)initWithID:(NSString *)id name:(NSString *)name address:(NSString *)address email:(NSString *)email phoneNumber:(NSString *)phoneNumber {
    self = [super init];
    
    if(self) {
        self.id = id;
        self.name = name;
        self.address = address;
        self.email = email;
        self.phoneNumber = phoneNumber;
    }
    
    return self;

}

@end
