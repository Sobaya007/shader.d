; ModuleID = 'vertex.d'
source_filename = "vertex.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"shader.builtin.Vector!(float, 2LU).Vector" = type { float, float }
%shader.builtin.gl_PerVertex = type { %"shader.builtin.Vector!(float, 4LU).Vector", float, [1 x float], [1 x float] }
%"shader.builtin.Vector!(float, 4LU).Vector" = type { float, float, float, float }

$vertMain = comdat any

$pos = comdat any

@pos = thread_local global %"shader.builtin.Vector!(float, 2LU).Vector" { float 0x7FF8000000000000, float 0x7FF8000000000000 }, comdat, align 4 #0 ; [#uses = 2]
@_D6shader7builtin9vertexOutSQBaQw12gl_PerVertex = external thread_local global %shader.builtin.gl_PerVertex, align 4 #1 ; [#uses = 1]

; [#uses = 0]
; Function Attrs: uwtable
define void @vertMain() #2 comdat {
  %.structliteral = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 4 ; [#uses = 6, size/byte = 16]
  %1 = getelementptr inbounds %shader.builtin.gl_PerVertex, %shader.builtin.gl_PerVertex* @_D6shader7builtin9vertexOutSQBaQw12gl_PerVertex, i32 0, i32 0 ; [#uses = 1, type = %"shader.builtin.Vector!(float, 4LU).Vector"*]
  %2 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 0 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %2
  %3 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 1 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %3
  %4 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 2 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %4
  %5 = getelementptr inbounds %"shader.builtin.Vector!(float, 4LU).Vector", %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral, i32 0, i32 3 ; [#uses = 1, type = float*]
  store float 0x7FF8000000000000, float* %5
  %6 = call float @_D6shader7builtin__T6VectorTfVmi2ZQo7opIndexMFmZf(%"shader.builtin.Vector!(float, 2LU).Vector"* nonnull @pos, i64 0) #4 ; [#uses = 1]
  %7 = call float @_D6shader7builtin__T6VectorTfVmi2ZQo7opIndexMFmZf(%"shader.builtin.Vector!(float, 2LU).Vector"* nonnull @pos, i64 1) #4 ; [#uses = 1]
  %8 = call %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned %.structliteral, float 1.000000e+00, float 0.000000e+00, float %7, float %6) #3 ; [#uses = 0]
  %9 = bitcast %"shader.builtin.Vector!(float, 4LU).Vector"* %1 to i8* ; [#uses = 1]
  %10 = bitcast %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral to i8* ; [#uses = 1]
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %9, i8* align 1 %10, i64 16, i1 false)
  ret void
}

; [#uses = 1]
declare %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned, float, float, float, float) #3

; [#uses = 2]
declare float @_D6shader7builtin__T6VectorTfVmi2ZQo7opIndexMFmZf(%"shader.builtin.Vector!(float, 2LU).Vector"* nonnull, i64) #4

; [#uses = 1]
; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #5

attributes #0 = { "storageClass"="Input" }
attributes #1 = { "storageClass"="Output" }
attributes #2 = { uwtable "entryPoint"="Vertex" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #3 = { "composite"="poyo" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #4 = { "index" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #5 = { argmemonly nounwind }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
