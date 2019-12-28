; ModuleID = 'kernel.d'
source_filename = "kernel.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%kernel.S = type <{ i8, [15 x i8], [5 x <4 x float>], i32 }>
%kernel.BlockName = type { %kernel.S, i8 }

$main = comdat any

$color1 = comdat any

$multiplier = comdat any

$color2 = comdat any

$color = comdat any

$_D6kernel1S6__initZ = comdat any

$_D6kernel9BlockName6__initZ = comdat any

$blockName = comdat any

@color1 = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #0 ; [#uses = 1]
@multiplier = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #0 ; [#uses = 0]
@color2 = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #1 ; [#uses = 0]
@color = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #2 ; [#uses = 1]
@_D6kernel1S6__initZ = constant %kernel.S <{ i8 0, [15 x i8] zeroinitializer, [5 x <4 x float>] [<4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>], i32 0 }>, comdat, align 1 ; [#uses = 0]
@_D6kernel9BlockName6__initZ = constant %kernel.BlockName { %kernel.S <{ i8 0, [15 x i8] zeroinitializer, [5 x <4 x float>] [<4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>], i32 0 }>, i8 0 }, comdat, align 1 ; [#uses = 0]
@blockName = thread_local global %kernel.BlockName* null, comdat, align 8 #3 ; [#uses = 1]

; [#uses = 0]
; Function Attrs: uwtable
define i32 @main() #4 comdat {
  %scale = alloca <4 x float>, align 16           ; [#uses = 1, size/byte = 16]
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 2.000000e+00, float 1.000000e+00>, <4 x float>* %scale
  %1 = load <4 x float>, <4 x float>* @color1     ; [#uses = 1]
  %2 = load %kernel.BlockName*, %kernel.BlockName** @blockName ; [#uses = 1]
  %3 = getelementptr inbounds %kernel.BlockName, %kernel.BlockName* %2, i32 0, i32 0 ; [#uses = 1, type = %kernel.S*]
  %4 = getelementptr inbounds %kernel.S, %kernel.S* %3, i32 0, i32 2 ; [#uses = 1, type = [5 x <4 x float>]*]
  %5 = getelementptr inbounds [5 x <4 x float>], [5 x <4 x float>]* %4, i32 0, i64 2 ; [#uses = 1, type = <4 x float>*]
  %6 = load <4 x float>, <4 x float>* %5          ; [#uses = 1]
  %7 = fadd <4 x float> %1, %6                    ; [#uses = 1]
  store <4 x float> %7, <4 x float>* @color
  ret i32 0
}

attributes #0 = { "storageClass"="Input" }
attributes #1 = { "decoration"="NoPerspective" "storageClass"="Input" }
attributes #2 = { "storageClass"="Output" }
attributes #3 = { "storageClass"="Uniform" }
attributes #4 = { uwtable "entryPoint"="Fragment" "execMode"="OriginLowerLeft" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
