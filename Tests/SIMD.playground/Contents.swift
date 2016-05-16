//: Playground - noun: a place where people can play

import AppKit

let r = CGRectZero
print(r.isEmpty)
print(r.isNull)

let rn = CGRectMake(10, 10, 0, 0)

print(rn.isEmpty)
print(rn.isNull)


let rr = CGRectMake(100, 100, 100, 100)

print(rr.union(CGRectMake(500, 500, 0, 0)))

let n = CGRectNull

print(n.union(CGRectMake(10, 10, 100, 100)))

let a = [CGRectMake(10, 10, 30, 30), CGRectMake(100, 100, 10, 25)]

let arr = a.reduce(CGRectNull) { $0.union($1) }
print(arr)


let ir = CGRectIntegral(CGRectMake(10.5, 11.233, 30.3, 20.2))
