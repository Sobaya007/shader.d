; ModuleID = 'kernel.d'
source_filename = "kernel.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%"shader.builtin.Vector!(float, 4LU).Vector" = type { [1 x i8] }
%kernel.BlockName = type { %kernel.S, i8, [3 x i8] }
%kernel.S = type { i8, [5 x %"shader.builtin.Vector!(float, 4LU).Vector"], [2 x i8], i32 }

$main = comdat any

$_D6kernel6color1S6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D6kernel10multiplierS6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D6kernel6color2S6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D6kernel5colorS6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D6kernel9blockNamePSQt9BlockName = comdat any

@_D6kernel6color1S6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #0 ; [#uses = 1]
@_D6kernel10multiplierS6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #0 ; [#uses = 1]
@_D6kernel6color2S6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #0 ; [#uses = 1]
@_D6kernel5colorS6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 #1 ; [#uses = 1]
@_D6kernel9blockNamePSQt9BlockName = thread_local global %kernel.BlockName* null, comdat, align 8 #2 ; [#uses = 1]

; [#uses = 0]
; Function Attrs: uwtable
define i32 @main() #3 comdat {
  %__withSym = alloca %kernel.BlockName*, align 8 ; [#uses = 3, size/byte = 8]
  %scale = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 3, size/byte = 1]
  %arrayliteral = alloca [4 x float], align 4     ; [#uses = 2, size/byte = 16]
  %.sret_tmp = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 1, size/byte = 1]
  %.sret_tmp1 = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 2, size/byte = 1]
  %.sret_tmp2 = alloca %"shader.builtin.Vector!(float, 4LU).Vector", align 1 ; [#uses = 1, size/byte = 1]
  %i = alloca i32, align 4                        ; [#uses = 4, size/byte = 4]
  %1 = load %kernel.BlockName*, %kernel.BlockName** @_D6kernel9blockNamePSQt9BlockName ; [#uses = 1]
  store %kernel.BlockName* %1, %kernel.BlockName** %__withSym
  %2 = bitcast %"shader.builtin.Vector!(float, 4LU).Vector"* %scale to i8* ; [#uses = 1]
  call void @llvm.memset.p0i8.i64(i8* align 1 %2, i8 0, i64 1, i1 false)
  store [4 x float] [float 1.000000e+00, float 1.000000e+00, float 2.000000e+00, float 1.000000e+00], [4 x float]* %arrayliteral
  %.loadFromMemory_bitCastAddress = bitcast [4 x float]* %arrayliteral to { double, double }* ; [#uses = 1]
  %.X86_64_C_struct_rewrite_putResult = load { double, double }, { double, double }* %.loadFromMemory_bitCastAddress ; [#uses = 1]
  %3 = call %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcG4fXSQByQBu__TQBpTfVmi4ZQBz(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned %scale, { double, double } %.X86_64_C_struct_rewrite_putResult) #5 ; [#uses = 0]
  %4 = load %kernel.BlockName*, %kernel.BlockName** %__withSym ; [#uses = 1]
  %5 = getelementptr inbounds %kernel.BlockName, %kernel.BlockName* %4, i32 0, i32 1 ; [#uses = 1, type = i8*]
  %6 = load i8, i8* %5                            ; [#uses = 1]
  %7 = trunc i8 %6 to i1                          ; [#uses = 1]
  br i1 %7, label %if, label %else

if:                                               ; preds = %0
  %8 = load %kernel.BlockName*, %kernel.BlockName** %__withSym ; [#uses = 1]
  %9 = getelementptr inbounds %kernel.BlockName, %kernel.BlockName* %8, i32 0, i32 0 ; [#uses = 1, type = %kernel.S*]
  %10 = getelementptr inbounds %kernel.S, %kernel.S* %9, i32 0, i32 1 ; [#uses = 1, type = [5 x %"shader.builtin.Vector!(float, 4LU).Vector"]*]
  %11 = getelementptr inbounds [5 x %"shader.builtin.Vector!(float, 4LU).Vector"], [5 x %"shader.builtin.Vector!(float, 4LU).Vector"]* %10, i32 0, i64 2 ; [#uses = 1, type = %"shader.builtin.Vector!(float, 4LU).Vector"*]
  call void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2bZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1 %.sret_tmp, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull @_D6kernel6color1S6shader7builtin__T6VectorTfVmi4ZQo, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 %11) #5
  br label %endif

else:                                             ; preds = %0
  call void @_D6shader7builtin__T4sqrtTSQzQu__T6VectorTfVmi4ZQoZQBfFQBdZQBh(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1 %.sret_tmp1, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 @_D6kernel6color2S6shader7builtin__T6VectorTfVmi4ZQo) #5
  call void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2aZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1 %.sret_tmp2, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull %.sret_tmp1, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 %scale) #5
  br label %endif

endif:                                            ; preds = %else, %if
  store i32 0, i32* %i
  br label %forcond

forcond:                                          ; preds = %forinc, %endif
  %12 = load i32, i32* %i                         ; [#uses = 1]
  %13 = icmp slt i32 %12, 4                       ; [#uses = 1]
  br i1 %13, label %forbody, label %endfor

forbody:                                          ; preds = %forcond
  call void @_D6shader7builtin__T6VectorTfVmi4ZQo__T10opOpAssignVAyaa1_2aZQwMFSQCmQCi__TQCdTfVmi4ZQCnZv(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull @_D6kernel5colorS6shader7builtin__T6VectorTfVmi4ZQo, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 @_D6kernel10multiplierS6shader7builtin__T6VectorTfVmi4ZQo) #5
  br label %forinc

forinc:                                           ; preds = %forbody
  %14 = load i32, i32* %i                         ; [#uses = 1]
  %15 = add i32 %14, 1                            ; [#uses = 1]
  store i32 %15, i32* %i
  br label %forcond

endfor:                                           ; preds = %forcond
  ret i32 0
}

; [#uses = 1]
; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #4

; [#uses = 1]
declare %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcG4fXSQByQBu__TQBpTfVmi4ZQBz(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned, { double, double }) #5

; [#uses = 1]
declare void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2bZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #5

; [#uses = 1]
declare void @_D6shader7builtin__T4sqrtTSQzQu__T6VectorTfVmi4ZQoZQBfFQBdZQBh(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #5

; [#uses = 1]
declare void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2aZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #5

; [#uses = 1]
declare void @_D6shader7builtin__T6VectorTfVmi4ZQo__T10opOpAssignVAyaa1_2aZQwMFSQCmQCi__TQCdTfVmi4ZQCnZv(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #5

attributes #0 = { "storageClass"="Input" }
attributes #1 = { "storageClass"="Output" }
attributes #2 = { "decoration"="Uniform" }
attributes #3 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #4 = { argmemonly nounwind }
attributes #5 = { "extend"="GLSL.std.450:Sqrt" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }

!llvm.linker.options = !{}
!llvm.ident = !{!0}

!0 = !{!"ldc version 1.19.0-git-08b3ee3-dirty"}
