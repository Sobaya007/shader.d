cmake_minimum_required(VERSION 3.8)
project(llvm-bind)

add_library(llvm-bind src/bind.cpp)
target_compile_features(llvm-bind PRIVATE cxx_std_11)

find_package(LLVM 9.0.0 REQUIRED)

if(LLVM_FOUND)
  target_include_directories(llvm-bind PRIVATE ${LLVM_INCLUDE_DIRS})

  # リンクするライブラリ指定
  target_link_libraries(llvm-bind ${LLVM_LIBRARIES} ${LLVM_LDFLAGS})
endif(LLVM_FOUND)
