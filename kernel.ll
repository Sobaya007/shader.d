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

@color1 = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #0 ; [#uses = 2]
@multiplier = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #0 ; [#uses = 1]
@color2 = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #1 ; [#uses = 1]
@color = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #2 ; [#uses = 5]
@_D6kernel1S6__initZ = constant %kernel.S <{ i8 0, [15 x i8] zeroinitializer, [5 x <4 x float>] [<4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>], i32 0 }>, comdat, align 1 ; [#uses = 0]
@_D6kernel9BlockName6__initZ = constant %kernel.BlockName { %kernel.S <{ i8 0, [15 x i8] zeroinitializer, [5 x <4 x float>] [<4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>], i32 0 }>, i8 0 }, comdat, align 1 ; [#uses = 0]
@blockName = thread_local global %kernel.BlockName* null, comdat, align 8 #3 ; [#uses = 3]

; [#uses = 0]
; Function Attrs: uwtable
define i32 @main() #4 comdat {
  %scale = alloca <4 x float>, align 16           ; [#uses = 2, size/byte = 16]
  %i = alloca i32, align 4                        ; [#uses = 4, size/byte = 4]
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 2.000000e+00, float 1.000000e+00>, <4 x float>* %scale
  %1 = load <4 x float>, <4 x float>* @color1     ; [#uses = 1]
  %2 = load %kernel.BlockName*, %kernel.BlockName** @blockName ; [#uses = 1]
  %3 = getelementptr inbounds %kernel.BlockName, %kernel.BlockName* %2, i32 0, i32 0 ; [#uses = 1, type = %kernel.S*]
  %4 = getelementptr inbounds %kernel.S, %kernel.S* %3, i32 0, i32 2 ; [#uses = 1, type = [5 x <4 x float>]*]
  %5 = getelementptr inbounds [5 x <4 x float>], [5 x <4 x float>]* %4, i32 0, i64 2 ; [#uses = 1, type = <4 x float>*]
  %6 = load <4 x float>, <4 x float>* %5          ; [#uses = 1]
  %7 = fadd <4 x float> %1, %6                    ; [#uses = 1]
  store <4 x float> %7, <4 x float>* @color
  %8 = load %kernel.BlockName*, %kernel.BlockName** @blockName ; [#uses = 1]
  %9 = getelementptr inbounds %kernel.BlockName, %kernel.BlockName* %8, i32 0, i32 1 ; [#uses = 1, type = i8*]
  %10 = load i8, i8* %9                           ; [#uses = 1]
  %11 = trunc i8 %10 to i1                        ; [#uses = 1]
  br i1 %11, label %if, label %else

if:                                               ; preds = %0
  %12 = load <4 x float>, <4 x float>* @color1    ; [#uses = 1]
  %13 = load %kernel.BlockName*, %kernel.BlockName** @blockName ; [#uses = 1]
  %14 = getelementptr inbounds %kernel.BlockName, %kernel.BlockName* %13, i32 0, i32 0 ; [#uses = 1, type = %kernel.S*]
  %15 = getelementptr inbounds %kernel.S, %kernel.S* %14, i32 0, i32 2 ; [#uses = 1, type = [5 x <4 x float>]*]
  %16 = getelementptr inbounds [5 x <4 x float>], [5 x <4 x float>]* %15, i32 0, i64 2 ; [#uses = 1, type = <4 x float>*]
  %17 = load <4 x float>, <4 x float>* %16        ; [#uses = 1]
  %18 = fadd <4 x float> %12, %17                 ; [#uses = 1]
  store <4 x float> %18, <4 x float>* @color
  br label %endif

else:                                             ; preds = %0
  %19 = load <4 x float>, <4 x float>* @color2    ; [#uses = 1]
  %20 = call <4 x float> @_D6shader7builtin__T4sqrtTNhG4fZQmFQjZQm(<4 x float> %19) #5 ; [#uses = 1]
  %21 = load <4 x float>, <4 x float>* %scale     ; [#uses = 1]
  %22 = fmul <4 x float> %20, %21                 ; [#uses = 1]
  store <4 x float> %22, <4 x float>* @color
  br label %endif

endif:                                            ; preds = %else, %if
  store i32 0, i32* %i
  br label %forcond

forcond:                                          ; preds = %forinc, %endif
  %23 = load i32, i32* %i                         ; [#uses = 1]
  %24 = icmp slt i32 %23, 4                       ; [#uses = 1]
  br i1 %24, label %forbody, label %endfor

forbody:                                          ; preds = %forcond
  %25 = load <4 x float>, <4 x float>* @multiplier ; [#uses = 1]
  %26 = load <4 x float>, <4 x float>* @color     ; [#uses = 1]
  %27 = fmul <4 x float> %26, %25                 ; [#uses = 1]
  store <4 x float> %27, <4 x float>* @color
  br label %forinc

forinc:                                           ; preds = %forbody
  %28 = load i32, i32* %i                         ; [#uses = 1]
  %29 = add i32 %28, 1                            ; [#uses = 1]
  store i32 %29, i32* %i
  br label %forcond

endfor:                                           ; preds = %forcond
  ret i32 0
}

; [#uses = 1]
declare <4 x float> @_D6shader7builtin__T4sqrtTNhG4fZQmFQjZQm(<4 x float>) #5

attributes #0 = { "storageClass"="Input" }
attributes #1 = { "decoration"="NoPerspective" "storageClass"="Input" }
attributes #2 = { "storageClass"="Output" }
attributes #3 = { "storageClass"="Uniform" }
attributes #4 = { uwtable "entryPoint"="Fragment" "execMode"="OriginLowerLeft" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #5 = { "extend"="GLSL.std.450:Sqrt" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
