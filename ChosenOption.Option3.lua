--[[ Arithmetic Expression Tree Program Skeleton 
     Evaluation Table Version
     H. Conrad Cunningham, Professor
     Computer and Information Science
     University of Mississippi

Developed for CSci 658, Software Language Engineering, Fall 2013

1234567890123456789012345678901234567890123456789012345678901234567890

2013-09-02: Modified program from Recursive Function List version
2013-09-04: Made similar to new Recursive Function List version,
            including adding valToString
2013-09-07: Corrected typos and comments
2014-11-11: Added tree constructors (as in current Recursive Function
            List and Record versions) and isExp to check expression 
            structure
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

-- Expression tree evaluation table indexed by node type tags
local evalTab = {}

-- Trap any attempts to evaluate invalid node type tags
setmetatable(evalTab,evalTab)

evalTab.__index = function(_,key)
  error("Attempt to evaluate invalid tree node type tag " ..
        tostring(key), 2)
end


-- Function "eval" evaluates expression tree "t" in environment
-- "env". It checks the tag (first element of "t") to determine
-- what actions to take.

local function eval(t,env)
  if isExp(t) then
    if type(env) == "table" then
      return evalTab[t[1]](t,env)
    else
      error("eval called with invalid environment argument: " .. 
            tostring(env), 2)
    end
  else
    error("eval called with invalid expression argument: " .. 
          tostring(t), 2)
  end
end


-- Evaluation table entries

evalTab[SUM_TYPE] = function(t,env)     -- {SUM_TYPE,left,right}
  if #t == 3 then
    return eval(t[2],env) + eval(t[3],env)
  else
    error("eval called for type tag " .. SUM_STR ..
          " node that does not have exactly two operands: " .. 
          tostring(t), 2)
  end
end

evalTab[VAR_TYPE] = function(t,env)     -- {VAR_TYPE,name}
  return env[t[2]]
end

evalTab[CONST_TYPE] = function(t,env)   -- {CONST_TYPE,num}
  return t[2]
end


-- Expression tree differentiation table indexed by node types

local derivaTab = {}

-- Trap any attempts to evaluate invalid OpCodes 
setmetatable(derivaTab,derivaTab)

derivaTab.__index = function(_,key)
  error("Attempt to differentiate invalid tree node " .. 
        tostring(key),2)
end


-- Function "derive" takes an arithmetic expression tree "t" and a
-- variable "v" and returns the derivative, another arithmetic
-- expression tree.

local function derive(t,v)
  if isExp(t) then
    if type(v) == "string" then
      return derivaTab[t[1]](t,v)
    else
      error("derive called with invalid variable: " .. 
            tostring(v), 2)
    end
  else
    error("derive called with invalid expression argument: " ..
          tostring(t), 2)
  end
end


-- Differentiation table entries

derivaTab[SUM_TYPE] = function(t,v)     -- {SUM_TYPE,left,right}
  if #t == 3 then
    return {SUM_TYPE, derive(t[2],v), derive(t[3],v)}
  else
    error("derive called for type tag " .. SUM_STR ..
          " node that does not have exactly two operands: " .. 
          tostring(t), 2)
  end
  return {SUM_TYPE, derive(t[2],v), derive(t[3],v)}
end

derivaTab[VAR_TYPE] = function(t,v)     -- {VAR_TYPE,name}
  if v == t[2] then
    return CONST_ONE
  else
    return CONST_ZERO
  end
end

derivaTab[CONST_TYPE] = function(t,v)   -- {CONST_TYPE,value}
  return CONST_ZERO
end


-- Function "valToString" takes an arithmetic expression tree "t" and
-- returns a string representation of the expression tree.

function valToString(t)
  if type(t) == "table" then
    if t[1] == SUM_TYPE then 
      return SUM_STR .. "(" .. valToString(t[2])  .. "," 
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
