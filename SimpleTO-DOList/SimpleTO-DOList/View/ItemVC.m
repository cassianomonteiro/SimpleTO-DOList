//
//  ItemVC.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "ItemVC.h"
#import "AlertControllerFactory.h"
#import <FontAwesomeIconFactory.h>

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
                                                      andText:nil
                                               andPlaceHolder:@"Type here what to do"
                                                   actionName:@"Create"
                                            completionHandler:^(NSString *text) {
                                                [self createItemWithDescription:text];
                                            }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma - mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ItemCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ItemCellID];
    }
    
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory buttonIconFactory];
    factory.size = 24.f;
    factory.colors = @[[UIColor blackColor]];
    
    Item *item = self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = item.itemDescription;
    cell.imageView.image = [factory createImageForIcon:item.checked ? NIKFontAwesomeIconCheckSquareO : NIKFontAwesomeIconSquareO];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *itemToCheck = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [self checkItem:itemToCheck];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Item *selectedItem = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    UIAlertController *alertController =
    [AlertControllerFactory textFieldAlertControllerWithTitle:@"Edit to-do item"
                                                      andText:selectedItem.itemDescription
                                               andPlaceHolder:@"Type here the item description"
                                                   actionName:@"Save"
                                            completionHandler:^(NSString *text) {
                                                [self updateItem:selectedItem withDescription:text];
                                            }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Item *itemToDelete = self.fetchedResultsController.fetchedObjects[indexPath.row];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            [itemToDelete MR_deleteEntityInContext:localContext];
        }];
    }
}

#pragma mark - CRUD

- (void)createItemWithDescription:(NSString *)description
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        Item *newItem = [Item MR_createEntityInContext:localContext];
        newItem.itemDescription = description;
        newItem.list = [self.selectedList MR_inContext:localContext];
        newItem.checked = NO;
    }];
}

- (void)checkItem:(Item *)item
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        Item *itemToSave = [item MR_inContext:localContext];
        itemToSave.checked = !itemToSave.checked;
    }];
}

- (void)updateItem:(Item *)item withDescription:(NSString *)description
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        Item *itemToSave = [item MR_inContext:localContext];
        itemToSave.itemDescription = description;
    }];
}

@end
