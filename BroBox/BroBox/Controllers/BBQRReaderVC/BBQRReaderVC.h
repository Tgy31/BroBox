//
//  BBQRReaderVC.h
//  BroBox
//
//  Created by Tanguy Hélesbeux on 15/02/2015.
//  Copyright (c) 2015 Brobox. All rights reserved.
//

#import "BBViewController.h"

#import "BBParseMission.h"

@protocol BBQRReaderDelegate;


typedef NS_ENUM(NSInteger, BBQRReaderType) {
    BBQRReaderTypePickUp,
    BBQRReaderTypeDropOff
};

@interface BBQRReaderVC : BBViewController

@property (weak, nonatomic) id<BBQRReaderDelegate> delegate;

@property (strong, nonatomic) BBParseMission *mission;
@property (nonatomic) BBQRReaderType type;

@end


@protocol BBQRReaderDelegate <NSObject>

- (void)QRReaderDidSucced:(BBQRReaderVC *)readerVC;


@end
