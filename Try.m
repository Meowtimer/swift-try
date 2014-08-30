#import "Try.h"

NSException* tryCore(Action action) {
	@try {
		action();
		return nil;
	} @catch (NSException *e) {
		return e;
	}
}

void throwCore(ExceptionSupplier supplier) {
	@throw supplier();
}