; ModuleID = 'kernel.d'
source_filename = "kernel.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"shader.builtin.Vector!(float, 4LU).Vector" = type { [1 x i8] }
%kernel.BlockName = type { %kernel.S, i8 }
%kernel.S = type <{ i8, [5 x %"shader.builtin.Vector!(float, 4LU).Vector"], [2 x i8], i32 }>
%nest.__equals = type { { i64, i8* }, { i64, i8* } }

$main = comdat any

$_D4core8internal5array8equality__T8__equalsTyaTyaZQqFNaNbNiNfAyaQdZb = comdat any

$_D4core8internal5array8equality__T8__equalsTyaTyaZQqFAyaQdZ9__lambda3MFNaNbNiNeZb = comdat any

$_D4core8internal5array8equality__T8__equalsTyaTyaZQqFAyaQdZ__T2atTyaZQhFNaNbNcNiNeQBdmZya = comdat any

$color1 = comdat any

$multiplier = comdat any

$color2 = comdat any

$color = comdat any

$blockName = comdat any

@color1 = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #0 ; [#uses = 1]
@multiplier = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #0 ; [#uses = 0]
@color2 = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #1 ; [#uses = 0]
@color = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #2 ; [#uses = 0]
@blockName = thread_local global %kernel.BlockName* null, comdat, align 8 #3 ; [#uses = 1]

