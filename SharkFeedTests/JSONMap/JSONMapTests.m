//
//  JSONMapTests.m
//  SharkFeed
//
//  Created by Avigit Saha on 2/22/16.
//  Copyright © 2016 Avigit Saha. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Company.h"
#import "NSObject+JSON.h"

@interface JSONMapTests : XCTestCase

@end

@implementation JSONMapTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (Person*)person
{
    Person *person = [[Person alloc] init];
    person.name = @"Avigit";
    Company *company1 = [[Company alloc] initWithName:@"GB" address:@"Research Dr"];
    Company *company2 = [[Company alloc] initWithName:@"iQmetrix" address:@"Cornowall St"];
    person.company = @[company1, company2];
    person.favColors = @[@"Blue", @"Black", @"Yellow"];
    return person;
}

- (void)testDeserialization
{
    // Json to Object
    Person *person = [self person];
    NSString *json = [person JSONString];
    
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    XCTAssertTrue([jsonDict[@"name"] isEqualToString:@"Avigit"]);
    NSArray *dictArray = jsonDict[@"company"];
    XCTAssertTrue([((NSDictionary*)dictArray[0])[@"name"] isEqualToString:@"GB"]);
    XCTAssertTrue([((NSDictionary*)dictArray[1])[@"name"] isEqualToString:@"iQmetrix"]);
    XCTAssertTrue([((NSDictionary*)dictArray[0])[@"address"] isEqualToString:@"Research Dr"]);
    XCTAssertTrue([((NSDictionary*)dictArray[1])[@"address"] isEqualToString:@"Cornowall St"]);
}

- (void)testSerialization
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"Person" ofType:@"json"];
    NSError *error;
    NSString *json = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
    } else {
        Person *person = [[Person alloc] initWithJSONData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        XCTAssertTrue([person isEqual:[self person]]);
    }
    
    // Array of persons
    filepath = [[NSBundle mainBundle] pathForResource:@"PersonArray" ofType:@"json"];
    json = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
    } else {
        NSArray *resultArray = [NSObject arrayOfClass:[Person class] JSONData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        Person *testPerson = [self person];
        XCTAssertTrue([resultArray[0] isEqual:testPerson]);
        testPerson.name = @"No Name";
        XCTAssertTrue([resultArray[1] isEqual:testPerson]);
    }
}

// Json to array
- (void)testJSONToArray
{
    NSString *json = @"[\"Blue\", \"Yellow\"]";
    
    NSArray *array = [NSObject arrayOfClass:nil JSONData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    XCTAssertTrue(([array[0] isEqualToString:@"Blue"] && [array[1] isEqualToString:@"Yellow"]));
}



@end
