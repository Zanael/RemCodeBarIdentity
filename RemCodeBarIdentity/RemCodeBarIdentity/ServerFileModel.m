//
//  ServerFileModel.m
//  RemCodeBarIdentity
//
//  Created by Alexander Devin on 19/07/2017.
//  Copyright © 2017 NLMK. All rights reserved.
//

#import "ServerFileModel.h"

@implementation ServerFileModel

+(EKObjectMapping *)objectMapping {
    
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{
                                               @"$id" : @"recordId",
                                               @"File_ID" : @"fileId",
                                               @"File_URL" : @"fileURL",
                                               @"File_Name" : @"fileName",
                                               @"File_ServerPath" : @"fileServerPath",
                                               @"File_UpdateDate" : @"fileUpdateDate"
                                               }];
    }];
}

@end
