#import <SenTestingKit/SenTestingKit.h>
#import "OCMockObject+Lazy.h"

@interface OCTestObject : NSObject
- (void)foo;
- (void)bar:(OCTestObject *)target;
@end

@implementation OCTestObject
- (void)foo {}
- (void)bar:(OCTestObject *)target
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [target foo];
    });
}
@end


@interface OCMockObjectLazyTests : SenTestCase {
    id object;
    id mock;
}

@end

@implementation OCMockObjectLazyTests

- (void)setUp
{
    [super setUp];
    
    object = [[OCTestObject alloc] init];
    mock = [OCMockObject mockForClass:[OCTestObject class]];
}

- (void)tearDown
{
    object = nil;
    mock = nil;
    
    [super tearDown];
}

- (void)testWait
{
    [[mock expect] foo];
    [object performSelector:@selector(bar:) withObject:mock afterDelay:0.5];
    
    STAssertNoThrow([mock verifyLazily], @"mock did not wait for invocation.");
}

- (void)testTimeout
{
    [[mock expect] foo];
    [object performSelector:@selector(bar:) withObject:mock afterDelay:2.0];
    
    STAssertThrows([mock verifyLazily], @"mock did not timeout.");
    
}

@end
