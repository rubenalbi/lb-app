//
//  StopServiceTests.m
//  BusLondon
//
//  Created by Ruben Albiach on 30/01/2016.
//  Copyright © 2016 Rubén Albiach. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StopService.h"

@interface StopServiceTests : XCTestCase

@property (nonatomic) StopService *stopServiceToTest;

@end

@implementation StopServiceTests

- (void)setUp {
    [super setUp];
    self.stopServiceToTest = [[StopService alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReverseString {
    NSString *originalString = @"himynameisandy";
    NSString *expected = @"himynameisandy";
    
    
    NSLog(@"stop %ld", 1454148882000);
    NSLog(@"time to stop %f", (([[NSDate date] timeIntervalSince1970]) - 1454148882000/1000) /60);
    
    
    XCTAssertEqualObjects(originalString, expected, @"Teverse string test failed");
}

@end
