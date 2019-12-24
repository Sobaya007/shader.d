; ModuleID = 'kernel.d'
source_filename = "kernel.d"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%0 = type { i32, i32, [7 x i8] }
%"shader.builtin.Vector!(float, 4LU).Vector" = type { [1 x i8] }
%object.TypeInfo_Struct = type { [19 x i8*]*, i8*, { i64, i8* }, { i64, i8* }, i64 (i8*)*, i1 (i8*, i8*)*, i32 (i8*, i8*)*, { i64, i8* } (i8*)*, i32, [4 x i8], void (i8*)*, void (i8*)*, i32, [4 x i8], %object.TypeInfo*, %object.TypeInfo*, i8* }
%object.TypeInfo = type { [19 x i8*]*, i8* }
%kernel.BlockName = type { %kernel.S, i8, [3 x i8] }
%kernel.S = type { i8, [5 x %"shader.builtin.Vector!(float, 4LU).Vector"], [2 x i8], i32 }
%object.ModuleInfo = type { i32, i32 }

$_Dmain = comdat any

$main = comdat any

$_D6kernel6color1S6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D6kernel10multiplierS6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D6kernel6color2S6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D6kernel5colorS6shader7builtin__T6VectorTfVmi4ZQo = comdat any

$_D19TypeInfo_S6kernel1S6__initZ = comdat any

$_D27TypeInfo_S6kernel9BlockName6__initZ = comdat any

$_D6kernel9blockNamePSQt9BlockName = comdat any

$_D6kernel12__ModuleInfoZ = comdat any

