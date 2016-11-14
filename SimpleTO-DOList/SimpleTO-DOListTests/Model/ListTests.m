//
//  ListTests.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 21/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/Testing.h>
#import "TestsManager.h"
#import "List+CoreDataProperties.h"

@interface ListTests : XCTestCase
@property (nonatomic, strong) List *list;
@end

@implementation ListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    XCTAssertTrue([TestsManager setUp]);
    
    // Configure RKTestFixture
    [RKTestFixture setFixtureBundle:[NSBundle bundleForClass:[self class]]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    XCTAssertTrue([TestsManager tearDown]);
}

- (void)testResponseMapping
{
    // Given
    id parsedJSON = [RKTestFixture parsedObjectWithContentsOfFixture:@"List.json"];
    self.list = [List MR_createEntity];
    RKMappingTest *mappingTest = [RKMappingTest testForMapping:[List responseMapping] sourceObject:parsedJSON destinationObject:self.list];
    mappingTest.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    // When
    [mappingTest performMapping];
    
    // Then
    XCTAssertEqual(self.list.listId, 1);
    XCTAssertEqualObjects(self.list.name, @"Boring stuffs");
}

@end
