//
//  ListVCTests.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ListVC.h"

@interface ListVCTests : XCTestCase
@property (nonatomic, strong) ListVC *viewController;

@end

@implementation ListVCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"ListVC"];
    
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
    [List MR_createEntity];
    XCTAssertEqualObjects([List MR_numberOfEntities], @1);
    
    // When
    [self.viewController viewDidLoad];
    
    // Then
    XCTAssertEqual([self.viewController numberOfSectionsInTableView:self.viewController.tableView], 1);
    XCTAssertEqual([self.viewController tableView:self.viewController.tableView numberOfRowsInSection:0], 1);
}

@end
