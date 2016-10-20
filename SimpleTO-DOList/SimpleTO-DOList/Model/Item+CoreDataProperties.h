//
//  Item+CoreDataProperties.h
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nonatomic) BOOL checked;
@property (nonatomic) int64_t itemId;
@property (nullable, nonatomic, copy) NSString *itemDescription;
@property (nullable, nonatomic, retain) List *list;

@end

NS_ASSUME_NONNULL_END
