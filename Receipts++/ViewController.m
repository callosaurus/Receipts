//
//  ViewController.m
//  Receipts++
//
//  Created by Callum Davies on 2017-03-02.
//  Copyright © 2017 Callum Davies. All rights reserved.
//

#import "ViewController.h"
#import "NewReceiptController.h"
#import "ReceiptCell.h"
#import "Receipts__+CoreDataModel.h"

#import "AppDelegate.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *receiptsArray;
@property (nonatomic) NSArray *tagsArray;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *receiptTableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDel.managedObjectContext;
    self.coreDataManager = [CoreDataManager sharedInstance];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.coreDataManager fetchTags];
    [self.coreDataManager fetchReceipts];
    [self.receiptTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)fetchReceipt
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    NSError *readError;
//    
//    self.receiptsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&readError];
//    
//    NSLog(@"%@", self.receiptsArray);
//}

//-(void)createTags {
//    NSError *error;
//    
//    NSEntityDescription *tagEntityDescription = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
//    Tag *tag1 = [[Tag alloc] initWithEntity:tagEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
//    tag1.tagName = @"Personal";
//
//    Tag *tag2 = [[Tag alloc] initWithEntity:tagEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
//    tag2.tagName = @"Family";
//
//    Tag *tag3 = [[Tag alloc] initWithEntity:tagEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
//    tag3.tagName = @"Business";
//    
//    if (![self.managedObjectContext save:&error]) {
//        // Handle the error.
//    }
//    
//    [self fetchTags];
//    
//}

//-(void) fetchTags
//{
//    NSError *error;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:entity];
//    
//    NSArray *returnedArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    self.tagsArray = returnedArray;
//    
//    if (self.tagsArray == nil) {
//        // Handle the error.
//    }
//}

//- (void)createReceipt {
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
//    Receipt *receipt = [[Receipt alloc] initWithEntity:entityDescription
//                        insertIntoManagedObjectContext:self.managedObjectContext];
//    
//    receipt.amount = [@50 floatValue];;
//    receipt.note = @"Testing";
//    
//    NSError *createError = nil;
//    
//    if (![receipt.managedObjectContext save:&createError]) {
//        NSLog(@"Unable to save managed object context.");
//        NSLog(@"%@, %@", createError, createError.localizedDescription);
//    }
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addNewReceipt"]) {
        
        NewReceiptController *controller = [NewReceiptController new];
//        controller.managedObjectContext = self.managedObjectContext;
//        controller.tagsArray = self.tagsArray;
        controller = segue.destinationViewController;
        [self.receiptTableView reloadData];
    }
}

#pragma mark - Table View -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.coreDataManager.fetchedTags count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.receiptsArray.count;
    return [[self.coreDataManager fetchReceipts]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Receipt *receipt = [[self.coreDataManager fetchReceipts]objectAtIndex:indexPath.row];
//    Receipt *receipt = self.receiptsArray/*[indexPath.section]*/[indexPath.row];
    cell.noteLabel.text = receipt.note;
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f",receipt.amount];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Tag *tagSectionName = self.coreDataManager.fetchedTags[section];
    return tagSectionName.tagName;
}

@end
