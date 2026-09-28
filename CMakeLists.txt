cmake_minimum_required(VERSION 3.13...3.27)

# initialize the SDK based on PICO_SDK_PATH
# note: this must happen before project()
include(pico_sdk_import.cmake)

project(my_project C CXX Fortran)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

file(GLOB FORTRAN_SOURCES CONFIGURE_DEPENDS
    src/*
)

add_executable(pengco_fort
	bindings.c
    ${FORTRAN_SOURCES}
)

target_link_libraries(pengco_fort
	pico_stdlib
)

target_compile_options(pengco_fort PRIVATE
    $<$<COMPILE_LANGUAGE:Fortran>:
        -fimplicit-none
		-fmodule-private
		-Werror=implicit-interface
		-Werror=implicit-procedure
		-Werror=undefined-do-loop
		-Werror=aliasing
		-Werror=ampersand
		-Werror=conversion
		-Werror=surprising
		-Werror=c-binding-type
		-Werror=intrinsics-std
    >
)

pico_enable_stdio_usb(pengco_fort 1)
pico_enable_stdio_uart(pengco_fort 0)

pico_add_extra_outputs(pengco_fort)
