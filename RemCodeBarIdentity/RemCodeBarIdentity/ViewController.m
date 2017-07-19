//
//  ViewController.m
//  RemCodeBarIdentity
//
//  Created by Alexander Devin on 19/07/2017.
//  Copyright © 2017 NLMK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *resultText;
@property (strong, nonatomic) NSMutableArray<REMMergedCell*> *mergedCells;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentPath = [[NSBundle mainBundle] pathForResource:@"input" ofType:@"xlsx"];
    BRAOfficeDocumentPackage *spreadSheet = [BRAOfficeDocumentPackage open:documentPath];
    
    BRAWorksheet *firstWorksheet = spreadSheet.workbook.worksheets[0];
    
    // Search
    long searchedIndex = -1;
    for (int i = 2; i < firstWorksheet.rows.count; i++) {
        BRARow *row = firstWorksheet.rows[i];
        BRACell *cell = row.cells[1];
        if ([cell.stringValue isEqualToString:@"40CLK5H116"]) {
            searchedIndex = row.rowIndex - 1;
            NSLog(@"rowIndex: %ld", (long)row.rowIndex - 1);
            break;
        }
    }
    
    BRARow *firstRow = firstWorksheet.rows[0];
    BRARow *secondRow = firstWorksheet.rows[1];
    BRARow *searchedRow = firstWorksheet.rows[searchedIndex];
    self.mergedCells = [NSMutableArray<REMMergedCell*> new];
    int currentIndex = 1;
    for (BRACell *cell in firstRow.cells) {
        if (cell.mergeCell != nil) {
            if (cell.mergeCell.leffColumnIndex == currentIndex) {
                REMMergedCell *mergedCell = [REMMergedCell new];
                mergedCell.title = cell.stringValue;
                [self.mergedCells addObject:mergedCell];
            }
        } else {
            REMMergedCell *mergedCell = [REMMergedCell new];
            mergedCell.title = cell.stringValue;
            [self.mergedCells addObject:mergedCell];
        }
        
        REMCell *remCell = [REMCell new];
        remCell.title = @"";
        for (BRACell *subCell in secondRow.cells) {
            if (subCell.columnIndex == currentIndex) {
                remCell.title = subCell.stringValue;
                break;
            }
        }
        remCell.content = @"";
        for (BRACell *subCell in searchedRow.cells) {
            if (subCell.columnIndex == currentIndex) {
                remCell.content = subCell.stringValue;
                break;
            }
        }
        
        [[self.mergedCells lastObject].cells addObject:remCell];
        
        currentIndex++;
    }
    
    NSLog(@"");
}

- (IBAction)scanButtonTapped:(id)sender {
    
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    
//    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//    
//    [self presentViewController:reader animated:YES completion:nil];
    
    
    [self performSegueWithIdentifier:@"details" sender:self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results) {
        break;
    }
    self.resultText.text = symbol.data;
    
    [picker dismissViewControllerAnimated:true completion:nil];
    
    [self performSegueWithIdentifier:@"details" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsTableViewController *vc = segue.destinationViewController;
    vc.mergedCells = self.mergedCells;
}

@end
