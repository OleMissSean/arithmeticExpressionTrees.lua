local function main()
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
local SUB_TYPE,   SUB_STR   = "Sub", "Sub"
local PROD_TYPE,  PROD_STR  = "Prod", "Prod"
local DIV_TYPE,   DIV_STR   = "Div", "Div"
local NEG_TYPE,   NEG_STR   = "Neg", "Neg"
local SIN_TYPE,   SIN_STR   = "Sin", "Sin"
local COS_TYPE,   COS_STR   = "Cos", "Cos"

-- Checking for valid expressions

local tags = { [CONST_TYPE] = true, [VAR_TYPE] = true, 
               [SUM_TYPE]   = true, [SUB_TYPE] = true,
               [PROD_TYPE]  = true, [DIV_TYPE] = true,
               [NEG_TYPE]   = true, [SIN_TYPE] = true,
               [COS_TYPE]   = true                     }

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

local function makeSub(l,r)
  if isExp(l) then
    if isExp(r) then
      return {SUB_TYPE, l, r}
    else
      error("Second argument of makeSub is not a valid expression: "
            .. toString(r), 2)
    end
  else
    error("First argument of makeSub is not a valid expression: " ..
          toString(l), 2)
  end
end

local function makeProd(l,r)
  if isExp(l) then
    if isExp(r) then
      return {PROD_TYPE, l, r}
    else
      error("Second argument of makeProd is not a valid expression: "
            .. toString(r), 2)
    end
  else
    error("First argument of makeProd is not a valid expression: " ..
          toString(l), 2)
  end
end

local function makeDiv(l,r)
  if isExp(l) then
    if isExp(r) then
      return {DIV_TYPE, l, r}
    else
      error("Second argument of makeDiv is not a valid expression: "
            .. toString(r), 2)
    end
  else
    error("First argument of makeDiv is not a valid expression: " ..
          toString(l), 2)
  end
end

local function makeNeg(n)
  if isExp(n) then
    return {NEG_TYPE, n}
  else
    error("Argument for makeNeg is not a valid expression: " .. 
          tostring(n), 2)
  end
end

local function makeSin(n)
  if isExp(n) then
    return {SIN_TYPE, n}
  else
    error("Argument for makeSin is not a valid expression: " ..
          tostring(n), 2)
  end
end

local function makeCos(n)
  if isExp(n) then
    return {COS_TYPE, n}
  else
    error("Argument for makeCos is not a valid expression: " ..
          tostring(n), 2)
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

evalTab[SUB_TYPE] = function(t,env)
  if #t == 3 then
    return eval(t[2],env) - eval(t[3],env)
  else
    error("eval called for type tag " .. SUB_STR ..
          " node that does not have exactly two operands: " ..
          toString(t), 2)
  end
end

evalTab[PROD_TYPE] = function(t,env)
  if #t == 3 then
    return eval(t[2],env)*eval(t[3],env)
  else
    error("eval called for type tag " .. PROD_STR ..
          " node that does not have exactly two operands: " ..
          toString(t), 2)
  end
end

evalTab[DIV_TYPE] = function(t,env)
  if #t == 3 then
    return eval(t[2],env)/eval(t[3],env)
  else
    error("eval called for type tag " .. DIV_STR ..
          " node that does not have exactly two operands: " ..
          toString(t), 2)
  end
end

evalTab[NEG_TYPE] = function(t,env)
  return eval(t[2],env)*(-1)
end

evalTab[SIN_TYPE] = function(t,env)
  return math.sin(eval(t[2],env))
end

evalTab[COS_TYPE] = function (t,env)
  return math.cos(eval(t[2],env))
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

derivaTab[SUB_TYPE] = function(t,v)     
  if #t == 3 then
    return {SUB_TYPE, derive(t[2],v), derive(t[3],v)}
  else
    error("derive called for type tag " .. SUB_STR ..
          " node that does not have exactly two operands: " .. 
          tostring(t), 2)
  end
  return {SUB_TYPE, derive(t[2],v), derive(t[3],v)}
end

derivaTab[PROD_TYPE] = function(t,v)     
  if #t == 3 then
    return {PROD_TYPE, derive(t[2],v), derive(t[3],v)}
  else
    error("derive called for type tag " .. PROD_STR ..
          " node that does not have exactly two operands: " .. 
          tostring(t), 2)
  end
  return {PROD_TYPE, derive(t[2],v), derive(t[3],v)}
end

derivaTab[DIV_TYPE] = function(t,v)     
  if #t == 3 then
    return {DIV_TYPE, derive(t[2],v), derive(t[3],v)}
  else
    error("derive called for type tag " .. DIV_STR ..
          " node that does not have exactly two operands: " .. 
          tostring(t), 2)
  end
  return {DIV_TYPE, derive(t[2],v), derive(t[3],v)}
end

derivaTab[NEG_TYPE] = function(t,v)
  if #t == 2 then
    return {NEG_TYPE, derive(t[2],v)}
  else
    error("derive called for type tag " .. NEG_STR ..
          " node that does not have exactly two operands: " ..
          tostring(t), 2)
  end
  return {NEG_TYPE, derive(t[2],v)}
end

derivaTab[SIN_TYPE] = function(t,v)
  if #t == 2 then
    return {SIN_TYPE, derive(t[2],v)}
  else
    error("derive called for type tag " .. SIN_STR ..
          " node that does not have exactly two operands: " ..
          tostring(t), 2)
  end
  return {SIN_TYPE, derive(t[2],v)}
