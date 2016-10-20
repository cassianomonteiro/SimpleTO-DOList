//
//  ItemVC.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "ItemVC.h"
#import "AlertControllerFactory.h"

static NSString *ItemCellID = @"ItemCell";

@interface ItemVC ()

@end

@implementation ItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.selectedList.name;
    
    self.fetchedResultsController = [Item MR_fetchAllSortedBy:nil ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"list = %@", self.selectedList] groupBy:nil delegate:self];
}

- (IBAction)addTapped:(UIBarButtonItem *)sender
{
    UIAlertController *alertController =
    [AlertControllerFactory textFieldAlertControllerWithTitle:@"What do you need to do?"
                                               andPlaceHolder:@"Type here what to do"
                                            completionHandler:^(NSString *text) {
                                                [self createItemWithDescription:text];
                                            }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createItemWithDescription:(NSString *)description
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        Item *newItem = [Item MR_createEntityInContext:localContext];
        newItem.itemDescription = description;
        newItem.list = [localContext objectWithID:self.selectedList.objectID];
        newItem.checked = NO;
    }];
}

#pragma - mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ItemCellID];
    }
    
    Item *item = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = item.itemDescription;
    cell.accessoryType = item.checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

@end
