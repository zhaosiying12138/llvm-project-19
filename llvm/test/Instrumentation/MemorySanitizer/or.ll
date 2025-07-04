; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 5
; RUN: opt < %s -S -passes=msan 2>&1 | FileCheck %s
;
; Test bitwise OR instructions, especially the "disjoint OR", which is
; currently handled incorrectly by MSan (as if it was a regular OR).

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define i8 @test_or(i8 %a, i8 %b) sanitize_memory {
; CHECK-LABEL: define i8 @test_or(
; CHECK-SAME: i8 [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i8, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = xor i8 [[A]], -1
; CHECK-NEXT:    [[TMP4:%.*]] = xor i8 [[B]], -1
; CHECK-NEXT:    [[TMP5:%.*]] = and i8 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP6:%.*]] = and i8 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP7:%.*]] = and i8 [[TMP1]], [[TMP4]]
; CHECK-NEXT:    [[TMP8:%.*]] = or i8 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    [[TMP9:%.*]] = or i8 [[TMP8]], [[TMP7]]
; CHECK-NEXT:    [[C:%.*]] = or i8 [[A]], [[B]]
; CHECK-NEXT:    store i8 [[TMP9]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = or i8 %a, %b
  ret i8 %c
}

define i8 @test_disjoint_or(i8 %a, i8 %b) sanitize_memory {
; CHECK-LABEL: define i8 @test_disjoint_or(
; CHECK-SAME: i8 [[A:%.*]], i8 [[B:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i8, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = xor i8 [[A]], -1
; CHECK-NEXT:    [[TMP4:%.*]] = xor i8 [[B]], -1
; CHECK-NEXT:    [[TMP5:%.*]] = and i8 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP6:%.*]] = and i8 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP7:%.*]] = and i8 [[TMP1]], [[TMP4]]
; CHECK-NEXT:    [[TMP8:%.*]] = or i8 [[TMP5]], [[TMP6]]
; CHECK-NEXT:    [[TMP11:%.*]] = or i8 [[TMP8]], [[TMP7]]
; CHECK-NEXT:    [[C:%.*]] = or disjoint i8 [[A]], [[B]]
; CHECK-NEXT:    store i8 [[TMP11]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = or disjoint i8 %a, %b
  ret i8 %c
}
