//
//  ItemVCTests.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ItemVC.h"

@interface ItemVCTests : XCTestCase
@property (nonatomic, strong) ItemVC *viewController;
@end

@implementation ItemVCTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"ItemVC"];
    
    // Initialize and test view at the same time
    XCTAssertNotNil(self.viewController.view);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [MagicalRecord cleanUp];
}


#pragma mark - Initialization tests

- (void)testOutletsAndDelegatesShouldBeLoaded
{
    // Given
    // initial state
    
    // Then
    
    // Outlets should be set
    XCTAssertNotNil(self.viewController.tableView);
    XCTAssertNotNil(self.viewController.addButton);
    
    // Delegates should be set
    XCTAssertNotNil(self.viewController.tableView.dataSource);
    XCTAssertNotNil(self.viewController.tableView.delegate);
    
    // Actions should be set
    XCTAssertEqual(self.viewController.addButton.target, self.viewController);
    XCTAssertEqual(self.viewController.addButton.action, @selector(addTapped:));
}

- (void)testViewDidLoadShouldSetupTableView
{
    // Given
    XCTAssertEqualObjects([List MR_numberOfEntities], @0);
    XCTAssertEqualObjects([Item MR_numberOfEntities], @0);
    List *list = [List MR_createEntity];
    [list addItemsObject:[Item MR_createEntity]];
    List *otherList = [List MR_createEntity];
    [otherList addItemsObject:[Item MR_createEntity]];
    [otherList addItemsObject:[Item MR_createEntity]];
    XCTAssertEqualObjects([List MR_numberOfEntities], @2);
    XCTAssertEqualObjects([Item MR_numberOfEntities], @3);
    
    // When
    self.viewController.selectedList = otherList;
    [self.viewController viewDidLoad];
    
    // Then
    XCTAssertEqual([self.viewController numberOfSectionsInTableView:self.viewController.tableView], 1);
    XCTAssertEqual([self.viewController tableView:self.viewController.tableView numberOfRowsInSection:0], 2);
}

- (void)testViewDidLoadShouldSetTitle
{
    // Given
    List *list = [List MR_createEntity];
    list.name = @"My list";
    self.viewController.selectedList = list;
    
    // When
    [self.viewController viewDidLoad];
    
    // Then
    XCTAssertEqualObjects(self.viewController.title, list.name);
}

@end
