import Foundation

struct ExceptionTagged<T> {
	let value: T?
	let exception: NSException?
	func flush(flusher: NSException -> Void, defaultSupplier: @auto_closure () -> T) -> T {
		if let e = exception {
			flusher(e)
			return defaultSupplier()
		} else {
			return value!
		}
	}
	func extractExceptionInfo<T>(ty: T.Type) -> T? {
		if let e = exception {
			let vals = Array(e.userInfo.values)
			let typedVals = vals.filter({ $0 is T })
			if countElements(typedVals) == 1 {
				return typedVals[0] as? T
			}
		}
		return nil
	}
}

operator infix ⁉️ {}
@infix func ⁉️<T>(tagged: ExceptionTagged<T>, def: @auto_closure () -> T) -> T {
	return tagged.flush(logError, defaultSupplier: def)
}

func try<T>(action: Void -> T) -> ExceptionTagged<T> {
	var result: T? = nil
	if let e = tryCore({ () in result = action() }) {
		return ExceptionTagged(value: nil, exception: e)
	} else {
		return ExceptionTagged(value: result!, exception: nil)
	}
}

func throw(supplier: @auto_closure () -> NSException!) {
	throwCore(supplier)
}

func throw<T: AnyObject>(thing: T) {
	let thingName = reflect(T.self).summary
	let userInfo = ["asd" as NSObject: thing]
	throw(NSException(name: thingName, reason: thingName, userInfo: userInfo))
}

func logError(e: NSException) {
	println("Exception \(e)")
}

@objc class Test : NSObject {
	func thing() {
		let t = try { () -> Void in
			let v = try { () -> Int in
				throw(NSException(name: "Failure", reason: "Because", userInfo: nil))
				return 123
			}.flush(logError, defaultSupplier: -1)
			println(v)

			let v2 = try { () -> Int in return 555 } ⁉️ 5
			println(v2)
			throw("humpa")
		}
		if let e = t.extractExceptionInfo(NSString.self) {
			println("The message: \(e)")
		}
	}
}