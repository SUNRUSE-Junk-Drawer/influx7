# SUNRUSE.influx

A purely functional language, which can compile in your browser to almost 
anything, and has integrated support for vector mathematics.

Well, that's the plan, anyway.  Not quite done, and won't be for a while.  For now, you can [try the prototype](http://sunruse.co.uk/influx).

This repository contains:

- A Webpack-safe CoffeeScript/NPM library capable of parsing source code.  
  In future, this will be capable of generating code for other languages to execute.
- An ASP.NET MVC 5 webpage which acts as an IDE.  
  In future, the plan is to create a crude form of package manager/repository here
  where you can browse for functions and include them.
  
## Building from source

Clone this repository.

### NPM library

Please ensure that Node.JS/NPM are installed.
This has been tested with Node.JS v4.4.7 and NPM 2.15.8.

Go to the root of the repository, and in a terminal or command prompt, enter "npm install".  
All dependencies will be brought in automatically.

To run the test suite, enter "npm test".

### ASP.NET MVC 5 IDE

Visual Studio 2015 Express for Web is used; Community Edition or Professional Edition should work.

SQL Server 2012 is used for testing.

The NPM library will automatically be built by a build step, so please ensure you can build the NPM library first.

Medium trust is supported.

The solution file can be found at src/clr/SUNRUSE.Influx.sln.
NuGet is used for dependency management so any dependencies should automatically be installed.
Tests should be runnable using the integrated test runner.

The Web.Release.config file is not included.  
To do a release build/publish, please add the following file and add your connection string.

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <connectionStrings>
    <add name="Context" connectionString="<!-- Please add your connection string here. -->" providerName="System.Data.SqlClient" xdt:Transform="SetAttributes" />
  </connectionStrings>
  <system.web>
    <compilation xdt:Transform="RemoveAttributes(debug)" />
  </system.web>
</configuration>
```

## Compiling a program

Compilation has been separated out into many stages, allowing some flexibility 
in how they are handled.
Please note that no function in the codebase should mutate its arguments.

tokenizeSplitByWhitespace
: Builds an array of objects representing the 
[unparenthesized tokens](#Unparenthesized Token) in the file.
    
tokenizeSplitToken (for each result)
: Splits a token if any symbols exist in it; for instance, hello!world*-fish 
becomes hello ! world * - fish.  Returns an array of 
[unparenthesized tokens](###Unparenthesized Token).

(you should then concatenate the resulting arrays)

tokenizeParenthesize
: Finds matching opening and closing pairs of tokens recognized as parentheses 
and builds a tree of tokens.  Returns an array of 
[parenthesized tokens](###Parenthesized Token).

expressionParse
: Builds an untyped [expression object](###Expression object).

expressionInline
: Inlines any lambda expression calls, replacing them with the lambda 
expressions' bodies (with their parameters replaced with the calls' arguments) 
and returning an untyped [expression object](###Expression object).

expressionTypeCheck
: Validates all arguments to native functions and replaces references to untyped
native functions with the appropiate typed native function.  Returns a typed
[expression object](###Expression object).

expressionUnroll
: Validates and unrolls all plural operations; (3, 4) * 8 becomes 
(3 * 8, 4 * 8).  If the expression has a plural result, a concatenation is 
created at the root.  Returns a typed [expression object](###Expression object).

## Types

### Unparenthesized token

token
: A string containing the token's content

start
: The number of characters between the start of the token and the start of the file.

### Parenthesized token

token
: A string containing the token's content, or the opening parenthesis if a pair of parentheses.

starts
: The number of characters between the start of the token and the start of the file.

ends
: The number of characters between the end of the token and the start of the file.

children
: When truthy, this token represents a parentheses block.  Contains more of these objects representing its contents.

### Declarations object

An object, where the keys are the names of declarations made in the current scope (by using "let", or calling lambda expressions)
and the values are the expression objects they refer to.

### Expression object

Expression objects are considered *typed* or *untyped*.  Please see (native function call)[#Native function call] for what this means.

#### Primitive constant

primitive
: A string identifying the primitive type.

value
: The constant value contained.

starts
: The number of characters between the start of the primitive constant and the start of the file.

ends
: The number of characters between the end of the primitive constant and the start of the file.

#### Native function call

call
: A string identifying the native function.  When the expression object is *untyped*, this is an untyped function such as "concatenate", "add" or "negate".  When the expression object is *typed*, this is a typed function such as "concatenateBoolean", "addInteger" or "negateFloat".

with
: An array of the expression objects given as arguments.

starts
: The number of characters between the start of the operator keyword or symbol and the start of the file.

ends
: The number of characters between the end of the operator keyword or symbol and the start of the file.

#### Lambda expression

parameters
: An array of the parenthesized token objects defining parameters to the lambda expression.

body
: The expression object inside the lambda expression.

starts
: The number of characters between the start of the lambda keyword or symbol and the start of the file.

ends
: The number of characters between the end of the lambda keyword or symbol and the start of the file.

#### Parameter

parameter
: A string specifying the parameter referenced.

starts
: The number of characters between the start of the token and the start of the file.

ends
: The number of characters between the end of the token and the start of the file.

#### Lambda expression call

callLambda
: An expression object returning a lambda expression to call.

with
: An array of expression objects to supply to the lambda expression as arguments.

starts
: The number of characters between the start of the token and the start of the file.

ends
: The number of characters between the end of the token and the start of the file.

#### Return statement

return
: The expression object being returned.

starts
: The number of characters between the start of the "return" token and the start 
  of the file.

ends
: The number of characters between the end of the "return" token and the start 
  of the file.

## Primitive types

### boolean

Represents a single bit, but may be stored as a different type.

Literals: true, false

### integer

A 32-bit signed integer, covering -2147483648 to 2147483647.
Overflow behaviour is undefined.  If possible, errors are preferable.

Literals: 0, 14, 04020

### float 

A 32-bit IEEE float.

Literals: .0, 0., 0.0, 14., 04020., .14, .04020, 14.0, 04020.0, 0.14, 0.04020, 14.374, 04020.14, 14.04020, 04020.0384090

## Native functions

### Plurality

Every native function has a plurality, which describes how it handles being given vectors.

#### Map

The function has no native handling of vectors, so will be executed once for each item.

(3, 5, 7) * (10, 12, 14) = 3 * 10, 5 * 12, 7 * 14

(3, 5, 7) * 10 = 3 * 10, 5 * 10, 7 * 10

3 * (10, 12, 14) = 3 * 10, 3 * 12, 3 * 14

not (true, false, true) = not true, not false, not true

If arguments have more than one item, but differing numbers of items, this is a plurality mismatch as it is not clear how to match up the items:

(3, 5, 7) * (10, 12)

#### Concatenate

The function concatenates its arguments' items.

(3, 5), (7, 8, 9) = (3, 5, 7, 8, 9)

#### Fold

The function returns only one item.  This follows a consistent input pattern but the generated result tends to be less so.

sum (3, 10, 12) = 3 + 10 + 12

(3, 5, 7) dot (10, 12, 14) = 3 * 10 + 5 * 12 + 7 * 14

3 dot (10, 12, 14) = 3 * 10 + 3 * 12 + 3 * 14

(3, 5, 7) dot 10 = 3 * 10 + 5 * 10 + 7 * 10

As with map, when the plurality of the arguments mismatches, a compile-time error occurs as it is unclear how to match the items.

(3, 5, 7) dot (10, 12)

### Table

| Untyped            | Symbols             | Keywords | Plurality   | Typed                     | Parameters       | Returns |
| ------------------ | ------------------- | -------- | ----------- | ------------------------- | ---------------- | ------- |
| add                | +                   |          | map         |                           |                  |         |
|                    |                     |          |             | addInteger                | integer, integer | integer |
|                    |                     |          |             | addFloat                  | float, float     | float   |
| subtract           | -                   |          | map         |                           |                  |         |
|                    |                     |          |             | subtractInteger           | integer, integer | integer |
|                    |                     |          |             | subtractFloat             | float, float     | float   |
| multiply           | *                   |          | map         |                           |                  |         |
|                    |                     |          |             | multiplyInteger           | integer, integer | integer |
|                    |                     |          |             | multiplyFloat             | float, float     | float   |
| divide             | /                   |          | map         |                           |                  |         |
|                    |                     |          |             | divideFloat               | float, float     | float   |
| negate             | -                   |          | map         |                           |                  |         |
|                    |                     |          |             | negateInteger             | integer          | integer |
|                    |                     |          |             | negateFloat               | float            | float   |
| concatenate        | ,                   |          | concatenate |                           |                  |         |
|                    |                     |          |             | concatenateInteger        | integer, integer | integer |
|                    |                     |          |             | concatenateFloat          | float, float     | float   |
|                    |                     |          |             | concatenateBoolean        | boolean, boolean | boolean |
| and                | & &&                | and      | map         |                           |                  |         |
|                    |                     |          |             | andBoolean                | boolean, boolean | boolean |
| or                 | &#124; &#124;&#124; | or       | map         |                           |                  |         |
|                    |                     |          |             | orBoolean                 | boolean, boolean | boolean |
| not                | !                   | not      | map         |                           |                  |         |
|                    |                     |          |             | notBoolean                | boolean          | boolean |
| equal              | = ==                | is       | map         |                           |                  |         |
|                    |                     |          |             | equalInteger              | integer, integer | boolean |
|                    |                     |          |             | equalFloat                | float, float     | boolean |
|                    |                     |          |             | equalBoolean              | boolean, boolean | boolean |
| notEqual           | != <>               | isnt     | map         |                           |                  |         |
|                    |                     |          |             | notEqualInteger           | integer, integer | boolean |
|                    |                     |          |             | notEqualFloat             | float, float     | boolean |
|                    |                     |          |             | notEqualBoolean           | boolean, boolean | boolean |
| lessThan           | <                   |          | map         |                           |                  |         |
|                    |                     |          |             | lessThanInteger           | integer, integer | boolean |
|                    |                     |          |             | lessThanFloat             | float, float     | boolean |
| lessThanOrEqual    | <=                  |          | map         |                           |                  |         |
|                    |                     |          |             | lessThanOrEqualInteger    | integer, integer | boolean |
|                    |                     |          |             | lessThanOrEqualFloat      | float, float     | boolean |
| greaterThan        | >                   |          | map         |                           |                  |         |
|                    |                     |          |             | greaterThanInteger        | integer, integer | boolean |
|                    |                     |          |             | greaterThanFloat          | float, float     | boolean |
| greaterThanOrEqual | >=                  |          | map         |                           |                  |         |
|                    |                     |          |             | greaterThanOrEqualInteger | integer, integer | boolean |
|                    |                     |          |             | greaterThanOrEqualFloat   | float, float     | boolean |
| sum                |                     | sum      | fold        |                           |                  |         |
|                    |                     |          |             | sumInteger                | integer          | integer |
|                    |                     |          |             | sumFloat                  | float            | float   |
| product            |                     | product  | fold        |                           |                  |         |
|                    |                     |          |             | productInteger            | integer          | integer |
|                    |                     |          |             | productFloat              | float            | float   |
| any                |                     | any      | fold        |                           |                  |         |
|                    |                     |          |             | anyBoolean                | boolean          | boolean |
| all                |                     | all      | fold        |                           |                  |         |       
|                    |                     |          |             | allBoolean                | boolean          | boolean |