end

derivaTab[COS_TYPE] = function(t,v)
  if #t == 2 then
    return {COS_TYPE, derive(t[2],v)}
  else
    error("derive called for type tag " .. COS_STR ..
          " node that does not have exactly two operands: " ..
          tostring(t), 2)
  end
  return {COS_TYPE, derive(t[2],v)}
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
    elseif t[1] == SUB_TYPE then
      return SUB_STR .. "(" .. valToString(t[2])  .. ","
          .. valToString(t[3]) .. ")"
    elseif t[1] == PROD_TYPE then
      return PROD_STR .. "(" .. valToString(t[2])  .. ","
          .. valToString(t[3]) .. ")"
    elseif t[1] == DIV_TYPE then
      return DIV_STR .. "(" .. valToString(t[2])  .. ","
          .. valToString(t[3]) .. ")"
    elseif t[1] == NEG_TYPE then
      return NEG_STR .. "(" .. valToString(t[2]) .. ")"
    elseif t[1] == SIN_TYPE then
      return SIN_STR .. "(" .. valToString(t[2]) .. ")"
    elseif t[1] == COS_TYPE then
      return COS_STR .. "(" .. valToString(t[2]) .. ")"
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


--makeSum1

local exp = makeSum( makeSum(makeVar("x"),makeVar("x")), 
                     makeSum(makeConst(7),makeVar("y")) )
local env = { x = 5, y = 7 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=5, y=7: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");

--makeSum2

local exp = makeSum( makeSum(makeVar("x"),makeVar("x")), 
                     makeSum(makeConst(7),makeVar("y")) )
local env = { x = 4, y = 8 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=4, y=8: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");

--makeSub1

local exp = makeSub( makeSub(makeVar("x"),makeVar("x")),
         makeSub(makeConst(6),makeVar("y")) )
local env = {x = 5, y = 6 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=5, y=6: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");
      
--makeSub2      
      
local exp = makeSub( makeSub(makeVar("x"),makeVar("x")),
         makeSub(makeConst(5),makeVar("y")) )
local env = {x = 9, y = 3 }
      
print("Expression: " .. valToString(exp))
print("Evaluation with x=9, y=3: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");

--makeProd1

local exp = makeProd( makeProd(makeVar("x"),makeVar("x")),
          makeProd(makeConst(6),makeVar("y")) )
local env = {x = 5, y = 6 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=5, y=6: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");
      
--makeProd2

local exp = makeProd( makeProd(makeConst(2),makeVar("x")),
          makeProd(makeVar("y"),makeVar("y")) )
local env = {x = 3, y = 7 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=3, y=7: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");

--makeDiv1

local exp = makeDiv( makeDiv(makeVar("x"),makeVar("x")),
            makeDiv(makeConst(9),makeVar("y")) )
local env = {x = 4, y = 40 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=4, y=40: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");

--makeDiv2

local exp = makeDiv( makeDiv(makeVar("x"),makeVar("x")),
            makeDiv(makeConst(8),makeVar("y")) )
local env = {x = 2, y = 2 }

print("Expression: " .. valToString(exp))
print("Evaluation with x=2, y=2: " .. eval(exp,env))
print("Derivative relative to x:\n  " .. 
      valToString(derive(exp, "x")))
print("Derivative relative to y:\n  " .. 
      valToString(derive(exp, "y")))
print("\n");

--makeNeg1

local exp = makeNeg(makeVar("x"))

local env = {x = 5 }

print("Expression: " .. valToString(exp))
print("Evaluation with x = 5: " .. eval (exp,env))
print("Derivative relative to x:\n " ..
      valToString(derive(exp, "x")))
print("\n");

--makeNeg2

local exp = makeNeg(makeNeg(makeVar("x")))

local env = {x = 6 }

print("Expression: " .. valToString(exp))
print("Evaluation with x = 6: " .. eval (exp,env))
print("Derivative relative to x:\n " ..
      valToString(derive(exp, "x")))
print("\n");
      
--makeSin1      
      
local exp = makeSin(makeVar("x"))

local env = {x = math.pi }

print("Expression: " .. valToString(exp))
print("Evaluation with x = pi: " .. eval (exp,env))
print("Derivative relative to x:\n " ..
      valToString(derive(exp, "x")))
print("\n");

--makeSin2     
      
local exp = makeSin(makeVar("x"))

local env = {x = -(math.pi)}

print("Expression: " .. valToString(exp))
print("Evaluation with x = pi: " .. eval (exp,env))
print("Derivative relative to x:\n " ..
      valToString(derive(exp, "x")))
print("\n");

--makeCos1     

local exp = makeCos(makeVar("x"))

local env = {x = math.pi}

print("Expression: " .. valToString(exp))
print("Evaluation with x = pi: " .. eval (exp,env))
print("Derivative relative to x:\n " ..
      valToString(derive(exp, "x")))
print("\n");
      
--makeCos2     

local exp = makeCos(makeVar("x"))

local env = {x = 0}

print("Expression: " .. valToString(exp))
print("Evaluation with x = pi: " .. eval (exp,env))
print("Derivative relative to x:\n " ..
      valToString(derive(exp, "x")))
print("\n");      
      
end
main()
