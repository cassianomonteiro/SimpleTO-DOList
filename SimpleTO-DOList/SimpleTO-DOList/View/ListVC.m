//
//  ListVC.m
//  SimpleTO-DOList
//
//  Created by Cassiano Monteiro on 19/10/16.
//  Copyright © 2016 Cassiano Monteiro. All rights reserved.
//

#import "ListVC.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addTapped:(UIBarButtonItem *)sender {
}

@end
