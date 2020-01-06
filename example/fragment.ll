; ModuleID = 'fragment.d'
source_filename = "fragment.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"shader.builtin.Vector!(float, 4LU).Vector" = type { float, float, float, float }

$fragMain = comdat any

$color = comdat any

@color = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" { float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000 }, comdat, align 4 #0 ; [#uses = 1]

; [#uses = 0]
; Function Attrs: uwtable
define void @fragMain() #1 comdat {
  %.structliteral = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 4 ; [#uses = 6, size/byte = 16]
  %1 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 0 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %1
  %2 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 1 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %2
  %3 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 2 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %3
  %4 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 3 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %4
  %5 = call %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned %.structliteral, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00) #2 ; [#uses = 0]
  %6 = bitcast %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral to i8* ; [#uses = 1]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 bitcast (%"shader.builtin.Vector!(float, 4LU).Vector"* @color to i8*), i8* align 1 %6, i64 16, i1 false)
  ret void
}

; [#uses = 1]
declare %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned, float, float, float, float) #2

; [#uses = 1]
; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #3

attributes #0 = { "storageClass"="Output" }
attributes #1 = { uwtable "entryPoint"="Fragment" "execMode"="OriginUpperLeft" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #2 = { "composite"="poyo" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #3 = { argmemonly nounwind }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
