//
//  List+CoreDataProperties.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "List+CoreDataProperties.h"

@implementation List (CoreDataProperties)

+ (NSFetchRequest<List *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"List"];
}

@dynamic listId;
@dynamic name;
@dynamic items;

@end
