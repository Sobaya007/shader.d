; ModuleID = 'vertex.d'
source_filename = "vertex.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%vertex.S = type <{ i8, [15 x i8], [5 x <4 x float>], i32 }>
%vertex.BlockName = type { %vertex.S, i8 }

$fragMain = comdat any

$color1 = comdat any

$multiplier = comdat any

$color2 = comdat any

$color = comdat any

$_D6vertex1S6__initZ = comdat any

$_D6vertex9BlockName6__initZ = comdat any

$blockName = comdat any

@color1 = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #0 ; [#uses = 1]
@multiplier = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #0 ; [#uses = 1]
@color2 = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #1 ; [#uses = 1]
@color = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #2 ; [#uses = 4]
@_D6vertex1S6__initZ = constant %vertex.S <{ i8 0, [15 x i8] zeroinitializer, [5 x <4 x float>] [<4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>], i32 0 }>, comdat, align 1 ; [#uses = 0]
@_D6vertex9BlockName6__initZ = constant %vertex.BlockName { %vertex.S <{ i8 0, [15 x i8] zeroinitializer, [5 x <4 x float>] [<4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>], i32 0 }>, i8 0 }, comdat, align 1 ; [#uses = 0]
@blockName = thread_local global %vertex.BlockName { %vertex.S <{ i8 0, [15 x i8] zeroinitializer, [5 x <4 x float>] [<4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>], i32 0 }>, i8 0 }, comdat, align 1 #3 ; [#uses = 2]

; [#uses = 0]
; Function Attrs: uwtable
define void @fragMain() #4 comdat {
  %scale = alloca <4 x float>, align 16           ; [#uses = 2, size/byte = 16]
  %i = alloca i32, align 4                        ; [#uses = 4, size/byte = 4]
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 2.000000e+00, float 1.000000e+00>, <4 x float>* %scale
  %1 = getelementptr inbounds %vertex.BlockName, %vertex.BlockName* @blockName, i32 0, i32 1 ; [#uses = 1, type = i8*]
  %2 = load i8, i8* %1                            ; [#uses = 1]
  %3 = trunc i8 %2 to i1                          ; [#uses = 1]
  br i1 %3, label %if, label %else

if:                                               ; preds = %0
  %4 = load <4 x float>, <4 x float>* @color1     ; [#uses = 1]
  %5 = getelementptr inbounds %vertex.BlockName, %vertex.BlockName* @blockName, i32 0, i32 0 ; [#uses = 1, type = %vertex.S*]
  %6 = getelementptr inbounds %vertex.S, %vertex.S* %5, i32 0, i32 2 ; [#uses = 1, type = [5 x <4 x float>]*]
  %7 = getelementptr inbounds [5 x <4 x float>], [5 x <4 x float>]* %6, i32 0, i64 2 ; [#uses = 1, type = <4 x float>*]
  %8 = load <4 x float>, <4 x float>* %7          ; [#uses = 1]
  %9 = fadd <4 x float> %4, %8                    ; [#uses = 1]
  store <4 x float> %9, <4 x float>* @color
  br label %endif

else:                                             ; preds = %0
  %10 = load <4 x float>, <4 x float>* @color2    ; [#uses = 1]
  %11 = call <4 x float> @_D6shader7builtin__T4sqrtTNhG4fZQmFQjZQm(<4 x float> %10) #5 ; [#uses = 1]
  %12 = load <4 x float>, <4 x float>* %scale     ; [#uses = 1]
  %13 = fmul <4 x float> %11, %12                 ; [#uses = 1]
  store <4 x float> %13, <4 x float>* @color
  br label %endif

endif:                                            ; preds = %else, %if
  store i32 0, i32* %i
  br label %forcond

forcond:                                          ; preds = %forinc, %endif
  %14 = load i32, i32* %i                         ; [#uses = 1]
  %15 = icmp slt i32 %14, 4                       ; [#uses = 1]
  br i1 %15, label %forbody, label %endfor

forbody:                                          ; preds = %forcond
  %16 = load <4 x float>, <4 x float>* @multiplier ; [#uses = 1]
  %17 = load <4 x float>, <4 x float>* @color     ; [#uses = 1]
  %18 = fmul <4 x float> %17, %16                 ; [#uses = 1]
  store <4 x float> %18, <4 x float>* @color
  br label %forinc

forinc:                                           ; preds = %forbody
  %19 = load i32, i32* %i                         ; [#uses = 1]
  %20 = add i32 %19, 1                            ; [#uses = 1]
  store i32 %20, i32* %i
  br label %forcond

endfor:                                           ; preds = %forcond
  ret void
}

; [#uses = 1]
declare <4 x float> @_D6shader7builtin__T4sqrtTNhG4fZQmFQjZQm(<4 x float>) #5

attributes #0 = { "storageClass"="Input" }
attributes #1 = { "decoration"="NoPerspective" "storageClass"="Input" }
attributes #2 = { "storageClass"="Output" }
attributes #3 = { "storageClass"="Uniform" }
attributes #4 = { uwtable "entryPoint"="Fragment" "execMode"="OriginUpperLeft" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #5 = { "extend"="GLSL.std.450:Sqrt" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
