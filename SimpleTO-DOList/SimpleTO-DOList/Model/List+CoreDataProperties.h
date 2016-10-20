//
//  List+CoreDataProperties.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "List+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface List (CoreDataProperties)

+ (NSFetchRequest<List *> *)fetchRequest;

@property (nonatomic) int64_t listId;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Item *> *items;

@end

@interface List (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet<Item *> *)values;
- (void)removeItems:(NSSet<Item *> *)values;

@end

NS_ASSUME_NONNULL_END