@_D6kernel6color1S6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 ; [#uses = 1]
@_D6kernel10multiplierS6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 ; [#uses = 1]
@_D6kernel6color2S6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 ; [#uses = 1]
@_D6kernel5colorS6shader7builtin__T6VectorTfVmi4ZQo = thread_local global %"shader.builtin.Vector!(float, 4LU).Vector" zeroinitializer, comdat, align 1 ; [#uses = 1]
@_D19TypeInfo_S6kernel1S6__initZ = linkonce_odr global %object.TypeInfo_Struct { [19 x i8*]* @_D15TypeInfo_Struct6__vtblZ, i8* null, { i64, i8* } { i64 8, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i32 0, i32 0) }, { i64, i8* } { i64 12, i8* null }, i64 (i8*)* null, i1 (i8*, i8*)* null, i32 (i8*, i8*)* null, { i64, i8* } (i8*)* null, i32 0, [4 x i8] zeroinitializer, void (i8*)* null, void (i8*)* null, i32 4, [4 x i8] zeroinitializer, %object.TypeInfo* null, %object.TypeInfo* null, i8* null }, comdat ; [#uses = 0]
@_D15TypeInfo_Struct6__vtblZ = external constant [19 x i8*] ; [#uses = 2]
@.str = private unnamed_addr constant [9 x i8] c"kernel.S\00" ; [#uses = 1]
@_D27TypeInfo_S6kernel9BlockName6__initZ = linkonce_odr global %object.TypeInfo_Struct { [19 x i8*]* @_D15TypeInfo_Struct6__vtblZ, i8* null, { i64, i8* } { i64 16, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.1, i32 0, i32 0) }, { i64, i8* } { i64 16, i8* null }, i64 (i8*)* null, i1 (i8*, i8*)* null, i32 (i8*, i8*)* null, { i64, i8* } (i8*)* null, i32 0, [4 x i8] zeroinitializer, void (i8*)* null, void (i8*)* null, i32 4, [4 x i8] zeroinitializer, %object.TypeInfo* null, %object.TypeInfo* null, i8* null }, comdat ; [#uses = 0]
@.str.1 = private unnamed_addr constant [17 x i8] c"kernel.BlockName\00" ; [#uses = 1]
@_D6kernel9blockNamePSQt9BlockName = thread_local global %kernel.BlockName* null, comdat, align 8 ; [#uses = 1]
@_D6kernel12__ModuleInfoZ = global %0 { i32 -2147483644, i32 0, [7 x i8] c"kernel\00" }, comdat ; [#uses = 1]
@_D6kernel11__moduleRefZ = linkonce_odr hidden global %object.ModuleInfo* bitcast (%0* @_D6kernel12__ModuleInfoZ to %object.ModuleInfo*), section "__minfo" ; [#uses = 1]
@__start___minfo = external hidden global %object.ModuleInfo* ; [#uses = 1]
@__stop___minfo = external hidden global %object.ModuleInfo* ; [#uses = 1]
@ldc.dso_slot = linkonce_odr hidden global i8* null ; [#uses = 1]
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @ldc.register_dso, i8* bitcast (void ()* @ldc.register_dso to i8*) }] ; [#uses = 0]
@llvm.global_dtors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @ldc.register_dso, i8* bitcast (void ()* @ldc.register_dso to i8*) }] ; [#uses = 0]
@__bss_start = extern_weak global i8*             ; [#uses = 1]
@_d_execBssBegAddr = global i8* bitcast (i8** @__bss_start to i8*) ; [#uses = 0]
@_end = extern_weak global i8*                    ; [#uses = 1]
@_d_execBssEndAddr = global i8* bitcast (i8** @_end to i8*) ; [#uses = 0]
@llvm.used = appending global [1 x i8*] [i8* bitcast (%object.ModuleInfo** @_D6kernel11__moduleRefZ to i8*)], section "llvm.metadata" ; [#uses = 0]

; [#uses = 1]
; Function Attrs: uwtable
define i32 @_Dmain({ i64, { i64, i8* }* } %unnamed) #0 comdat {
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
  %3 = call %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcG4fXSQByQBu__TQBpTfVmi4ZQBz(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned %scale, { double, double } %.X86_64_C_struct_rewrite_putResult) #2 ; [#uses = 0]
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
  call void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2bZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1 %.sret_tmp, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull @_D6kernel6color1S6shader7builtin__T6VectorTfVmi4ZQo, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 %11) #2
  br label %endif

else:                                             ; preds = %0
  call void @_D6shader7builtin__T4sqrtTSQzQu__T6VectorTfVmi4ZQoZQBfFQBdZQBh(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1 %.sret_tmp1, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 @_D6kernel6color2S6shader7builtin__T6VectorTfVmi4ZQo) #3
  call void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2aZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1 %.sret_tmp2, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull %.sret_tmp1, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 %scale) #2
  br label %endif

endif:                                            ; preds = %else, %if
  store i32 0, i32* %i
  br label %forcond

forcond:                                          ; preds = %forinc, %endif
  %12 = load i32, i32* %i                         ; [#uses = 1]
  %13 = icmp slt i32 %12, 4                       ; [#uses = 1]
  br i1 %13, label %forbody, label %endfor

forbody:                                          ; preds = %forcond
  call void @_D6shader7builtin__T6VectorTfVmi4ZQo__T10opOpAssignVAyaa1_2aZQwMFSQCmQCi__TQCdTfVmi4ZQCnZv(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull @_D6kernel5colorS6shader7builtin__T6VectorTfVmi4ZQo, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1 @_D6kernel10multiplierS6shader7builtin__T6VectorTfVmi4ZQo) #2
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
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

; [#uses = 1]
declare %"shader.builtin.Vector!(float, 4LU).Vector"* @_D6shader7builtin__T6VectorTfVmi4ZQo6__ctorMFNcG4fXSQByQBu__TQBpTfVmi4ZQBz(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull returned, { double, double }) #2

; [#uses = 1]
declare void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2bZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #2

; [#uses = 1]
declare void @_D6shader7builtin__T4sqrtTSQzQu__T6VectorTfVmi4ZQoZQBfFQBdZQBh(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #3

; [#uses = 1]
declare void @_D6shader7builtin__T6VectorTfVmi4ZQo__T8opBinaryVAyaa1_2aZQtMFSQCjQCf__TQCaTfVmi4ZQCkZQy(%"shader.builtin.Vector!(float, 4LU).Vector"* noalias sret align 1, %"shader.builtin.Vector!(float, 4LU).Vector"* nonnull, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #2

; [#uses = 1]
declare void @_D6shader7builtin__T6VectorTfVmi4ZQo__T10opOpAssignVAyaa1_2aZQwMFSQCmQCi__TQCdTfVmi4ZQCnZv(%"shader.builtin.Vector!(float, 4LU).Vector"* nonnull, %"shader.builtin.Vector!(float, 4LU).Vector"* byval align 1) #2

; [#uses = 2]
define linkonce_odr hidden void @ldc.register_dso() {
  %1 = alloca { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** } ; [#uses = 5, size/byte = 32]
  %2 = getelementptr inbounds { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }, { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }* %1, i32 0, i32 0 ; [#uses = 1, type = i64*]
  store i64 1, i64* %2
  %3 = getelementptr inbounds { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }, { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }* %1, i32 0, i32 1 ; [#uses = 1, type = i8***]
  store i8** @ldc.dso_slot, i8*** %3
  %4 = getelementptr inbounds { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }, { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }* %1, i32 0, i32 2 ; [#uses = 1, type = %object.ModuleInfo***]
  store %object.ModuleInfo** @__start___minfo, %object.ModuleInfo*** %4
  %5 = getelementptr inbounds { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }, { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }* %1, i32 0, i32 3 ; [#uses = 1, type = %object.ModuleInfo***]
  store %object.ModuleInfo** @__stop___minfo, %object.ModuleInfo*** %5
  %6 = bitcast { i64, i8**, %object.ModuleInfo**, %object.ModuleInfo** }* %1 to i8* ; [#uses = 1]
  call void @_d_dso_registry(i8* %6)
  ret void
}

; [#uses = 1]
; Function Attrs: uwtable
declare void @_d_dso_registry(i8*) #4

; [#uses = 1]
declare i32 @_d_run_main(i32, i8**, i8*) #2

; [#uses = 0]
; Function Attrs: uwtable
define i32 @main(i32 %argc_arg, i8** %argv_arg) #0 comdat {
  %argc = alloca i32, align 4                     ; [#uses = 2, size/byte = 4]
  %argv = alloca i8**, align 8                    ; [#uses = 2, size/byte = 8]
  store i32 %argc_arg, i32* %argc
  store i8** %argv_arg, i8*** %argv
  %1 = load i32, i32* %argc                       ; [#uses = 1]
  %2 = load i8**, i8*** %argv                     ; [#uses = 1]
  %3 = call i32 @_d_run_main(i32 %1, i8** %2, i8* bitcast (i32 ({ i64, { i64, i8* }* })* @_Dmain to i8*)) #2 ; [#uses = 1]
  ret i32 %3
}

attributes #0 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #3 = { "extend"="GLSL.std.450:Sqrt" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "target-cpu"="x86-64" "target-features"="+cx16" "unsafe-fp-math"="false" }
attributes #4 = { uwtable }

!llvm.ldc.typeinfo._D19TypeInfo_S6kernel1S6__initZ = !{!0}
!llvm.ldc.typeinfo._D27TypeInfo_S6kernel9BlockName6__initZ = !{!1}
!llvm.linker.options = !{}
!llvm.ident = !{!2}

!0 = !{%object.TypeInfo_Struct* @_D19TypeInfo_S6kernel1S6__initZ, %kernel.S undef}
!1 = !{%object.TypeInfo_Struct* @_D27TypeInfo_S6kernel9BlockName6__initZ, %kernel.BlockName undef}
!2 = !{!"ldc version 1.18.0"}
