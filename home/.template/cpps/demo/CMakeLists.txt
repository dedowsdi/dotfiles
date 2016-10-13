set (DEMOES
    )

foreach(DEMO ${DEMOES})
    message("add ${DEMO}")
    add_executable(${DEMO} ${DEMO}/${DEMO}.cpp)
    target_link_libraries(${DEMO} ${COMMON_LIBS})
endforeach()
