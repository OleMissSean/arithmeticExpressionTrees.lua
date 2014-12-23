--[[ Arithmetic Expression Tree Program Skeleton
     Recursive Function Version with List-style Nodes
     H. Conrad Cunningham, Professor
     Computer and Information Science
     University of Mississippi

Developed for CSci 658, Software Language Engineering, Fall 2013

1234567890123456789012345678901234567890123456789012345678901234567890

2013-08-29: Modified program from author's Scala functional version
2013-09-02: Completed prototype	   
2013-09-04: Made similar to Recursive Function Record version
            added valToString as alternative to treeConcat output
2013-09-07: Corrected typos and comments
2014-11-11: Added tree constructors (as in current Recursive Function
            Record version) and isExp to check expression structure

--]]


--[[ ARITHMETIC EXPRESSION TREES

This program represents an arithmetic expression tree by a list-style
table whose first element is an operator tag and whose subsequent
elements are the operands for that operation.  Each operand may be an
arithmetic expression tree.

--]]


-- Constants for tree node type tags
local CONST_TYPE, CONST_STR = "Const", "Const"
local VAR_TYPE,   VAR_STR   = "Var", "Var"
local SUM_TYPE,   SUM_STR   = "Sum", "Sum"

-- Checking for valid expressions

local tags = { [CONST_TYPE] = true, [VAR_TYPE] = true, 
               [SUM_TYPE]   = true                     }

local function isExp(t)
  return type(t) == "table" and tags[t[1]] ~= nil and #t >= 2
end


-- Tree node constructor functions

local function makeConst(v)
  if type(v) == "number" then 
    return {CONST_TYPE, v}
  else
    error("makeConst called with nonumeric value field: " .. 
          tostring(v), 2)
  end
end

local function makeVar(n)
  if type(n) == "string" then
    return {VAR_TYPE, n}
  else
    error("makeVar called with nonstring name argument: " .. 
          tostring(n), 2)
  end
end

local function makeSum(l,r)
  if isExp(l) then
    if isExp(r) then
      return {SUM_TYPE, l, r}
    else
      error("Second argument of makeSum is not a valid expression: " 
            .. tostring(r), 2)
    end
  else
    error("First argument of makeSum is not a valid expression: " ..
          tostring(l), 2)
  end
end


-- Constants for frequent constant expression trees (singleton refs)
local CONST_ZERO = makeConst(0)
local CONST_ONE  = makeConst(1)


-- Function "eval" evaluates expression tree "t" in environment
-- "env". It checks the tag (first element of "t") to determine
-- what actions to take.

local function eval(t,env)
  if isExp(t) then
    if type(env) == "table" then
      if t[1] == SUM_TYPE then 
        return eval(t[2],env) + eval(t[3],env)
      elseif t[1] == VAR_TYPE then
        return env[t[2]]
      elseif t[1] == CONST_TYPE then
        return t[2]
      else
        error("eval called with unknown tree type tag: " .. 
              tostring(t[1]), 2)
      end
    else
      error("eval called with invalid environment argument: " .. 
            tostring(env), 2)
    end
  else
    error("eval called with invalid expression argument: " .. 
          tostring(t), 2)
  end
end


-- Function "derive" takes an arithmetic expression tree "t" and a
-- variable "v" and returns the derivative, another arithmetic
-- expression tree.

local function derive(t,v)
  if isExp(t) then
    if type(v) == "string" then
      if t[1] == SUM_TYPE then
        return makeSum(derive(t[2],v), derive(t[3],v))
      elseif t[1] == VAR_TYPE then
        if v == t[2] then     
          return CONST_ONE
        else
          return CONST_ZERO
        end
      elseif t[1] == CONST_TYPE then
        return CONST_ZERO
      else
        error("derive called with unknown tree type tag: " .. 
              tostring(t.tag), 2)
      end
    else
      error("derive called with invalid variable: " .. 
            tostring(v), 2)
    end
  else
    error("derive called with invalid expression argument: " ..
          tostring(t), 2)
  end
end


-- Function "valToString" takes an arithmetic expression tree "t" and
-- returns a string representation of the expression tree.

local function valToString(t)
  if isExp(t) then
    if t[1] == SUM_TYPE then 
      return SUM_STR .. "(" .. valToString(t[2]) .. "," 
                            .. valToString(t[3]) .. ")"
    elseif t[1] == VAR_TYPE then
      return VAR_STR .. "(" .. t[2] .. ")"
    elseif t[1] == CONST_TYPE then
      return CONST_STR .. "(" .. tostring(t[2]) .. ")"
    else
      error("valToString called with unknown tree type: " ..
            tostring(t[1]), 2)
    end
  else
    error("valToString called with invalid expression: " ..
          tostring(t), 2)
  end
end


-- MAIN PROGRAM

local exp = makeSum( makeSum(makeVar("x"),makeVar("x")), 
                     makeSum(makeConst(7),makeVar("y")) )
local env = { x = 5, y = 7 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=5, y=7: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
