/**
 * @description Find all public methods directly invoked from a test
 * @kind problem
 * @id javascript/find-tested-public-methods
 * @problem.severity recommendation
 */

import javascript

/**
 * Holds if a function is a test with a specified name.
 */
predicate isTest(Function test) {
  exists(CallExpr describe, CallExpr it |
    describe.getCalleeName() = "describe" and
    it.getCalleeName() = "it" and
    it.getParent*() = describe and
    test = it.getArgument(1) 
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

/**
 * Holds if `f` is called by a test with a specified name.
 
 */
predicate isTested(Function f) {
  exists(Function test |
  isTest(test) and
  calls(test, f)
  )
}

/**
* Holds if the given function is a public method of a class.
*/
predicate isPublicMethod(Function f) {
  exists(MethodDefinition md | md.isPublic() and md.getBody() = f)
}

from Function fun
where isPublicMethod(fun) and
      isTested(fun)
  select fun, "is a public method called by test"