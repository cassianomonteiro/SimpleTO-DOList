//
//  ListVC.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "ListVC.h"
#import "ItemVC.h"
#import "AlertControllerFactory.h"

static NSString *ListCellID = @"ListCell";

@interface ListVC ()

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSFetchRequest *fetchRequest = [List MR_createFetchRequest];
    fetchRequest.sortDescriptors = @[];
    self.fetchedResultsController = [List MR_fetchController:fetchRequest delegate:self useFileCache:NO groupedBy:nil inContext:[NSManagedObjectContext MR_defaultContext]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[ItemVC class]]) {
        List *selectedList = self.fetchedResultsController.fetchedObjects[self.tableView.indexPathForSelectedRow.row];
        ItemVC *destinationVC = segue.destinationViewController;
        destinationVC.selectedList = selectedList;
    }
}

#pragma mark - Actions

- (IBAction)addTapped:(UIBarButtonItem *)sender
{
    UIAlertController *alertController =
    [AlertControllerFactory textFieldAlertControllerWithTitle:@"Give a name to your list:"
                                               andPlaceHolder:@"Type here the list name"
                                            completionHandler:^(NSString *text) {
                                                [self createListWithName:text];
                                            }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)createListWithName:(NSString *)name
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        List *newList = [List MR_createEntityInContext:localContext];
        newList.name = name;
    }];
}

#pragma - mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ListCellID];
    }
    
    List *list = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    NSUInteger completedItems = [list.items filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"checked == YES"]].count;
    NSUInteger pendingItems = list.items.count - completedItems;
    
    NSString *itemsSummary = [NSString stringWithFormat:@"%lu completed item%@, %lu pending item%@",
                              completedItems, (completedItems == 1) ? @"" : @"s",
                              pendingItems, (pendingItems == 1) ? @"" : @"s"];
    
    cell.textLabel.text = list.name;
    cell.detailTextLabel.text = itemsSummary;
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self confirmDeletionOfList:self.fetchedResultsController.fetchedObjects[indexPath.row]];
    }
}

#pragma mark - Helpers

- (void)confirmDeletionOfList:(List *)listToDelete
{
    NSSet *pendingItems = [listToDelete.items filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"checked == NO"]];
    
    if (pendingItems.count > 0) {
        
        NSString *title = @"Uncompleted list!";
        NSString *message = [NSString stringWithFormat:@"The list %@ still has %ld pending items! Are you sure you want to delete it?", listToDelete.name, pendingItems.count];
        
        UIAlertController *deleteConfirmation =
        [AlertControllerFactory deleteAlertControllerWithTitle:title
                                                    andMessage:message
                                               deletionHandler:^{
                                                   [self deleteList:listToDelete];
                                               } cancelHandler:^{
                                                   self.tableView.editing = NO;
                                               }];
        
        [self presentViewController:deleteConfirmation animated:YES completion:nil];
    }
    else {
        [self deleteList:listToDelete];
    }
}

- (void)deleteList:(List *)listToDelete
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        [listToDelete MR_deleteEntityInContext:localContext];
    }];
}

@end
