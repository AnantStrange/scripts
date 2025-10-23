#!/bin/sh

cat <<EOL >>".clang-format"
BasedOnStyle: LLVM
IndentWidth: 4
TabWidth: 4
UseTab: Never

BreakBeforeBraces: Attach

AllowShortIfStatementsOnASingleLine: false
AllowShortLoopsOnASingleLine: false
AllowShortFunctionsOnASingleLine: Inline
AllowShortCaseLabelsOnASingleLine: false

ColumnLimit: 100
SpaceBeforeParens: ControlStatements
Cpp11BracedListStyle: true
AlwaysBreakTemplateDeclarations: Yes

SortIncludes: false
ReflowComments: true

EOL


