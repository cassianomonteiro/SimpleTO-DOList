//
//  User.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 21/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "User.h"

@implementation User

+ (RKObjectMapping *)requestMapping
{
    // Create mapping object for this class
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"firebase_key" : @"firebaseKey"}];
    
    // User inverse mapping for object property -> json attribute
    return [mapping inverseMapping];
}

#pragma mark - Response Mapping

+ (RKObjectMapping *)responseMapping
{
    // Create mapping object for this class
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    // Map json attribute -> object property
    // Not mandatory to map all JSON attributes
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id"                         : @"userId",
                                                  @"attributes.firebase_key"    : @"firebaseKey"
                                                  }];
    return mapping;
}

@end
