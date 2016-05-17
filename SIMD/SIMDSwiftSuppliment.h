//
//  SIMDSwiftSuppliment.h
//  SIMDVector
//
//  Created by Kazuho Okui on 5/14/16.
//  Copyright © 2016 Kazuho Okui. All rights reserved.
//

#ifndef SIMDSwiftSuppliment_h
#define SIMDSwiftSuppliment_h

#include <simd/simd.h>

//
// MARK: - float2
//
static inline __SIMD_BOOLEAN_TYPE__ float2_equal(vector_float2 lhs, vector_float2 rhs) {
  return vector_all(lhs == rhs);
}

static inline __SIMD_BOOLEAN_TYPE__ float2_nearly_equal(vector_float2 lhs, vector_float2 rhs) {
  return vector_all(vector_abs(lhs - rhs) < FLT_EPSILON);
}

static inline vector_float2  __SIMD_ATTRIBUTES__ rint_float2(vector_float2  __x) {
  return rint(__x);
}

static inline __SIMD_BOOLEAN_TYPE__ float2_any_minum(vector_float2 x) {
  return vector_any(x < 0);
}


//
// MARK: - float4
//
static inline __SIMD_BOOLEAN_TYPE__ float4_equal(vector_float4 lhs, vector_float4 rhs) {
  return vector_all(lhs == rhs);
}

static inline __SIMD_BOOLEAN_TYPE__ float4_nearly_equal(vector_float4 lhs, vector_float4 rhs) {
  return vector_all(vector_abs(lhs - rhs) < FLT_EPSILON);
}

static inline vector_float4  __SIMD_ATTRIBUTES__ rint_float4(vector_float4  __x) {
  return rint(__x);
}


static vector_float3  __SIMD_ATTRIBUTES__ vector_sin(vector_float3 __x) { return sin(__x); }
static vector_float3  __SIMD_ATTRIBUTES__ vector_cos(vector_float3 __x) { return cos(__x); }


#endif /* SIMDSwiftSuppliment_h */
