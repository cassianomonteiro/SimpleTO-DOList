//
//  TestsManager.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 21/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "TestsManager.h"

@implementation TestsManager

+ (BOOL)setUp
{
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelAll];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    [RKManagedObjectStore setDefaultStore:[[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:[NSPersistentStoreCoordinator MR_defaultStoreCoordinator]]];
    [[RKManagedObjectStore defaultStore] createManagedObjectContexts];
    // Configure a managed object cache to ensure we do not create duplicate objects
    [RKManagedObjectStore defaultStore].managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:[RKManagedObjectStore defaultStore].persistentStoreManagedObjectContext];
    
    return ([RKManagedObjectStore defaultStore] != nil);
}

+ (BOOL)tearDown
{
    [RKManagedObjectStore setDefaultStore:nil];
    [MagicalRecord cleanUp];
    
    return ([RKManagedObjectStore defaultStore] == nil);
}

@end
