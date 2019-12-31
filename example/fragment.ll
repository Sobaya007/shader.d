; ModuleID = 'fragment.d'
source_filename = "fragment.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

$fragMain = comdat any

$color = comdat any

@color = thread_local global <4 x float> <float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000, float 0x7FF8000000000000>, comdat, align 16 #0 ; [#uses = 1]

; [#uses = 0]
; Function Attrs: uwtable
define void @fragMain() #1 comdat {
  %1 = alloca <4 x float>, align 16               ; [#uses = 2, size/byte = 16]
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, <4 x float>* %1
  %2 = load <4 x float>, <4 x float>* %1          ; [#uses = 1]
  store <4 x float> %2, <4 x float>* @color
  ret void
}

attributes #0 = { "storageClass"="Output" }
attributes #1 = { uwtable "entryPoint"="Fragment" "execMode"="OriginUpperLeft" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
