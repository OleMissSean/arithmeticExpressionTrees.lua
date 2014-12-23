CSci450.Assignment5.lua
=======================

Assignment #5 for CSci 450: Systems of Programming Languages. Lua Program.


CSci 450-01: Organization of Programming Languages
CSci 503-01: Fundamental Concepts in Languages
Fall 2014

Assignment #5: Arithmetic Expression Trees
Due Date: Wednesday, 19 November, 11:59 p.m.

Complete the following programming tasks by the due date. The program you develop should use appropriate functional programming or object-oriented programming techniques in Lua. In general, your program can should expression tree structures and initialize them, but it should not change the values of the data structure once initialized.

    Choose one of the three functional or two object-oriented implementations of the Lua Arithmetic Expression Tree skeleton program on the Lecture Notes page. Modify and extend it in the following ways:

        Add the following new kinds of nodes: Sub, Prod, and Div for subtraction, multiplication, and division of numbers, respectively; Neg for negating a value, and Sin and Cos for the sine and cosine trigonometric functions, respectively.

        Extend functions eval, derive, and valToString to support these new node types. (For differentiation, you may want to look up the formulas in a Calculus textbook to remind yourself of the more complex rules.)

        Add a new operation simplify that takes an arithmetic expression tree (as extended in the previous tasks), simplifies it by "evaluating" all subexpressions involving only constants (not evaluating variables), and returns the new expression. For example, Add(Const(1),Const(3)) can be simplified to Const(4).

        CSci 503 students: Package your implementation as a Lua module with appropriate functions exported or hidden. The testing code should be in a chunk separate from the module.

        Challenge: Extend the simplifications in other ways. For example, you could take advantage of mathematical properties such as identity elements (x * 1 = x), zeros (x * 0 = 0), associativity ((x + y) + z = x + (y + z), and commutativity ( x + 1 = 1 + x).

    Design appropriate tests for your program and test the program thoroughly.

    Document your program appropriately.

    Submit the source code and documentation for your program and test driver, any needed instructions on how to run the program, and appropriate test output to Blackboard. Also provide your instructor with a paper copy. Be sure to identify yourself in the materials turned in.

UP to CSci 450 assignments document?

Copyright © 2014, H. Conrad Cunningham
Last modified: Tue Nov 11 18:29:26 CST 2014 
