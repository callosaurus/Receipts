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


@end

@implementation NewReceiptController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedTags = [[NSMutableSet alloc]init];
    
}

- (IBAction)doneButtonPressed:(UIButton *)sender {
    
    //make new receipt
    Receipt *newReceipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *receiptAmount = [numFormatter numberFromString:self.amountTextField.text];
    
    newReceipt.amount = [receiptAmount floatValue];
    newReceipt.note = self.descriptionTextField.text;
    newReceipt.timeStamp = self.datePicker.date;
    newReceipt.receiptToTag = self.selectedTags;
    
    NSError *error;
    if (![self.managedObjectContext save:&error]){
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    Tag *tag = self.tagsArray[indexPath.row];
    
    UILabel *textLabel = [UILabel new];
    [cell addSubview: textLabel];
    
    cell.textLabel.text = tag.tagName;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tagsArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
    
    Tag *selectedTag = self.tagsArray[indexPath.row];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [self.selectedTags addObject:selectedTag];
    } else {
        [self.selectedTags removeObject:selectedTag];
    }
}


@end
