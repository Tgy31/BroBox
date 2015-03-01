//
//  BBParseMessage.m
//  BroBox
//
//  Created by Tanguy Hélesbeux on 01/03/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBParseMessage.h"

@implementation BBParseMessage

@dynamic mission;
@dynamic author;
@dynamic content;

@synthesize attachment = _attachment;

- (void)setAttachment:(UIImage *)attachment {
    _attachment = attachment;
}

- (UIImage *)attachment {
    return _attachment;
}


#pragma mark - Parse subclassing

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BBParseMessage";
}

@end
