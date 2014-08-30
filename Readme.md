```Swift
var in_stupid_situation = false
func compute() -> Int {
	let v = try { () -> Int in
		if in_stupid_situation {
			throw (NSException(name: "asd", reason: "dsa", userInfo: nil))
		}
		return 123
	}
	return v.flush(println, defaultSupplier: -1)
}
println(compute())
in_stupid_situation = true
println(compute())
```

Just some dabbling to implement exception catching in Swift. Actual throwing/catching performed by Objective-C functions making use of @try/@throw while the API exposed to Swift allows for passing in a function to execute inside a @try block and getting the result of applying the function as a struct of generic type ExceptionTagged<T> which either contains the result of the computation or an exception if @throw was called inside it.

The exception can be processed and discarded by a method of ExceptionTagged<T> called flush() taking a closure for processing the exception that potentially occured and a closure returning a default value of type T to use in case of exception.

Additionally, some convenience method on ExceptionTagged<T> allows for extracting a specific type of information from the NSException's userInfo: extractExceptionInfo.
