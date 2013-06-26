#import "OCMockObject+Lazy.h"

@implementation OCMockObject (Lazy)

- (void)verifyLazily
{
    [self verifyLazilyWithTimeout:1.0];
}

- (void)verifyLazilyWithTimeout:(NSTimeInterval)timeout
{
    NSTimeInterval interval = 0.1;
    NSDate *startedDate = [NSDate date];
    BOOL shouldContinue = YES;
    
    while (shouldContinue) {
        @autoreleasepool {
            shouldContinue = [[NSDate date] timeIntervalSinceDate:startedDate] < timeout;
            if (!shouldContinue || [self->expectations count] == 0) {
                [self verify];
            }
            
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
            [[NSRunLoop currentRunLoop] runUntilDate:date];
        }
    }
}

@end
