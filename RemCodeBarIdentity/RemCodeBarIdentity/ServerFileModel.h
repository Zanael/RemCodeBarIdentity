//
//  ServerFileModel.h
//  RemCodeBarIdentity
//
//  Created by Alexander Devin on 19/07/2017.
//  Copyright © 2017 NLMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKMappingProtocol.h"
#import "EKObjectMapping.h"

@interface ServerFileModel : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *fileURL;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileServerPath;
@property (nonatomic, copy) NSString *fileUpdateDate;

@end
