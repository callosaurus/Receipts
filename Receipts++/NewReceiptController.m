//
//  NewReceiptController.m
//  Receipts++
//
//  Created by Callum Davies on 2017-03-02.
//  Copyright © 2017 Callum Davies. All rights reserved.
//

#import "NewReceiptController.h"
#import "Receipts__+CoreDataModel.h"

@interface NewReceiptController () <UITextFieldDelegate, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (nonatomic, strong) NSMutableSet<Tag*> *selectedTags;

@property (nonatomic) Receipt *receiptToAdd;

@end

@implementation NewReceiptController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coreDataManager = [CoreDataManager sharedInstance];
    self.selectedTags = [[NSMutableSet alloc]init];
    [self.tagTableView reloadData];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.amountTextField) {
        [self.amountTextField resignFirstResponder];
    } else if (textField == self.descriptionTextField) {
        [self.descriptionTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table View -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell" forIndexPath:indexPath];
    Tag *tag = self.coreDataManager.fetchedTags[indexPath.row];
    
    UILabel *textLabel = [UILabel new];
    [cell addSubview: textLabel];
    cell.textLabel.text = tag.tagName;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.coreDataManager.fetchedTags.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    Tag *selectedTag = self.coreDataManager.fetchedTags[indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.selectedTags addObject:selectedTag];
    } else {
        [self.selectedTags removeObject:selectedTag];
    }
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.coreDataManager.managedObjectContext];
    self.receiptToAdd = [[Receipt alloc] initWithEntity:entity insertIntoManagedObjectContext:self.coreDataManager.managedObjectContext];
    
    //make new receipt
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *receiptAmount = [numFormatter numberFromString:self.amountTextField.text];
    
    self.receiptToAdd.amount = [receiptAmount floatValue];
    self.receiptToAdd.note = self.descriptionTextField.text;
    self.receiptToAdd.timeStamp = self.datePicker.date;
    
    NSArray *tagArray = [self.selectedTags allObjects];
    for (Tag *tag in tagArray) {
        [self.receiptToAdd setValue:tag forKey:@"receiptToTag"];
    }
    
//    self.receiptToAdd.receiptToTag = self.selectedTags;
    
//    NSError *error;
//    if (![self.managedObjectContext save:&error]){
//        
//    }
    
        [self.coreDataManager.managedObjectContext save:nil];
     
         
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
