#import <Cocoa/Cocoa.h>

typedef void (^Action)();
typedef NSException* (^ExceptionSupplier)();

NSException* tryCore(Action action);
void throwCore(ExceptionSupplier supplier);