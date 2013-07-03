; ModuleID = 'aggregate.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

%struct.hoge2 = type { i8, double, %struct.hoge1 }
%struct.hoge1 = type { float, [10 x [20 x i32]] }

define i32* @getelem(%struct.hoge2* %hoge) nounwind uwtable ssp {
  %1 = alloca %struct.hoge2*, align 8
  store %struct.hoge2* %hoge, %struct.hoge2** %1, align 8
  %2 = load %struct.hoge2** %1, align 8
  %3 = getelementptr inbounds %struct.hoge2* %2, i64 1
  %4 = getelementptr inbounds %struct.hoge2* %3, i32 0, i32 2
  %5 = getelementptr inbounds %struct.hoge1* %4, i32 0, i32 1
  %6 = getelementptr inbounds [10 x [20 x i32]]* %5, i32 0, i64 5
  %7 = getelementptr inbounds [20 x i32]* %6, i32 0, i64 13
  ret i32* %7
}
