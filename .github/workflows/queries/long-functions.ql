/**
 * @description Find all long functions (more than 10 lines)
 * @kind problem
 * @id javascript/long-functions
 * @problem.severity recommendation
 */
import javascript

from Function fun
where 
  fun.getNumLines() > 10
select fun, " with name" + fun.getName() + "contains" + fun.getNumLines() + "lines"
