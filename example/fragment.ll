; ModuleID = 'fragment.d'
source_filename = "fragment.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"shader.builtin.Vector!(float, 4LU).Vector" = type { [1 x i8] }

$fragMain = comdat any

$color = comdat any

@color = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #0 ; [#uses = 0]

; [#uses = 0]
; Function Attrs: uwtable
define void @fragMain() #1 comdat {
  %.structliteral = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 2, size/byte = 1]
  %1 = bitcast %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral to i8* ; [#uses = 1]
  %.padding = getelementptr inbounds i8, i8* %1, i32 0 ; [#uses = 1, type = i8*]
  call void @llvm.memset.p0i8.i64(i8* align 1 %.padding, i8 0, i64 1, i1 false)
  %2 = call %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned %.structliteral, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00) #3 ; [#uses = 0]
  ret void
}

; [#uses = 1]
; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; [#uses = 1]
declare %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned, float, float, float, float) #3

attributes #0 = { "storageClass"="Output" }
attributes #1 = { uwtable "entryPoint"="Fragment" "execMode"="OriginUpperLeft" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #2 = { argmemonly nounwind }
attributes #3 = { "composite"="poyo" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
