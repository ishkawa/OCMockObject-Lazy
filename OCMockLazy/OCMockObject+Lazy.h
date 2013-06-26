#import <OCMock/OCMock.h>

@interface OCMockObject (Lazy)

- (void)verifyLazily;
- (void)verifyLazilyWithTimeout:(NSTimeInterval)timeout;

@end
