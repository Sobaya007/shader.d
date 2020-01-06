; ModuleID = 'vertex.d'
source_filename = "vertex.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"shader.builtin.Vector!(float, 2LU).Vector" = type { [1 x i8] }
%shader.builtin.gl_PerVertex = type { %"shader.builtin.Vector!(float, 4LU).Vector", [3 x i8], float, [1 x float], [1 x float] }
%"shader.builtin.Vector!(float, 4LU).Vector" = type { [1 x i8] }

$vertMain = comdat any

$pos = comdat any

@pos = thread_local global %"shader.builtin.Vector!(float, 2LU).Vector" zeroinitializer, comdat, align 1 #0 ; [#uses = 2]
@_D6shader7builtin9vertexOutSQBaQw12gl_PerVertex = external thread_local global %shader.builtin.gl_PerVertex, align 4 #1 ; [#uses = 1]

; [#uses = 0]
; Function Attrs: uwtable
define void @vertMain() #2 comdat {
  %.structliteral = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 2, size/byte = 1]
  %1 = getelementptr inbounds %shader.builtin.gl_PerVertex, %shader.builtin.gl_PerVertex* @_D6shader7builtin9vertexOutSQBaQw12gl_PerVertex, i32 0, i32 0 ; [#uses = 0, type = %"shader.builtin.Vector!(float, 4LU).Vector"*]
  %2 = bitcast %"shader.builtin.Vector!(float, 4LU).Vector"* %.structliteral to i8* ; [#uses = 1]
  %.padding = getelementptr inbounds i8, i8* %2, i32 0 ; [#uses = 1, type = i8*]
  call void @llvm.memset.p0i8.i64(i8* align 1 %.padding, i8 0, i64 1, i1 false)
  %3 = call float @_D6shader7builtin__T6VectorTfVmi2ZQo7opIndexMFmZf(%"shader.builtin.Vector!(float, 2LU).Vector"* nonnull @pos, i64 0) #5 ; [#uses = 1]
  %4 = call float @_D6shader7builtin__T6VectorTfVmi2ZQo7opIndexMFmZf(%"shader.builtin.Vector!(float, 2LU).Vector"* nonnull @pos, i64 1) #5 ; [#uses = 1]
  %5 = call %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned %.structliteral, float 1.000000e+00, float 0.000000e+00, float %4, float %3) #4 ; [#uses = 0]
  ret void
}

; [#uses = 1]
; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; [#uses = 1]
declare %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcffffZSQBzQBv__TQBqTfVmi4ZQCa(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned, float, float, float, float) #4

; [#uses = 2]
declare float @_D6shader7builtin__T6VectorTfVmi2ZQo7opIndexMFmZf(%"shader.builtin.Vector!(float, 2LU).Vector"* nonnull, i64) #5

attributes #0 = { "storageClass"="Input" }
attributes #1 = { "storageClass"="Output" }
attributes #2 = { uwtable "entryPoint"="Vertex" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { "composite"="poyo" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #5 = { "index" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
