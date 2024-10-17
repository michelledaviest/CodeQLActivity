/**
 * @description Find all exported functions not called by any test
 * @kind problem
 * @id javascript/find-untested-exported-funs
 * @problem.severity recommendation
 */
import javascript

/**
 * Holds if a function is a test with a specified name.
 */
predicate isTest(Function test, Expr testName) {
  exists(CallExpr describe, CallExpr it |
    describe.getCalleeName() = "describe" and
    it.getCalleeName() = "it" and
    it.getParent*() = describe and
    test = it.getArgument(1) and
    testName = it.getArgument(0)
  )
}

/**
* Holds if `caller` contains a call to `callee`.
*/
predicate calls(Function caller, Function callee) {
  exists(DataFlow::CallNode call |
    call.getEnclosingFunction() = caller and
    call.getACallee() = callee
  )
}

predicate isTested(Function f) {
  exists(Function test |
  isTest(test, _) and
  calls(test, f)
  )
}

/**
* Holds if the given function is exported from a module.
*/
predicate isExportedFunction(Function f) {
  exists(Module m | m.getAnExportedValue(_).getAFunctionValue().getFunction() = f) and
  not f.inExternsFile()
}

from Function fun 
where isExportedFunction(fun) and
      not isTested(fun)
  select fun, "is an exported function that is not called by any test"