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

- (IBAction)reloadFile:(id)sender {
    
    // Request
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    NSString *urlString = @"http://nlmkdev.westeurope.cloudapp.azure.com/api/Files";
    NSURL *serverURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:serverURL.absoluteString parameters:nil error:nil];
    
    __block ServerFileModel *result = nil;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;

        if (error) {
            NSLog(@"");
        } else {
            NSArray *files = (NSArray*)responseObject;
            result = [EKMapper objectFromExternalRepresentation:files.firstObject withMapping:[ServerFileModel objectMapping]];
            
            // Download file
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSString *urlString = [result.fileURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            NSURL *URL = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                //return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                return [documentsDirectoryURL URLByAppendingPathComponent:@"input.xlsx"];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
            }];
            [downloadTask resume];
            
            NSLog(@"");
        }
        
        //completionHandler(result, response, responseObject, error);
    }];
    
    [dataTask resume];
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
