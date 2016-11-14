//
//  List+CoreDataClass.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "List+CoreDataClass.h"
#import "Item+CoreDataClass.h"

@implementation List

+ (RKEntityMapping *)responseMapping
{
    // Create mapping object for this class
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:[self MR_entityName] inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    mapping.identificationAttributes = @[@"listId"];
    
    
    // Map json attribute -> object property
    // Not mandatory to map all JSON attributes
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id"                 : @"listId",
                                                  @"attributes.title"   : @"name",
                                                  }];
    
    return mapping;
}

@end