; [#uses = 0]
; Function Attrs: uwtable
define i32 @main() #4 comdat {
  %scale = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 2, size/byte = 1]
  %.sret_tmp = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 1, size/byte = 1]
  %1 = bitcast %"shader.builtin.Vector!(float, 4LU).Vector"* %scale to i8* ; [#uses = 1]
  call void @llvm.memset.p0i8.i64(i8* align 1 %1, i8 0, i64 1, i1 false)
  %2 = call %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned %scale, float 1.000000e+00, float 2.000000e+00, float 1.000000e+00, float 1.000000e+00) #6 ; [#uses = 0]
  %3 = load %kernel.BlockName*, %kernel.BlockName** @blockName ; [#uses = 1]
  %4 = getelementptr inbounds %kernel.BlockName, %kernel.BlockName* %3, i32 0, i32 0 ; [#uses = 1, type = %kernel.S*]
  %5 = getelementptr inbounds %kernel.S, %kernel.S* %4, i32 0, i32 1 ; [#uses = 1, type = [5 x %"shader.builtin.Vector!(float, 4LU).Vector"]*]
  %6 = getelementptr inbounds [5 x %"shader.builtin.Vector!(float, 4LU).Vector"], [5 x %"shader.builtin.Vector!(float, 4LU).Vector"]* %5, i32 0, i64 2 ; [#uses = 1, type = %"shader.builtin.Vector!(float, 4LU).Vector"*]
  call void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2bZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1 %.sret_tmp, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull @color1, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 %6) #7
  ret i32 0
}

; [#uses = 1]
; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #5

; [#uses = 1]
declare %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned, float, float, float, float) #6

; [#uses = 1]
declare void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2bZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #7

; [#uses = 0]
; Function Attrs: uwtable
define weak_odr zeroext i1 @_D4core8internal5array8equality__T8__equalsTyaTyaZQqFNaNbNiNfAyaQdZb({ i64, i8* } %rhs_arg, { i64, i8* } %lhs_arg) #8 comdat {
  %1 = alloca { i64, i8* }, align 8               ; [#uses = 2, size/byte = 16]
  %2 = alloca { i64, i8* }, align 8               ; [#uses = 2, size/byte = 16]
  %.frame = alloca %nest.__equals, align 8        ; [#uses = 3, size/byte = 32]
  store { i64, i8* } %lhs_arg, { i64, i8* }* %1
  store { i64, i8* } %rhs_arg, { i64, i8* }* %2
  %lhs = getelementptr inbounds %nest.__equals, %nest.__equals* %.frame, i32 0, i32 0 ; [#uses = 3, type = { i64, i8* }*]
  %3 = bitcast { i64, i8* }* %lhs to i8*          ; [#uses = 1]
  %4 = bitcast { i64, i8* }* %1 to i8*            ; [#uses = 1]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %3, i8* align 1 %4, i64 16, i1 false)
  %rhs = getelementptr inbounds %nest.__equals, %nest.__equals* %.frame, i32 0, i32 1 ; [#uses = 3, type = { i64, i8* }*]
  %5 = bitcast { i64, i8* }* %rhs to i8*          ; [#uses = 1]
  %6 = bitcast { i64, i8* }* %2 to i8*            ; [#uses = 1]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %5, i8* align 1 %6, i64 16, i1 false)
  %7 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %lhs, i32 0, i32 0 ; [#uses = 1, type = i64*]
  %.len = load i64, i64* %7                       ; [#uses = 1]
  %8 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %rhs, i32 0, i32 0 ; [#uses = 1, type = i64*]
  %.len3 = load i64, i64* %8                      ; [#uses = 1]
  %9 = icmp ne i64 %.len, %.len3                  ; [#uses = 1]
  br i1 %9, label %if, label %endif

if:                                               ; preds = %0
  ret i1 false

dummy.afterreturn:                                ; No predecessors!
  br label %endif

endif:                                            ; preds = %dummy.afterreturn, %0
  %10 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %lhs, i32 0, i32 0 ; [#uses = 1, type = i64*]
  %.len4 = load i64, i64* %10                     ; [#uses = 1]
  %11 = icmp eq i64 %.len4, 0                     ; [#uses = 1]
  br i1 %11, label %andand, label %andandend

andand:                                           ; preds = %endif
  %12 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %rhs, i32 0, i32 0 ; [#uses = 1, type = i64*]
  %.len5 = load i64, i64* %12                     ; [#uses = 1]
  %13 = icmp eq i64 %.len5, 0                     ; [#uses = 1]
  br label %andandend

andandend:                                        ; preds = %andand, %endif
  %andandval = phi i1 [ false, %endif ], [ %13, %andand ] ; [#uses = 1, type = i1]
  br i1 %andandval, label %if6, label %endif7

if6:                                              ; preds = %andandend
  ret i1 true

dummy.afterreturn8:                               ; No predecessors!
  br label %endif7

endif7:                                           ; preds = %dummy.afterreturn8, %andandend
  %14 = bitcast %nest.__equals* %.frame to i8*    ; [#uses = 1]
  %15 = insertvalue { i8*, i1 (i8*)* } undef, i8* %14, 0 ; [#uses = 1]
  %.func = insertvalue { i8*, i1 (i8*)* } %15, i1 (i8*)* @_D4core8internal5array8equality__T8__equalsTyaTyaZQqFAyaQdZ9__lambda3MFNaNbNiNeZb, 1 ; [#uses = 2]
  %.funcptr = extractvalue { i8*, i1 (i8*)* } %.func, 1 ; [#uses = 1]
  %.ptr = extractvalue { i8*, i1 (i8*)* } %.func, 0 ; [#uses = 1]
  %16 = call zeroext i1 %.funcptr(i8* nonnull %.ptr) ; [#uses = 1]
  ret i1 %16
}

; [#uses = 2]
; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #5

; [#uses = 1]
; Function Attrs: uwtable
define weak_odr zeroext i1 @_D4core8internal5array8equality__T8__equalsTyaTyaZQqFAyaQdZ9__lambda3MFNaNbNiNeZb(i8* nonnull %.nest_arg) #8 comdat {
  %1 = bitcast i8* %.nest_arg to %nest.__equals*  ; [#uses = 1]
  %lhs = getelementptr inbounds %nest.__equals, %nest.__equals* %1, i32 0, i32 0 ; [#uses = 1, type = { i64, i8* }*]
  %2 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %lhs, i32 0, i32 1 ; [#uses = 1, type = i8**]
  %.ptr = load i8*, i8** %2                       ; [#uses = 1]
  %3 = bitcast i8* %.nest_arg to %nest.__equals*  ; [#uses = 1]
  %rhs = getelementptr inbounds %nest.__equals, %nest.__equals* %3, i32 0, i32 1 ; [#uses = 1, type = { i64, i8* }*]
  %4 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %rhs, i32 0, i32 1 ; [#uses = 1, type = i8**]
  %.ptr1 = load i8*, i8** %4                      ; [#uses = 1]
  %5 = bitcast i8* %.nest_arg to %nest.__equals*  ; [#uses = 1]
  %lhs2 = getelementptr inbounds %nest.__equals, %nest.__equals* %5, i32 0, i32 0 ; [#uses = 1, type = { i64, i8* }*]
  %6 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %lhs2, i32 0, i32 0 ; [#uses = 1, type = i64*]
  %.len = load i64, i64* %6                       ; [#uses = 1]
  %7 = mul i64 %.len, 1                           ; [#uses = 1]
  %8 = call i32 @memcmp(i8* %.ptr, i8* %.ptr1, i64 %7) #9 ; [#uses = 1]
  %9 = icmp eq i32 %8, 0                          ; [#uses = 1]
  ret i1 %9
}

; [#uses = 1]
declare i32 @memcmp(i8*, i8*, i64) #9

; [#uses = 0]
; Function Attrs: uwtable
define weak_odr i8* @_D4core8internal5array8equality__T8__equalsTyaTyaZQqFAyaQdZ__T2atTyaZQhFNaNbNcNiNeQBdmZya(i64 %i_arg, { i64, i8* } %r_arg) #8 comdat {
  %r = alloca { i64, i8* }, align 8               ; [#uses = 2, size/byte = 16]
  %i = alloca i64, align 8                        ; [#uses = 2, size/byte = 8]
  store { i64, i8* } %r_arg, { i64, i8* }* %r
  store i64 %i_arg, i64* %i
  %1 = getelementptr inbounds { i64, i8* }, { i64, i8* }* %r, i32 0, i32 1 ; [#uses = 1, type = i8**]
  %.ptr = load i8*, i8** %1                       ; [#uses = 1]
  %2 = load i64, i64* %i                          ; [#uses = 1]
  %3 = getelementptr inbounds i8, i8* %.ptr, i64 %2 ; [#uses = 1, type = i8*]
  ret i8* %3
}

attributes #0 = { "storageClass"="Input" }
attributes #1 = { "decoration"="NoPerspective" "storageClass"="Input" }
attributes #2 = { "storageClass"="Output" }
attributes #3 = { "storageClass"="Uniform" }
attributes #4 = { uwtable "entryPoint"="Fragment" "execMode"="OriginLowerLeft" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #5 = { argmemonly nounwind }
attributes #6 = { "composite"="poyo" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #7 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "operator"="FAdd" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #8 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #9 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
